import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../components/components.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key});

  final TextEditingController textCo = TextEditingController();

  _showExitConfirmation(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure ?'),
        content: const Text(
          'any changes you made will be ignored',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.green),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
  }

  _showLoadingDialog(context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () {
                      if (cub.postPhoto == null) {
                        cub.createPost(text: textCo.text);
                        Navigator.pop(context);
                        cub.getPosts();
                      } else if (cub.postPhoto != null &&
                          cub.postPhotoUrl == null) {
                        null;
                      } else if (cub.postPhoto != null &&
                          cub.postPhotoUrl != null) {
                        cub
                            .createPost(
                                text: textCo.text, photo: cub.postPhotoUrl)
                            .then((value) {
                          Navigator.pop(context);
                          cub.deletePhotoFromThePost();
                          cub.getPosts();
                        });
                      }
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(color: defaultBlueColor),
                    ))
              ],
              leading: IconButton(
                onPressed: () {
                  _showExitConfirmation(context);
                },
                icon: Icon(
                  IconlyBroken.arrow_left_2,
                  color: defaultBlueColor,
                ),
              ),
              title: const Text('Create Post'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (state is UploadPostPhoto) const LinearProgressIndicator(),
                  const PopScope(
                    canPop: false,
                    child: SizedBox(),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(cub.model.profilePhoto!),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        cub.model.name!,
                        style: TextStyle(color: defaultPurpleColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write your Text here .. ',
                          hintStyle: TextStyle(color: Colors.grey[700])),
                      controller: textCo,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  cub.postPhoto != null
                      ? Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.7,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      cub.postPhoto!,
                                    ) as ImageProvider),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                cub.deletePhotoFromThePost();
                              },
                              child: const CircleAvatar(
                                child: Icon(IconlyBroken.close_square),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            cub.getPostPhoto().then((value) {
                              cub.uploadPostPhoto(cub.postPhoto);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconlyBroken.image,
                                size: 30,
                                color: cub.isDark
                                    ? defaultBlueColor
                                    : Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                    fontSize: 18, color: defaultBlueColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          '# Tags',
                          style: TextStyle(color: Colors.purple),
                        ),
                      )))
                    ],
                  )
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
