// import 'package:chat_application/cubit/appstates.dart';
// import 'package:chat_application/cubit/cubit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// class Friends extends StatelessWidget {
//   const Friends({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     CubitClass cub = CubitClass.get(context);
//     return BlocConsumer<CubitClass , AppState>(builder: (context , state){
//       return Scaffold(
//         body: StreamBuilder(
//           stream: cub.getFriends(FirebaseAuth.instance.currentUser!.uid),
//           builder: (context, snapshot) {
//             var friends = snapshot.data?.docs;
//             return ListView.builder(
//               itemCount: friends?.length,
//               itemBuilder: (context, index) {
//                 var friend = friends?[index];
//                 return ListTile(
//                   title: Center(child: Text(friend!.id , style: TextStyle(color: Colors.white),)),
//                 );
//               },
//             );
//           },
//         )
//         ,
//       ); },listener: (context , state){},  );
//   }
// }
//
// class FriendReq extends StatelessWidget {
//   const FriendReq({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     CubitClass cub = CubitClass.get(context);
//     return BlocConsumer<CubitClass , AppState>(builder: (context , state){
//       return Scaffold(
//         body: StreamBuilder(
//           stream: cub.getIncomingFriendRequests(FirebaseAuth.instance.currentUser!.uid),
//           builder: (context, snapshot) {
//             var requests = snapshot.data?.docs;
//             return ListView.builder(
//               itemCount: requests?.length,
//               itemBuilder: (context, index) {
//                 var request = requests?[index];
//                 return ListTile(
//                   title: Text(request?['from']),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.check),
//                         onPressed: () {
//                           cub.acceptFriendRequest(request!.id, FirebaseAuth.instance.currentUser!.uid, request['from']);
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () {
//                           cub.rejectFriendRequest(request!.id);
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         )
//         ,
//       );
//     }, listener: (context , state){});
//   }
// }
//
