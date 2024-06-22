import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

import 'package:chat_application/components/components.dart';
import 'package:chat_application/model/message_model.dart';
import 'package:chat_application/model/model.dart';
import 'package:chat_application/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/chats.dart';
import '../screens/firstscreen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../screens/profile.dart';
import 'appstates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CubitClass extends Cubit<AppState> {
  CubitClass() : super(InitCubit());

  //to create instance from the cubit class====================================================================================
  static CubitClass get(context) => BlocProvider.of<CubitClass>(context);

//toggle between light and dark mode depending on the device mode====================================================================================
  ThemeData? themeData = light;
  bool isDark = false;

  ThemeData? toggleLightAndDark(context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    brightness == Brightness.dark
        ? (themeData = dark, isDark = true)
        : (themeData = light, isDark = false);
    emit(ToggleLightAndDark());
    return themeData;
  }

  //navigation bar settings====================================================================================

  int currentIndex = 0;

  changBottomNavBarIndex(index) {
    currentIndex = index;
    emit(ChangBottomNavBarIndex());
  }

  List<dynamic> screens = [
    const FirstScreen(),
    const Chats(),
    const Profile(),
  ];

//Home card setting=====================================================================================================
  bool isFaveIconPressed = false;

  bool isExpanded = false;

  Icon faveIcon = const Icon(
    Icons.favorite_border,
    color: Colors.grey,
  );

  changeFaveIconPressed() {
    isFaveIconPressed = !isFaveIconPressed;
    emit(ChangFavIconPressing());
  }

  changeTextPressed() {
    isExpanded = !isExpanded;
    emit(ChangeTextPressed());
  }

  changeFavIcon() {
    isFaveIconPressed
        ? faveIcon = Icon(
            Icons.favorite,
            color: defaultPurpleColor,
          )
        : faveIcon = const Icon(
            Icons.favorite_border,
            color: Colors.grey,
          );
    emit(ChangFavIcon());
    return faveIcon;
  }

//firebase setting============================================================================================================

  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '706942053414-bjepa4bsq8jr1648ncaptq7553n44ut2.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle(context) async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) async {
        createUser(
          FirebaseAuth.instance.currentUser!.email!,
          FirebaseAuth.instance.currentUser!.displayName ?? 'New User',
          context,
        );
        Navigator.pop(context);
        emit(LoggedInByGoogle(value: value));
      });
    } catch (error) {
      Navigator.pop(context);
      showMessageWrong(
          contentType: ContentType.failure,
          context: context,
          msg: 'Something went wrong');
    }
  }

  signInWithEmailAndPass(
      {required context, required String email, required String pass}) {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      _auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        getData();
        Navigator.pop(context);
        emit(SignInWithEmailAndPass(value: value));
      });
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      // التحقق من نوع الخطأ وتحديد الرسالة المناسبة
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      showMessageWrong(
          contentType: ContentType.warning,
          context: context,
          msg: errorMessage);

      emit(SignInWithEmailAndPassFailed());
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  addUser({
    required context,
    required String email,
    required String pass,
    required String name,
  }) {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        createUser(email, name, context);
      }).catchError((e) {
        Navigator.pop(context);
        if (kDebugMode) {
          print(e.toString());
        }
        emit(AddUserError(e.toString()));
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (kDebugMode) {
        print(e.toString());
      }
      emit(AddUserError(e.toString()));
    }
  }

  void createUser(String email, String name, context) async {
    UserModel model = UserModel(
      email: email,
      // userName: userName,
      name: name,
      uid: FirebaseAuth.instance.currentUser!.uid,
      profilePhoto:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXksdu3aWAj1aBuoU5l7yOPx7SMr3Ee7HnAp7u4-TaJg&s',
      bio: 'Write your bio ..',
      backgroundPhoto:
          'https://lectera.com/info/storage/img/20210805/fa586bb6c04bf0989d70_808xFull.jpg',
    );
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(model.toMap())
          .then((value) {
        getData();
        Navigator.pop(context);
        emit(CreateUser());
      }).catchError((e) {
        Navigator.pop(context);
        if (kDebugMode) {
          print(e.toString());
        }
        emit(CreateUserError(e.toString()));
      });
    } catch (e) {
      Navigator.pop(context);
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CreateUserError(e.toString()));
    }
  }

  //getting data from firebase

  UserModel model = UserModel();

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      model = UserModel.fromJson(value.data()!);
      emit(FetchUserData(
          model: UserModel(
              email: model.email,
              //userName: model.userName,
              name: model.name,
              uid: FirebaseAuth.instance.currentUser!.uid)));
      return value;
    });
  }

  signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      emit(LoggedOut());
    });
  }

  //Image Picker===================================================================================
  File? backGroundPhoto;
  File? profilePhoto;

  Future<void> getBackGroundPhoto() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      backGroundPhoto = File(image.path);
      uploadBackgroundPhoto(backGroundPhoto);
      emit(GetBackGroundPhotoSuccess());
    } else {
      if (kDebugMode) {
        print('No Image Selected');
      }
      emit(GetBackGroundPhotoFailed());
    }
  }

  Future<void> getProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profilePhoto = File(image.path);
      uploadProfilePhoto(profilePhoto);
      emit(GetProfileImageSuccess());
    } else {
      if (kDebugMode) {
        print('No Image Selected');
      }
      emit(GetProfileImageFailed());
    }
  }

//upload profile and background photo to the firebase ================================================================
  String? profilePhotoUrl;
  String? backgroundPhotoUrl;

  Future<void> uploadProfilePhoto(File? profilePhoto) async {
    if (model.profilePhoto != null) {
      await _deletePreviousPhoto(model.profilePhoto!);
    }
    await FirebaseStorage.instance
        .ref(
            'users/profilePhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri.file(profilePhoto!.path).pathSegments.last}')
        .putFile(profilePhoto)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profilePhotoUrl = value;
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> uploadBackgroundPhoto(File? backGroundPhoto) async {
    if (model.backgroundPhoto != null) {
      await _deletePreviousPhoto(model.backgroundPhoto!);
    }
    await FirebaseStorage.instance
        .ref(
            'users/backgroundPhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri.file(backGroundPhoto!.path).pathSegments.last}')
        .putFile(backGroundPhoto)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        backgroundPhotoUrl = value;
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  //update profile ============================
  Future<void> updateProfile(
      {String? name,
      String? profilePhotoUrl,
      String? backgroundPhotoUrl,
      String? bio}) async {
    UserModel thisModel = UserModel(
      email: FirebaseAuth.instance.currentUser!.email,
      name: name ?? model.name,
      // userName: name ?? model.userName,
      profilePhoto: profilePhotoUrl ?? model.profilePhoto,
      bio: bio ?? model.bio,
      backgroundPhoto: backgroundPhotoUrl ?? model.backgroundPhoto,
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
    emit(UpdatingProfileData());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(thisModel.toMap())
        .then((value) {
      getData();
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  List<UserModel> allUsers = [];

  getAllUsers() async {
    allUsers.clear();
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uid'] != FirebaseAuth.instance.currentUser!.uid) {
          allUsers.add(UserModel.fromJson(element.data()));
          emit(SuccessGettingAllUser());
        }
      }
    }).catchError((error) {
      emit(ErrorGettingAllUser());
    });
  }

  Future<void> sendMessage({
    required String receiverUid,
    required String date,
     String ?message,
    String ? photo,
    String ? audio
  }) async{
    var msgRef =FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .collection('messages')
        .doc();
    String msgId = msgRef.id;
    MessageModel messageModel = MessageModel(
        date: DateTime.now().toString(),
        messageID: msgId,
        photo: photo ?? '',
        message: message ?? '',
        showDelIcon: false,
        receiverUid: receiverUid,
        senderUid: FirebaseAuth.instance.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .collection('messages')
        .doc(msgId)
        .set(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError());
      if (kDebugMode) {
        print(error.toString());
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUid)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(msgId)
        .set(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }



  void showDeleteMsgButton(MessageModel message) {
    // إخفاء أيقونة الحذف لجميع الرسائل
    for (var msg in messageModelList) {
      msg.showDelIcon = false;
    }

    // إظهار أيقونة الحذف للرسالة المحددة
    final index = messageModelList.indexOf(message);
    if (index != -1) {
      messageModelList[index].showDelIcon = true;
      emit(ShowDeleteMsgButton());
    }
  }
  void hideDeleteMsgButton() {
    // إخفاء أيقونة الحذف لجميع الرسائل
    for (var msg in messageModelList) {
      msg.showDelIcon = false;
    }
    emit(HideDeleteMsgButton());

  }



  List<MessageModel> messageModelList = [];

  getMessages(String receiverUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .collection('messages')
        .orderBy('date', descending: false) // ترتيب الرسائل حسب الوقت بشكل تصاعدي
        .snapshots()
        .listen((event) {
      messageModelList = [];
      for (var element in event.docs) {
        messageModelList.add(MessageModel.fromJson(element.data()));
      }
      messageModelList.sort((a, b) => a.date!.compareTo(b.date!));
      emit(GetMessages());
    });
  }

  deleteMessagesFromMySide({required String hisId}) async {
    try {
      // احصل على جميع الرسائل من المحادثة
      var messages = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(hisId)
          .collection('messages')
          .get();

      // حذف كل رسالة بشكل متسلسل
      for (var message in messages.docs) {
        await message.reference.delete();
      }

      // بعد حذف جميع الرسائل، احذف مستند المحادثة
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(hisId)
          .delete();

      getMessages(hisId);
      emit(DeleteMessagesFromMySide());
    } catch (error) {
      print('Error deleting messages from my side: $error');
    }
  }


  deleteMessagesFromBothSides({required String hisId}) async {
    try {
      // احصل على جميع الرسائل من المحادثة في جانبي
      var myMessages = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(hisId)
          .collection('messages')
          .get();

      // احصل على جميع الرسائل من المحادثة في جانبه
      var hisMessages = await FirebaseFirestore.instance
          .collection('users')
          .doc(hisId)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .get();

      // حذف كل رسالة في جانبي بشكل متسلسل
      for (var message in myMessages.docs) {
        await message.reference.delete();
      }

      // حذف كل رسالة في جانبه بشكل متسلسل
      for (var message in hisMessages.docs) {
        await message.reference.delete();
      }

      // بعد حذف جميع الرسائل، احذف مستند المحادثة من كلا الجانبين
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(hisId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(hisId)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      getMessages(hisId);
      emit(DeleteMessagesFromBothSides());
    } catch (error) {
      print('Error deleting messages from both sides: $error');
    }
  }

  Future <void> deleteOneMessageFromMySide({required String hisId, required String messageID}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(hisId)
          .collection('messages')
          .doc(messageID)
          .delete();
      getMessages(hisId);
      emit(DeleteOneMessageFromMySide());
    } catch (error) {
      print('Error deleting one message from my side: $error');
    }
  }

  deleteOneMessageFromBothSides({required String hisId, required String messageID}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(hisId)
          .collection('messages')
          .doc(messageID)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(hisId)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(messageID)
          .delete();
      getMessages(hisId);
      emit(DeleteOneMessageFromBothSides());
    } catch (error) {
      print('Error deleting one message from both sides: $error');
    }
  }

  String? chatPhotoUrl;
  Future<void> uploadChatPhoto(File? chatPhoto) async {
    emit(UploadPostPhoto());
    await FirebaseStorage.instance
        .ref(
        'users/chatPhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri.file(chatPhoto!.path).pathSegments.last}')
        .putFile(chatPhoto)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        chatPhotoUrl = value;
        emit(ChatPhotoUploaded());
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
  Future<void> deleteChatPhoto(File? chatPhoto) async {
    emit(DeletingPhoto());
    await FirebaseStorage.instance
        .ref(
        'users/chatPhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri.file(chatPhoto!.path).pathSegments.last}')
        .delete()
        .then((value) {
        chatPhotoUrl = null;
        chatPhoto = null ;
        emit(ChatPhotoDeleted());

    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }



  File? chatPhoto;
  Future<void> getChatPhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      chatPhoto = File(image.path);
      chatPhoto = await cropImage(image: chatPhoto!);
      emit(GetChatPhotoSuccess());
    } else {
      if (kDebugMode) {
        print('No Image Selected');
      }
      emit(GetChatPhotoFailed());
    }
  }
  Future<File ? >cropImage({required File image})async{
    CroppedFile  ? croppedImage = await ImageCropper().cropImage(sourcePath: image.path);
    return File(croppedImage!.path);
  }


  // posts ===============================================================================================================================
  //create post =======================================================================================
  Future<void> createPost({
    String? photo,
    String? text,
  }) async {
    emit(CreatingPostLoading());
    try {
      // استخدام doc() لإنشاء معرف عشوائي جديد
      var postRef = FirebaseFirestore.instance.collection('posts').doc();
      // الهوية الفريدة للمستند الذي تم إنشاؤه
      String postId = postRef.id;
      // إنشاء نموذج PostModel بدون قائمة الإعجاب حاليًا
      PostModel postModel = PostModel(
        dateTime: DateTime.now(),
        postId: postId,
        uid: _auth.currentUser!.uid,
        photo: photo,
        text: text,
      );
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(postModel.toMap())
          .then((value) async {
        emit(PostCreated());
      });
      emit(PostCreatedSuccessfully());
    } catch (error) {
      // إصدار حدث فشل الإنشاء مع تسجيل الخطأ
      if (kDebugMode) {
        print(error.toString());
      }
      emit(PostCreatedFailed());
    } finally {
      // إصدار حدث اكتمال عملية الإنشاء
      emit(CreatingPostLoadingDone());
    }
  }

  //delete post =======================================================================================
  deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) async {
      await getPosts();
      emit(DeletePost());
    });
    emit(DeletePostSuccess());
  }

  //post photos =======================================================================================
  //upload post photo to the firebase ================================================================
  String? postPhotoUrl;

  Future<void> uploadPostPhoto(File? postPhoto) async {
    emit(UploadPostPhoto());
    await FirebaseStorage.instance
        .ref(
            'users/PostsPhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri.file(postPhoto!.path).pathSegments.last}')
        .putFile(postPhoto)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postPhotoUrl = value;
        emit(PhotoUploaded());
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  //delete photo from the post ====================================================================
  deletePhotoFromThePost() {
    postPhoto = null;
    emit(DeletePhotoFromThePost());
  }

  //deletePreviousPhoto =====================================================================
  Future<void> _deletePreviousPhoto(String photoUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(photoUrl).delete();
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting previous photo: $error');
      }
    }
  }

  //Image Picker==============
  File? postPhoto;
  Future<void> getPostPhoto() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      postPhoto = File(image.path);
      emit(GetPostPhotoSuccess());
    } else {
      if (kDebugMode) {
        print('No Image Selected');
      }
      emit(GetChatPhotoFailed());
    }
  }

  //getPosts ======================================================================================
  List<PostModel> posts = [];
  List<PostModel> myPosts = [];

  List<UserModel> fans = [];

  Future getPosts() async {
    posts.clear();
    getAllUsers();
    emit(GettingPostsLoading());
    try {
      await FirebaseFirestore.instance.collection('posts').get().then((value) {
        for (var e in value.docs) {
          PostModel thisPost = PostModel.fromJson(e.data());
          if (!posts.contains(thisPost)) {
            posts.add(thisPost);
            updateLikes(thisPost.postId!);
          }
        }
        posts.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

        emit(GettingPostsSuccess());
      });
      getMyPosts();
      emit(GettingPostsDone());
    } catch (error) {
      emit(GettingPostsError());
      if (kDebugMode) {
        print('Error getting posts: $error');
      }
    }
  }

  getMyPosts() async {
    myPosts.clear();
    emit(GettingMyPostsLoading());
    try {
      await FirebaseFirestore.instance.collection('posts').get().then((value) {
        for (var e in value.docs) {
          PostModel thisPost = PostModel.fromJson(e.data());
          if (!myPosts.contains(thisPost) &&
              thisPost.uid == _auth.currentUser!.uid) {
            myPosts.add(thisPost);
            updateLikes(thisPost.postId!);
          }
        }
        myPosts.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));

        emit(GettingMyPostsSuccess());
      });
      emit(GettingMyPostsDone());
    } catch (error) {
      emit(GettingPostsError());
      if (kDebugMode) {
        print('Error getting posts: $error');
      }
    }
  }

  Future<void> postLikes({
    required String postId,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      bool hasLike = await hasLiked(postId);

      if (hasLike) {
        // إذا كان المستخدم قد قام بالإعجاب، عليك إزالته
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(currentUserId)
            .delete();
      } else {
        // إضافة الإعجاب إذا لم يكن المستخدم قد قام بالإعجاب
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(currentUserId)
            .set(model.toMap());
      }

      // بعد ذلك، يجب تحديث عدد الإعجابات في مودل البوست
      await updateLikes(postId);
    } catch (error) {
      if (kDebugMode) {
        print('Error liking post: $error');
      }
    }
  }

  Future<void> updateLikes(String postId) async {
    try {
      var likesSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .get();

      List<String> likedUserIds = [];
      for (var doc in likesSnapshot.docs) {
        likedUserIds.add(doc.id);
      }

      // تحديث مودل البوست في قائمة الإعجابات
      var postIndex = posts.indexWhere((post) => post.postId == postId);
      if (postIndex != -1) {
        posts[postIndex].likesUserIds = likedUserIds;
      }
      var myPostIndex = myPosts.indexWhere((post) => post.postId == postId);
      if (myPostIndex != -1) {
        myPosts[myPostIndex].likesUserIds = likedUserIds;
      }

      // إعلام التطبيق بنجاح التحديث
      emit(LikeSuccess());
    } catch (error) {
      if (kDebugMode) {
        print('Error updating likes: $error');
      }
    }
  }

  Future<bool> hasLiked(
    String postId,
  ) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(_auth.currentUser!.uid)
          .get();
      return docSnapshot.exists;
    } catch (error) {
      if (kDebugMode) {
        print('Error checking like: $error');
      }
      return false;
    }
  }

//get posts fans =================================================================================
  Future<void> getFans(String postID) async {
    fans.clear();
    try {
      final value = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .collection('likes')
          .get();

      for (var e in value.docs) {
        UserModel user = await getUserInfo(e.id);
        if (!fans.contains(user)) {
          fans.add(user);
        }
      }
      emit(GetFans());
    } catch (error) {
      // معالجة الخطأ هنا إذا لزم الأمر
    }
  }

  //get user by uid ==========================================================
  Future<UserModel> getUserInfo(String userID) async {
    UserModel user;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userID)
          .get();
      Map<String, dynamic>? userData = snapshot.data();
      if (userData != null) {
        user = UserModel.fromJson(userData);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
    return user;
  }

//
// final record  = AudioRecorder();
// String path = '';
// String url = '';
// bool isRecording = false ;
//   Future<void>  startRecording()async{
//   final location = await getApplicationDocumentsDirectory();
//   String name = const Uuid().v1();
//   if(await record.hasPermission()){
//     await record.start(const RecordConfig(), path: '${location.path}$name.m4a').then((value){
//       isRecording = true ;
//       emit(StartRecording());
//     });
//   }
// }
// Future<void> stopRecording()async{
//  await record.stop().then((value){
//     path = value ! ;
//     isRecording = false ;
//     emit(StopRecording());
//   });
//
// }
//   Future<void>  uploadAudio(String path)async{
//   emit(UploadAudioStarted());
//
//   FirebaseStorage.instance.ref('voices/').putFile(File(path)).then((value) async {
//     url = await value.ref.getDownloadURL();
//     emit(AudioUploaded());
//   }).catchError((e){});
// }



}
