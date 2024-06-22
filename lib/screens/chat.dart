import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/model/message_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:image_picker/image_picker.dart';

import '../components/components.dart';
import '../model/model.dart';
import '../model/post_model.dart';
import 'his_profile.dart';

class Chat extends StatelessWidget {
  final UserModel? model;
  final ScrollController scrollController = ScrollController();
  final messageCo = TextEditingController();

  Chat({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    bool canDel = cub.messageModelList.isNotEmpty;
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue);
    return Builder(builder: (context) {
      cub.getMessages(model!.uid!);
      return BlocConsumer<CubitClass, AppState>(
        listener: (context, state) {
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                onSelected: (value) async {
                  if (value == 'Delete Chat from me' && canDel) {
                    cub.deleteMessagesFromMySide(hisId: model!.uid!);
                  } else if (value == 'Delete Chat from both' && canDel) {
                    cub.deleteMessagesFromBothSides(hisId: model!.uid!);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Delete Chat from me',
                    child: Text(
                      'Delete Chat from me',
                      style: TextStyle(color: canDel ? Colors.black : Colors.grey),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Delete Chat from both',
                    child: Text('Delete Chat from both'),
                  ),
                ],
              ),
            ],
            title: InkWell(
              onTap: () async {
                List<PostModel> hisPosts = [];
                for (var e in cub.posts) {
                  if (e.uid == model!.uid && !hisPosts.contains(e)) {
                    hisPosts.add(e);
                  }
                }
                if (model!.uid == cub.model.uid) {
                  cub.changBottomNavBarIndex(2);
                } else {
                  navigatorTo(context, HisProfile(model: model!, posts: hisPosts));
                }
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(model!.profilePhoto ?? ''),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    model!.name ?? '',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () {
                cub.isDark
                    ? (
                FlutterStatusbarcolor.setStatusBarColor(Colors.black),
                FlutterStatusbarcolor.setStatusBarWhiteForeground(false)
                )
                    : (
                FlutterStatusbarcolor.setStatusBarColor(Colors.white),
                FlutterStatusbarcolor.setStatusBarWhiteForeground(false)
                );
                Navigator.pop(context);
              },
              icon: const Icon(IconlyBroken.arrow_left_2),
            ),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
              Expanded(
                child: ConditionalBuilder(
                  builder: (context) =>ListView.separated(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    reverse: true, // عكس عرض العناصر
                    itemBuilder: (context, index) => _chat(
                      state,
                      context: context,
                      cub: cub,
                      messageModel: cub.messageModelList.reversed.toList()[index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 5),
                    itemCount: cub.messageModelList.length,
                  ),


                  condition: cub.messageModelList.isNotEmpty,
                  fallback: (context) => Center(
                    child: Column(
                      children: [
                        Image.asset('assets/images/nothing.png'),
                        const Text('There is nothing here yet'),
                      ],
                    ),
                  ),
                ),
              ),
              _sendMessageBox(context, cub),
            ],
          ),
        ),
      );
    });
  }

  Widget _chat(
  AppState state,
      {
    required MessageModel messageModel,
    required BuildContext context,
    required CubitClass cub,
  }) {
    if (messageModel.senderUid == FirebaseAuth.instance.currentUser!.uid) {
      return _myMessage(context, cub, messageModel ,  state);
    } else {
      return _hisMessage(context, cub, messageModel);
    }
  }

  Widget _myMessage(BuildContext context, CubitClass cub, MessageModel msgModel , AppState state) {
    return GestureDetector(
      onLongPress: () {
        cub.showDeleteMsgButton(msgModel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(cub.model.profilePhoto!),
              radius: 15,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87CEEB),
                    border: Border.all(
                        color: cub.isDark ? Colors.white : Colors.black),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: msgModel.photo ==''
                      ? Text(msgModel.message!)
                      :Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        msgModel.photo!,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Failed to load image');
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(msgModel.message!),
                    ],
                  )

                  ,
                ),
              ),
            ),
            msgModel.showDelIcon == true
                ? Row(
              children: [
                IconButton(
                  onPressed: () {
                    cub.deleteOneMessageFromMySide(
                        hisId: model!.uid!, messageID: msgModel.messageID!);
                  },
                  icon: const Icon(IconlyBroken.delete),
                ),
                IconButton(
                  onPressed: () {
                    cub.hideDeleteMsgButton();
                  },
                  icon: const Icon(IconlyBroken.close_square),
                ),
              ],
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _hisMessage(BuildContext context, CubitClass cub, MessageModel msgModel) {
    return GestureDetector(
      onLongPress: () {
        cub.showDeleteMsgButton(msgModel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(
                        color: cub.isDark ? Colors.white : Colors.black),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: msgModel.photo == null || msgModel.photo!.isEmpty || msgModel.photo ==''||msgModel.photo ==' '
                      ? Text(msgModel.message!)
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        msgModel.photo!,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Failed to load image');
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(msgModel.message!),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              backgroundImage: NetworkImage(model!.profilePhoto ?? ''),
              radius: 15,
            ),
            msgModel.showDelIcon == true
                ? Row(
              children: [
                IconButton(
                  onPressed: () {
                    cub.deleteOneMessageFromMySide(
                        hisId: model!.uid!, messageID: msgModel.messageID!);

                  },
                  icon: const Icon(IconlyBroken.delete),
                ),
                IconButton(
                  onPressed: () {
                    cub.hideDeleteMsgButton();
                  },
                  icon: const Icon(IconlyBroken.close_square),
                ),
              ],
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _sendMessageBox(BuildContext context, CubitClass cub) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF556B2F),
            child: IconButton(
              icon: const Icon(IconlyBroken.camera),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return SizedBox(
                    height: 120,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(children: [
                      InkWell(
                        onTap: () {
                          cub.getChatPhoto(ImageSource.camera).then((value) {
                            showDialog(builder: (context) =>
                            const Center(
                              child: CircularProgressIndicator(),),
                                context: context);
                            cub.uploadChatPhoto(cub.chatPhoto).then((value) {
                              Navigator.pop(context);
                              navigatorTo(
                                  context,
                                  PhotoShower(
                                    model: model,
                                  ));
                            });
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 50,
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                Icon(IconlyBroken.camera),
                                 SizedBox(width: 8,),
                                Text('pick photo from camera'),
                              ],),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: () {
                          cub.getChatPhoto(ImageSource.gallery).then((value) {
                            showDialog(builder: (context) =>
                            const Center(
                              child: CircularProgressIndicator(),),
                                context: context);
                            cub.uploadChatPhoto(cub.chatPhoto).then((value) {
                              Navigator.pop(context);
                              navigatorTo(
                                  context,
                                  PhotoShower(
                                    model: model,
                                  ));
                            });
                          });
                        },

                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 50,
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                           Icon(IconlyBroken.image),
                           SizedBox(width: 8,),
                           Text('pick photo from gallery'),
                                                      ],),
                        ),
                      ),
                    ],),
                  );
                }, backgroundColor: Colors.white,);
              },
            ),
          ),
          const SizedBox(width: 5),

              Expanded(
            child: TextFormField(
              controller: messageCo,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          CircleAvatar(
            backgroundColor: const Color(0xFF77B300),
            child: IconButton(
              icon: const Icon(IconlyBroken.send),
              onPressed: () async {
                if (messageCo.text.isNotEmpty) {
                  await cub.sendMessage(
                    receiverUid: model!.uid!,
                    date: DateTime.now().toString(),
                    message: messageCo.text,
                  );
                  messageCo.clear();

                  // Scroll to bottom immediately after sending message
                  scrollController.jumpTo(scrollController.position.minScrollExtent);
                }
              },
            ),
          ),


        ],
      ),
    );
  }
}

class PhotoShower extends StatelessWidget {
  final msgCo = TextEditingController();

  final UserModel? model;

  PhotoShower({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: cub.chatPhotoUrl != null
                  ? Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                              cub.chatPhoto!,
                            ) as ImageProvider),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () async {
                                cub.deleteChatPhoto(cub.chatPhoto);
                                Navigator.pop(context);
                              },
                              child: const CircleAvatar(
                                child: Icon(IconlyBroken.close_square),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: msgCo,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Type Your Message',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20)),
                                        borderSide: BorderSide(
                                          color: Colors.orangeAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                               const SizedBox(width: 5,),
                                CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  child: GestureDetector(
                                    onTap: () {
                                      cub
                                          .sendMessage(
                                              receiverUid: model!.uid!,
                                              date: DateTime.now().toString(),
                                              message: msgCo.text,
                                              photo: cub.chatPhotoUrl)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Icon(IconlyBroken.send),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
