import 'package:chat_application/components/components.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/screens/chat.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/model.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return Builder(
     builder:  (context){
        CubitClass().getAllUsers();
        return BlocConsumer<CubitClass, AppState>(
          listener: (context, state) {},
          builder: (context, state) => Scaffold(
            body: ConditionalBuilder(
              builder: (context) {
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _chatItemsBuilder(cub.allUsers[index], cub , context),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: cub.allUsers.length);
              },
              condition: cub.allUsers.isNotEmpty,
              fallback: (context) =>  Center(
                child: Column(children: [
                  Image.asset('assets/images/nothing.png'),
                  const Text('there is nothing here yet')
                ],),
              ),
            ),
          ),
        );
      }
    );
  }

  _chatItemsBuilder(UserModel model , CubitClass cub , context) {
    return  Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            navigatorTo(context, Chat(model: model));
          },
          child:Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(model.profilePhoto ?? ''),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(model.name ?? ''),
            // const Spacer(),
            // IconButton(onPressed: ()=>cub.sendFriendRequest(model.uid!)
            //     , icon: const Icon(IconlyBroken.add_user))
          ],
        ),
      ),
    );
  }
}
