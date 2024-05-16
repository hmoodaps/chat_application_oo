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
        body: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            height: 25,
          ),
          itemCount: 10,
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
                      child: postHeader(cub),
                    ),
                    Card(
                      child: cardBody(cub),
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
    );
  }

  Widget postHeader(CubitClass cub) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundImage:
          cub.model == null || cub.model?.backgroundPhoto == null ?
          const AssetImage('assets/images/person.png')as ImageProvider:
          NetworkImage(cub.model!.profilePhoto!),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          cub.model!.userName ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget cardBody(CubitClass cub) {
    return GestureDetector(
      onDoubleTap: () => cub.changeFaveIconPressed(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/profile.jpg'),
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
                  'desc',
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
