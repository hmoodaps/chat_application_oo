// import 'package:chat_application/components/components.dart';
// import 'package:chat_application/screens/home.dart';
// import 'package:chat_application/screens/registerbygooglepage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../cubit/appstates.dart';
// import '../cubit/cubit.dart';
//
// class ToHomeOrNot extends StatelessWidget {
//   const ToHomeOrNot({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     CubitClass cub = CubitClass.get(context);
//     return BlocConsumer<CubitClass, AppState>(
//         listener: (context, state) {},
//         builder: (context, state)  {
//           return Scaffold(
//             body: ( cub.checkUserDataExistence(
//                     FirebaseAuth.instance.currentUser!.uid))
//                 ? Home()
//                 : RegisterByGooglePage(),
//           );
//         });
//   }
// }
