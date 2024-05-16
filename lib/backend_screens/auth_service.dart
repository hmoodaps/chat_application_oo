import 'package:chat_application/backend_screens/toggle_between_login_and_register_service.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/home.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     CubitClass cub = CubitClass.get(context);
//     return BlocConsumer<CubitClass, AppState>(
//       listener: (context, state) {},
//       builder: (context, state) =>  Scaffold(
//         body :FirebaseAuth.instance.currentUser == null ?const ToggleBetweenLoginAndRegisterClass()  :const ToHomeOrNot(),
//       ),
//     );
//   }
// }

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     CubitClass cub = CubitClass.get(context);
//     return BlocConsumer<CubitClass, AppState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//            if (snapshot.hasData) {
//               cub.getData();
//               // تأخير الانتقال إلى Home لمدة 3 ثوانٍ
//               Future.delayed(const Duration(seconds: 3), () {
//                 return const Center(child: CircularProgressIndicator());
//               });
//               return Home();
//            } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               return const ToggleBetweenLoginAndRegisterClass();
//             }
//           },
//         );
//       },
//     );
//   }
// }
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitClass, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                return Home();
            } else {
              return const ToggleBetweenLoginAndRegisterClass();
            }
          },
        );
      },
    );
  }
}
