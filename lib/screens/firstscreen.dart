import 'package:chat_application/components/components.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/model/model.dart';
import 'package:chat_application/screens/his_profile.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../model/post_model.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    cub.posts.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));

    return BlocConsumer<CubitClass, AppState>(
      builder: (context, state) => ConditionalBuilder(
        condition: cub.posts.isNotEmpty,
        builder: (context) {
          return ListView.separated(
            reverse: false,
            itemBuilder: (context, index) =>
                _postItemBuilder(cub, context, index),
            separatorBuilder: (context, index) => const SizedBox(height: 25),
            itemCount: cub.posts.length,
          );
        },
        fallback: (context) => Center(
          child: Column(
            children: [
              Image.asset('assets/images/nothing.png'),
              const Text('There is nothing here yet'),
            ],
          ),
        ),
      ),
      listener: (context, state) {},
    );
  }
  Widget _postItemBuilder(CubitClass cub, BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Column(
          children: [
            FutureBuilder<UserModel>(
                future: cub.getUserInfo(cub.posts[index].uid!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    UserModel user = snapshot.data!;
                    return _postHeader(
                        context, user, index, cub.posts[index], cub);
                  }
                }),
            _cardBody(cub, cub.posts[index], context),
            _cardBottom(cub, index, cub.posts[index])
          ],
        ),
      ),
    );
  }

  Widget _postHeader(
      context, UserModel user, int index, PostModel model, CubitClass cub) {
    bool canDel = false;
    if (FirebaseAuth.instance.currentUser!.uid == model.uid) canDel = true;
    return InkWell(
      onTap: () async {
        showDialog(context: context, builder: (context)=>const Center(child: CircularProgressIndicator(),));
        List<PostModel> hisPosts = [];
        for(var e in cub.posts){
          if(e.uid == user.uid && !hisPosts.contains(e)){
            hisPosts.add(e);
          }
        }
        if(user.uid == cub.model.uid){
          cub.changBottomNavBarIndex(4);
        }else{
          navigatorTo(context, HisProfile(model: user, posts: hisPosts));

        }
      },
      child: Card(
        child: Row(
          children: [
            CircleAvatar(
              radius: 17.5,
              backgroundImage: NetworkImage(user.profilePhoto!),
            ),
            const SizedBox(width: 7),
            Text(
              user.name!,
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (value) async {
                if (value == 'delete' && canDel == true) {
                  _handleDeletePost(model, cub);
                } else if (value == 'likes') {
                  _handleShowLikes(context, cub, model,user);

                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyle(color: canDel ? Colors.black : Colors.white),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'likes',
                  child: Text('Likes'),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleDeletePost(PostModel model, CubitClass cub) {
    cub.deletePost(model.postId!);
  }

  _handleShowLikes(context, CubitClass cub, PostModel model , UserModel user) {
    cub.getFans(model.postId!).then((value){
      showModalBottomSheet(

          backgroundColor: Colors.white,
          context: context,
          builder: (context) => _likerDialog(context, cub, model,));
    });

  }


  _likerDialog(BuildContext context, CubitClass cub, PostModel model ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/2,
      child: ConditionalBuilder(
        condition: cub.fans.isNotEmpty,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height-150,
          child: ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    List<PostModel> hisPosts = [];
                    for(var e in cub.posts){
                      if(e.uid == cub.fans[index].uid && !hisPosts.contains(e)){
                        hisPosts.add(e);
                      }
                    }
                    if(cub.fans[index].uid == cub.model.uid){
                      Navigator.pop(context);

                      cub.changBottomNavBarIndex(4);
                    }else{
                      navigatorTo(context, HisProfile(model: cub.fans[index], posts: hisPosts));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(cub.fans[index].profilePhoto!),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(cub.fans[index].name! , style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: cub.fans.length),
        ),
        fallback: (context) => Center(
          child :  Center (child : Column(
            children: [
              const Text('Nothing here yet'),
              Image.asset('assets/images/nothing.png'),
            ],
          ),
          ),),
      ),
    );
  }

  Widget _cardBody(CubitClass cub, PostModel model, BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.photo != null && model.photo!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: double.infinity, // Full width of the card
                height: MediaQuery.of(context).size.height /
                    4, // Fixed height for the image
                child: Image.network(
                  model.photo!,
                  fit: BoxFit.cover, // Adjust the image fit as needed
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                cub.changeTextPressed();
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Text(
                  model.text ?? '',
                  maxLines: cub.isExpanded ? 100 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardBottom(CubitClass cub, int index, PostModel model) {
    return Card(
      child: Row(
        children: [
          _onLikePressed(cub: cub, postId: model.postId!),
          Text(
            model.likesUserIds?.length.toString() ?? '0',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _onLikePressed({
    required CubitClass cub,
    required String postId,
  }) {
    return FutureBuilder<bool>(
      future: cub.hasLiked(postId),
      builder: (context, snapshot) {
        bool hasLiked = snapshot.data ?? false;
        return IconButton(
          onPressed: () async {
            await cub.postLikes(postId: postId);
          },
          icon: Icon(
            IconlyBold.heart,
            color: hasLiked ? Colors.red : Colors.grey,
          ),
        );
      },
    );
  }
}


