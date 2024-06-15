import 'dart:io';

import 'package:chat_application/components/components.dart';
import 'package:chat_application/model/message_model.dart';
import 'package:chat_application/model/model.dart';
import 'package:chat_application/model/post_model.dart';
import 'package:chat_application/screens/calls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/chats.dart';
import '../screens/firstscreen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../screens/hidden.dart';
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
    Brightness brightness = MediaQuery
        .of(context)
        .platformBrightness;
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

  changPage(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState!.openDrawer();
  }

  List<dynamic> screens = [
    const FirstScreen(),
    const Chats(),
    const Hidden(),
    const Calls(),
    Profile(),
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
        builder: (context) =>
        const Center(
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
            FirebaseAuth.instance.currentUser!.email!, FirebaseAuth.instance.currentUser!.displayName ?? 'New User', context,
            model.userName);
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
      //Navigator.pop(context);
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
    required String userName
  }) {
    showDialog(
        context: context,
        builder: (context) =>
        const Center(
          child: CircularProgressIndicator(),
        ));
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        createUser(email, name, userName, context);
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

  void createUser(String email, String name, String userName, context) async {
    Model model = Model(
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


  // Future<bool> isUsernameTaken(String username) async {
  //   var querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('userName', isEqualTo: username)
  //       .get();
  //
  //   return querySnapshot.docs.isNotEmpty;
  // }

  //getting data from firebase

  Model model = Model();

  getData() async {
    await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      model = Model.fromJson(value.data()!);
      emit(FetchUserData(
          model: Model(
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
    if (model.backgroundPhoto != null) {
      await _deletePreviousPhoto(model.backgroundPhoto!);
    }
    await FirebaseStorage.instance
        .ref(
        'users/profilePhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri
            .file(profilePhoto!.path)
            .pathSegments
            .last}')
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
        'users/backgroundPhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri
            .file(backGroundPhoto!.path)
            .pathSegments
            .last}')
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
  Future<void> updateProfile({String? name,
    String? profilePhotoUrl,
    String? backgroundPhotoUrl,
    String? bio}) async {
    Model thisModel = Model(
      email: FirebaseAuth.instance.currentUser!.email,
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

  //posts handling ======================================================================
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
      emit(GetPostPhotoFailed());
    }
  }

//upload post photo to the firebase ================================================================
  String? postPhotoUrl;

  Future<void> uploadPostPhoto(File? postPhoto) async {
    emit(UploadPostPhoto());
    await FirebaseStorage.instance
        .ref(
        'users/PostsPhotos/${FirebaseAuth.instance.currentUser!.uid}${Uri
            .file(postPhoto!.path)
            .pathSegments
            .last}')
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

  Future<void> createPost({
    String? photo,
    String? text,
  }) async {
    emit(CreatingPostLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uid)
        .get()
        .then((value) async {
      PostModel postModel = PostModel(
        userName: value['name'],
        profilePhoto: value['profilePhoto'],
        uid: model.uid,
        photo: postPhotoUrl,
        text: text,
      );

      if (postPhoto == null) {
        postPhotoUrl == '';
        emit(CreatingPost());
        await FirebaseFirestore.instance
            .collection('posts')
            .add(postModel.toMap())
            .then((value) {
          emit(PostCreatedSuccessfully());
        }).catchError((error) {
          if (kDebugMode) {
            print(error.toString());
          }
          emit(PostCreatedFailed());
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .add(postModel.toMap())
            .then((value) {
          emit(PostWithPhotoCreatedSuccessfully());
        }).catchError((error) {
          if (kDebugMode) {
            print(error.toString());
          }
          emit(PostCreatedFailed());
        }).whenComplete(() {
          emit(CreatingPostLoadingDone());
        });
      }
    });
  }

  // deletePhotoFromThePost==============================================================
  deletePhotoFromThePost() {
    postPhoto = null;
    emit(DeletePhotoFromThePost());
  }

//get posts===========================================================
  List<PostModel> posts = [];
  List<String> postIds = [];
  List<int> likes = [];

  getPosts() async {
    await FirebaseFirestore.instance.collection('posts') .orderBy('date', descending: false).get().then((value) {
      for (var e in value.docs) {
        String postId = e.id;
        if (!postIds.contains(postId)) {
          posts.add(PostModel.fromJson(e.data()));
          postIds.add(postId);
        }
        e.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
        });
      }
      emit(GettingPostsDone());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GettingPostsError());
    });
  }

  postLikes(String postId) async {
    var docRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model.uid);
    var getDocs = await docRef.get();
    if (getDocs.exists) {
      docRef.delete();
    } else {
      docRef.set({'likes': true});
    }

    updateLikes(postId);
  }

  updateLikes(String postId) async {
    var likesSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get();

    int likeCount = likesSnapshot.docs.length;

    int postIndex = postIds.indexOf(postId);
    if (postIndex != -1) {
      likes[postIndex] = likeCount;
      emit(LikeSuccess());
    }
  }

  Future<bool> hasLiked(String postId) async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model.uid)
        .get();
    return docSnapshot.exists;
  }


  List<Model> allUsers = [];

  getAllUsers() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uid'] != FirebaseAuth.instance.currentUser!.uid) {
          allUsers.add(Model.fromJson(element.data()));
          emit(SuccessGettingAllUser());
        }
      }
    }).catchError((error) {
      emit(ErrorGettingAllUser());
    });
  }

  //friends =======================================================
//create friends collection in the firebase ===

  // Future<void> sendFriendRequest( String friendUserId) async {
  //   await FirebaseFirestore.instance.collection('friendRequests').add({
  //     'from': FirebaseAuth.instance.currentUser!.uid,
  //     'to': friendUserId,
  //     'status': 'pending', // حالة الطلب، يمكن أن تكون 'pending'، 'accepted'، أو 'rejected'
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }
  // Stream<QuerySnapshot> getIncomingFriendRequests(String currentUserId) {
  //   return FirebaseFirestore.instance
  //       .collection('friendRequests')
  //       .where('to', isEqualTo: currentUserId)
  //       .where('status', isEqualTo: 'pending')
  //       .snapshots();
  // }
  // Future<void> acceptFriendRequest(String requestId, String currentUserId, String friendUserId) async {
  //   // تحديث حالة الطلب إلى 'accepted'
  //   await FirebaseFirestore.instance.collection('friendRequests').doc(requestId).update({
  //     'status': 'accepted',
  //   });
  //
  //   // إضافة المستخدمين إلى قائمة الأصدقاء
  //   await FirebaseFirestore.instance.collection('friends').doc(currentUserId).collection('userFriends').doc(friendUserId).set({});
  //   await FirebaseFirestore.instance.collection('friends').doc(friendUserId).collection('userFriends').doc(currentUserId).set({});
  // }
  //
  // Future<void> rejectFriendRequest(String requestId) async {
  //   // تحديث حالة الطلب إلى 'rejected'
  //   await FirebaseFirestore.instance.collection('friendRequests').doc(requestId).update({
  //     'status': 'rejected',
  //   });
  // }
  // Stream<QuerySnapshot> getFriends(String currentUserId) {
  //   return FirebaseFirestore.instance
  //       .collection('friends')
  //       .doc(currentUserId)
  //       .collection('userFriends')
  //       .snapshots();
  // }

  sendMessage({
    required String receiverUid,
    required String date,
    required String message,
  }) {
    MessageModel messageModel = MessageModel(date: DateTime.now().toString(),
        message: message,
        receiverUid: receiverUid,
        senderUid: FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats').doc(receiverUid).collection('messages').add(
        messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError());
      if (kDebugMode) {
        print(error.toString());
      }
    });
    FirebaseFirestore.instance.collection('users').doc(receiverUid).collection(
        'chats').doc(FirebaseAuth.instance.currentUser!.uid).collection('messages').add(
        messageModel.toMap()).then((value) {
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  List <MessageModel> messageModelList = [];

  getMessages(String receiverUid) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats').doc(receiverUid).collection('messages')
        .orderBy('date', descending: false) // ترتيب الرسائل حسب الوقت بشكل تصاعدي
        .snapshots()
        .listen((event) {
      messageModelList = [];
      for (var element in event.docs) {
        messageModelList.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessages());
    });
  }


}
