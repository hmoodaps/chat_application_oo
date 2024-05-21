import 'dart:io';

import 'package:chat_application/components/components.dart';
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

  //check if login method is google and its the first time

  // Future<void> signInWithGoogle(context) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) => const Center(
  //             child: CircularProgressIndicator(),
  //           ));
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     User? user;
  //     await _auth.signInWithCredential(credential).then((value) async {
  //       // if ( await checkUserDataExistence(
  //       //     FirebaseAuth.instance.currentUser!.uid) == true) {
  //       //    navigatorReplace(context, Home());
  //       //   print(await checkUserDataExistence(
  //       //       FirebaseAuth.instance.currentUser!.uid));
  //       //   Navigator.pop(context);
  //       // } else {
  //       //   // navigatorReplace(context, RegisterByGooglePage());
  //       //   Navigator.pop(context);
  //       // }
  //      // Navigator.pop(context);
  //       emit(LoggedInByGoogle(value: value));
  //     });
  //   } catch (error) {
  //     Navigator.pop(context);
  //     showMessageWrong(
  //         contentType: ContentType.failure,
  //         context: context,
  //         msg: 'Something went wrong');
  //   }
  // }

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

  addUser(
      {required context,
      required String email,
      required String pass,
      required String name}) {
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
        if (kDebugMode) {
          print(e.toString());
        }
      });
      //Navigator.pop(context);
      // navigatorReplace(context, Home());
    } on FirebaseException catch (e) {
      //Navigator.pop(context);
      if (kDebugMode) {
        print('addUser2$e');
      }
    }
  }

  void createUser(String email, String name, context) {
    Model model = Model(
      email: email,
      userName: name,
      uid: _auth.currentUser!.uid,
      profilePhoto:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXksdu3aWAj1aBuoU5l7yOPx7SMr3Ee7HnAp7u4-TaJg&s',
      bio: 'Write your bio ..',
      backgroundPhoto:
          'https://lectera.com/info/storage/img/20210805/fa586bb6c04bf0989d70_808xFull.jpg',
    );
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(model.toMap())
          .then((value) {
        getData();
        emit(CreateUser());
      }).catchError((e) {});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Model model = Model();

  getData() async {
    // ignore: unused_local_variable
    DocumentSnapshot<Map<String, dynamic>>? snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      model = Model.fromJson(value.data()!);
      emit(FetchUserData(
          model: Model(email: model.email, userName: model.userName , uid: _auth.currentUser!.uid)));
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
            'users/profilePhotos/${_auth.currentUser!.uid}${Uri.file(profilePhoto!.path).pathSegments.last}')
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
            'users/backgroundPhotos/${_auth.currentUser!.uid}${Uri.file(backGroundPhoto!.path).pathSegments.last}')
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
      String? bio
      }) async {
    Model thisModel = Model(
      email: _auth.currentUser!.email,
      userName: name ?? model.userName,
      profilePhoto: profilePhotoUrl ?? model.profilePhoto,
      bio: bio ?? model.bio,
      backgroundPhoto: backgroundPhotoUrl ?? model.backgroundPhoto,
      uid : _auth.currentUser!.uid ,
    );
    emit(UpdatingProfileData());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
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
    // if (model.backgroundPhoto != null) {
    //   await _deletePreviousPhoto(model.backgroundPhoto!);
    // }
    emit(UploadPostPhoto());
    await FirebaseStorage.instance
        .ref(
            'users/PostsPhotos/${_auth.currentUser!.uid}${Uri.file(postPhoto!.path).pathSegments.last}')
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
    await FirebaseFirestore.instance.collection('users').doc(model.uid).get().then((value) async {
      PostModel postModel = PostModel(
        userName: value['userName'],
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
          emit(CreatingPostLoadingDone()); // Emit loading done state when the upload is complete
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
  Set<String> postIds = {}; // مجموعة لتتبع IDs المنشورات


  getPosts() async{
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var e in value.docs) {
        String postId = e.id; // الحصول على ID المنشور
        if (!postIds.contains(postId)) {
          posts.add(PostModel.fromJson(e.data()));
          postIds.add(postId); // إضافة ID المنشور إلى المجموعة
        }
      }
      emit(GettingPostsDone());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GettingPostsError());
    });
  }

}
