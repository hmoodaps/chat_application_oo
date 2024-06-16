import 'package:chat_application/components/components.dart';
import 'package:chat_application/model/post_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../cubit/appstates.dart';
import '../cubit/cubit.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    cub.posts.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
    return Builder(
      builder: (context) {
        cub.getPosts();
        return BlocConsumer<CubitClass, AppState>(
          listener: (context, state) {},
          builder: (context, state) => Scaffold(
            body: ConditionalBuilder(
              fallback: (context) => Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/nothing.png'),
                    const Text('there is nothing here yet'),
                  ],
                ),
              ),
              condition: cub.posts.isNotEmpty,
              builder: (context) => RefreshIndicator(
                onRefresh: () async => await cub.getPosts(),
                child: ListView.separated(
                  reverse: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 25,
                  ),
                  itemCount: cub.posts.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Card(
                              child: postHeader(cub, cub.posts[index], index ),
                            ),
                            Card(
                              child: cardBody(cub, cub.posts[index], index),
                            ),
                            Card(
                              child: cardBottom(cub, index, state),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget postHeader(CubitClass cub, PostModel model, int index ) {
    String postId = cub.postIds[index];
    bool canDelete = model.uid == FirebaseAuth.instance.currentUser!.uid;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: model.profilePhoto == null
              ? const AssetImage('assets/images/profile.jpg') as ImageProvider
              : NetworkImage(model.profilePhoto!),
        ),
        const SizedBox(width: 10),
        Text(
          model.userName ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        const Spacer(),
        if (canDelete)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete' && canDelete) {
                cub.deletePost(postId);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
             const  PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete',
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget cardBody(CubitClass cub, PostModel model, int index) {
    String postId = cub.postIds[index];
    return GestureDetector(
      onDoubleTap: () async {
        _onLikePressed(cub: cub, postId: postId);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          model.photo == null || model.photo == ''
              ? const SizedBox()
              : Image.network(model.photo!),
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

  Widget cardBottom(CubitClass cub, int index, AppState state) {
    String postId = cub.postIds[index];
    return Row(
      children: [
        _onLikePressed(cub: cub, postId: postId),
        Text(
          cub.likes.isEmpty ? '' : cub.likes[index].toString(),
          style: const TextStyle(color: Colors.black),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.comment,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share, color: Colors.grey),
        ),
      ],
    );
  }

  _onLikePressed({
    required CubitClass cub,
    required String postId,
  }) {
    return FutureBuilder<bool>(
      future: cub.hasLiked(postId),
      builder: (context, snapshot) {
        bool hasLiked = snapshot.data ?? false;
        return IconButton(
          onPressed: () async {
            await cub.postLikes(postId);
          },
          icon: Icon(
            IconlyBroken.heart,
            color: hasLiked ? defaultPurpleColor : Colors.grey,
          ),
        );
      },
    );
  }
}
