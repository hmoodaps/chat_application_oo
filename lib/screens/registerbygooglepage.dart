// import 'package:chat_application/backend_screens/shared.dart';
// import 'package:chat_application/components/components.dart';
// import 'package:chat_application/cubit/appstates.dart';
// import 'package:chat_application/cubit/cubit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconly/iconly.dart';
//
// import 'home.dart';
//
// class RegisterByGooglePage extends StatelessWidget {
//   RegisterByGooglePage({super.key});
//
//   final TextEditingController userNameCo = TextEditingController(
//       text: FirebaseAuth.instance.currentUser!.displayName!);
//   final auth = FirebaseAuth.instance.currentUser;
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     CubitClass cub = CubitClass.get(context);
//     return BlocConsumer<CubitClass, AppState>(
//         builder: (context, state) {
//           return Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 onPressed: () {
//                   cub.signOut(context);
//                 },
//                 icon: const Icon(Icons.sign_language),
//               ),
//             ),
//             floatingActionButton: GestureDetector(
//               onTap: ()  async{
//                 if(formKey.currentState!.validate()){
//                   cub.userName = userNameCo.text;
//                   cub.addUser(context: context, email: FirebaseAuth.instance.currentUser!.email!, pass: '123456', name: userNameCo.text);
//                   // navigatorReplace(context, Home());
//
//                 }
//               },
//               child: Container(
//                 width: 120,
//                 height: 60,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.pink.shade300),
//                 child: const Center(child: Text('Next -->')),
//               ),
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(25.0),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Center(
//                         child: Text(
//                       'just the last step',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
//                     )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const Center(
//                         child: Text(
//                       'we will create your account ',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//                     )),
//                     const SizedBox(
//                       height: 50,
//                     ),
//                     const Text(
//                       'put user name and create a password : ',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       controller: userNameCo,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         hintText: 'write your userName',
//                         prefixIconColor: defaultColor,
//                         hintStyle: TextStyle(
//                             color: cub.isDark
//                                 ? Colors.grey.shade800
//                                 : Colors.grey.shade300),
//                         prefixIcon: const Icon(IconlyBroken.profile),
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'This filed is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//         listener: (context, state) {});
//   }
// }
