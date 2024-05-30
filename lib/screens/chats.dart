import 'package:chat_application/components/components.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass , AppState>(
      listener: (context , state){},
      builder: (context , state)=>Scaffold(
        appBar : AppBar(
          leading: IconButton(onPressed: (){
            navigatorReplace(context, const Home());
            },
            icon: const Icon(IconlyBroken.arrow_left_2),
          ),
          title: const Text('Chats'),
        ),
        body: ListView.separated(itemBuilder: (context , index)=>_chatItemsBuilder(cub , index), separatorBuilder: (context , index)=>const Divider(), itemCount: 5),
      ),
    );
  }
  _chatItemsBuilder(CubitClass cub , int index){
    return Row(children: [
      CircleAvatar(backgroundImage: NetworkImage('https://lectera.com/info/storage/img/20210805/fa586bb6c04bf0989d70_808xFull.jpg'),),
      SizedBox(width: 15,),
      Text('Ahmed'),
    ],);
  }
}
