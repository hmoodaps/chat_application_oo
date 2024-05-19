import 'package:chat_application/components/components.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  _showExitConfirmation(context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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
                  child:  const Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
    );
  }

  final TextEditingController userNameCo = TextEditingController();
  final TextEditingController bioCo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    userNameCo.text = cub.model.userName ?? '';
    bioCo.text = cub.model.bio ?? '';
    return BlocConsumer<CubitClass, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(onPressed: () {
                  cub.updateProfile(name: userNameCo.text,
                      profilePhotoUrl: cub.profilePhotoUrl,
                      backgroundPhotoUrl: cub.backgroundPhotoUrl,
                      bio: bioCo.text);
                  Navigator.pop(context);
                },
                    child: Text(
                      'Update', style: TextStyle(color: defaultBlueColor),))
              ],
              leading: IconButton(
                onPressed: () {
                  _showExitConfirmation(context);
                },
                icon:  Icon(IconlyBroken.arrow_left_2, color: defaultBlueColor,),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  state is UpdatingProfileData ? const LinearProgressIndicator() : const SizedBox(),
                  const PopScope(
                    canPop: false,
                    child: SizedBox(),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 3.7,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: cub.backGroundPhoto != null
                                        ? FileImage(
                                      cub.backGroundPhoto!,
                                    ) as ImageProvider
                                        : NetworkImage(
                                      cub.model.backgroundPhoto!,
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                cub.getBackGroundPhoto();
                              },
                              child: const CircleAvatar(
                                child: Icon(IconlyBroken.camera),
                              ),
                            ),
                          ],
                        ),

                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Stack(
                                children: [
                                  Stack(
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
                                        backgroundImage: cub
                                            .model.backgroundPhoto ==
                                            null
                                            ? const AssetImage(
                                            'assets/images/person.png')
                                        as ImageProvider
                                            : cub.profilePhoto == null
                                            ? NetworkImage(
                                            cub.model.profilePhoto!)
                                            : FileImage(
                                          cub.profilePhoto!,
                                        ) as ImageProvider,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      cub.getProfilePhoto();
                                    },
                                    child: const CircleAvatar(
                                      child: Icon(IconlyBroken.camera),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: defaultTextFormField(
                      context: context,
                      controller: userNameCo,
                      borderColorOnNotFocus:
                      cub.isDark ? defaultBlueColor : Colors.orange,
                      labelText: 'UserName',
                      labelColor: cub.isDark ? Colors.blue : Colors.black,
                      maxLength: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: defaultTextFormField(
                        context: context,
                        controller: bioCo,
                        borderColorOnNotFocus:
                        cub.isDark ? defaultBlueColor : Colors.orange,
                        labelText: 'Bio',
                        labelColor: cub.isDark ? Colors.blue : Colors.black,
                        maxLength: 130,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        textInputType: TextInputType.multiline),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
