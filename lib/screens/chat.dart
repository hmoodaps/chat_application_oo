import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../model/model.dart';

class Chat extends StatelessWidget {
  final Model? model;

  const Chat({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(model!.profilePhoto ?? ''),
              radius: 20,
            ),
            const SizedBox(width: 8,),
            Text(model!.userName ?? '' , style: const TextStyle(fontSize: 15),),
          ],),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(IconlyBroken.arrow_left_2),),
          backgroundColor: Colors.blue,
        ),

      ),
    );
  }
}
