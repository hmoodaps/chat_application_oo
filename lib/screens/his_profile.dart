import 'package:chat_application/components/components.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/model/model.dart';
import 'package:chat_application/screens/chat.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../model/post_model.dart';


class HisProfile extends StatelessWidget {
  final UserModel model ;
  final List<PostModel> posts ;
  const HisProfile({super.key , required this.model,  required this.posts} );

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
        return BlocConsumer<CubitClass, AppState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: Colors.transparent,
                  title: Text(
                    'S t o r y t e l l i n g',
                    style: TextStyle(
                        fontFamily: 'rocky',
                        fontSize: 12,
                        color: defaultPurpleColor),
                  ),
                  centerTitle: false,
                  leading: IconButton(onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                    icon: const Icon(IconlyBroken.arrow_left),
                  ),
                ),

                body: CustomScrollView(
                  slivers:[
                    SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.zero,
                          height: MediaQuery.of(context).size.height / 3,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              model.backgroundPhoto == null
                                  ? Image.asset('assets/images/person.png')
                                  : Image.network(
                                model.backgroundPhoto!,
                                height:
                                MediaQuery.of(context).size.height / 3.7,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 64,
                                      backgroundColor: Colors.white,
                                    ),
                                    const CircleAvatar(
                                      radius: 62,
                                      backgroundColor: Colors.blue,
                                    ),
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: model.backgroundPhoto ==
                                          null
                                          ? const AssetImage(
                                          'assets/images/person.png')
                                      as ImageProvider
                                          : NetworkImage(model.profilePhoto!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          model.name ?? '',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          model.bio ?? "",
                          maxLines: 3,
                          style: TextStyle(color: defaultBlueColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(onTap: (){
                        navigatorTo(context, Chat(model: model,));
                                                },child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  child: Container(
decoration: BoxDecoration(color: Colors.blue , borderRadius: BorderRadius.circular(20)),
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 40,
                                                                           child:const Center(child:  Text('Chat')),),
                                                ),),
                        const SizedBox(
                          height: 20,
                        ),
                     const Text('Post'),
                        Text(posts.length.toString()),
                      ],
                    ),
                  ),

                    posts.isEmpty
                        ? SliverList(delegate: SliverChildBuilderDelegate(childCount: 1 ,(context , index)=> const Center(child: Text('There is not posts yet '),)))
                        : SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => postItemBuilder(cub, context, index),
                        childCount: posts.length,
                      ),
                    ),
                  ]
                ),
              );
            },
            listener: (context, state) {});
  }
  Widget postItemBuilder( CubitClass cub , BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Column(
          children: [
             postHeader(
            context, model, index, posts[index], cub),
            cardBody(cub, posts[index], context),
            cardBottom(cub, index, posts[index])
          ],
        ),
      ),
    );
  }

  Widget postHeader(
      context, UserModel user, int index, PostModel model, CubitClass cub) {
    bool canDel = false;
    if (FirebaseAuth.instance.currentUser!.uid == model.uid) canDel = true;
    return Card(
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
                handleDeletePost(model, cub);
              } else if (value == 'likes') {
                handleShowLikes(context, cub, model);

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
    );
  }

  void handleDeletePost(PostModel model, CubitClass cub) {
    cub.deletePost(model.postId!);
  }

  handleShowLikes(context, CubitClass cub, PostModel model) {
    cub.getFans(model.postId!).then((value){
      showModalBottomSheet(

          backgroundColor: Colors.white,
          context: context,
          builder: (context) => _likerDialog(context, cub, model));
    });

  }


  _likerDialog(BuildContext context, CubitClass cub, PostModel model) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/2,
      child: ConditionalBuilder(
        condition: cub.fans.isNotEmpty,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height-150,
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
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

  Widget cardBody(CubitClass cub, PostModel model, BuildContext context) {
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

  Widget cardBottom(CubitClass cub, int index, PostModel model) {
    return Card(
      child: Row(
        children: [
          onLikePressed(cub: cub, postId: model.postId!),
          Text(
            model.likesUserIds?.length.toString() ?? '0',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget onLikePressed({
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
