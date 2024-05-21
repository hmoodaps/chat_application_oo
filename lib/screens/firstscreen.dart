import 'package:chat_application/model/post_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/appstates.dart';
import '../cubit/cubit.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: ConditionalBuilder(
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
          condition: cub.posts.isNotEmpty,
          builder: (context) => RefreshIndicator(
            onRefresh: ()async => await cub.getPosts(),
            child: ListView.separated(
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
                          child: postHeader(cub, cub.posts[index]),
                        ),
                        Card(
                          child: cardBody(cub, cub.posts[index]),
                        ),
                        Card(
                          child: cardBottom(cub),
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
  }

  Widget postHeader(CubitClass cub, PostModel model) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundImage: model.profilePhoto == null
              ? const AssetImage('assets/images/profile.jpg') as ImageProvider
              : NetworkImage(model.profilePhoto!),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          model.userName ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget cardBody(CubitClass cub, PostModel model) {
    return GestureDetector(
      onDoubleTap: () => cub.changeFaveIconPressed(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          model.photo == null ||model.photo == '' ? const SizedBox() : Image.network(model.photo!),
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

  Widget cardBottom(CubitClass cub) {
    return Row(
      children: [
        IconButton(
          onPressed: () => cub.changeFaveIconPressed(),
          icon: cub.changeFavIcon(),
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
}
