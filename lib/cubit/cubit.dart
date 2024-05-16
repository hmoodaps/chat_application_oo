import 'package:chat_application/components/components.dart';
import 'package:chat_application/model/model.dart';
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
        ? faveIcon = const Icon(
            Icons.favorite,
            color: Colors.red,
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
       showDialog(context: context, builder: (context){return const Center(child: CircularProgressIndicator(),);});
      _auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        getData();
       Navigator.pop(context);
        emit(SignInWithEmailAndPass(value: value));
      });
      //Navigator.pop(context);
    }on FirebaseAuthException catch (e) {
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
      profilePhoto:
          'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/employee-icon.svg',
    );
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(model.toMap())
          .then((value) {
        getData();
        emit(CreateUser());
      }).catchError((e) {
      });
    } catch (e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Model  model = Model();

  getData() async {
    // ignore: unused_local_variable
    DocumentSnapshot<Map<String, dynamic>>? snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
          model = Model.fromJson(value.data()!);
      emit(FetchUserData(model: Model(email: model!.email, userName: model!.userName)));
      return value;
    });
  }

  signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      emit(LoggedOut());
    });
  }


}
