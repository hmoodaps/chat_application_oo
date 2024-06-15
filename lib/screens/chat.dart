import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/model/message_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import '../model/model.dart';

class Chat extends StatelessWidget {
  final Model? model;
  final ScrollController scrollController = ScrollController();

  Chat({super.key, required this.model});

  final messageCo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);

    // تغيير لون شريط الحالة عند بناء الواجهة
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return Builder(builder: (context) {
      cub.getMessages(model!.uid!);
      return BlocConsumer<CubitClass, AppState>(
        listener: (context, state) {
          if (state is GetMessages) {
            // التمرير إلى الأسفل عند جلب الرسائل
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.jumpTo(scrollController.position.maxScrollExtent);
              }
            });
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(model!.profilePhoto ?? ''),
                  radius: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  model!.name ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            leading: IconButton(
              onPressed: () {
                cub.isDark
                    ? (
                FlutterStatusbarcolor.setStatusBarColor(
                    Colors.black),
                FlutterStatusbarcolor.setStatusBarWhiteForeground(
                    false)
                )
                    : (
                FlutterStatusbarcolor.setStatusBarColor(
                    Colors.white),
                FlutterStatusbarcolor.setStatusBarWhiteForeground(
                    false)
                );
                Navigator.pop(context);
              },
              icon: const Icon(IconlyBroken.arrow_left_2),
            ),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
              ConditionalBuilder(
                builder: (context) => Expanded(
                  child: ListView.separated(
                    controller: scrollController, // تعيين ScrollController
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    reverse: false, // لجعل الرسائل الأحدث في الأسفل
                    itemBuilder: (context, index) => _chat(
                      context: context,
                      cub: cub,
                      messageModel: cub.messageModelList[index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 5,
                    ),
                    itemCount: cub.messageModelList.length,
                  ),
                ),
                condition: cub.messageModelList.isNotEmpty,
                fallback: (context) =>  Center(
                  child: Column(children: [
                    Image.asset('assets/images/nothing.png'),
                    const Text('there is nothing here yet')
                  ],),
                ),
              ),
              _spacer(cub),
              _sendMessageBox(context, cub),
            ],
          ),
        ),
      );
    });
  }

  _spacer(CubitClass cub){
    return cub.messageModelList.isEmpty ? const Spacer() :const  SizedBox() ;
  }
  _chat({
    required MessageModel messageModel,
    required BuildContext context,
    required CubitClass cub,
  }) {
    if (messageModel.senderUid == FirebaseAuth.instance.currentUser!.uid) {
      return _myMessage(context, cub, messageModel.message ?? '');
    } else {
      return _hisMessage(context, cub, messageModel.message ?? '');
    }
  }

  _myMessage(BuildContext context, CubitClass cub, String message) {
    return Padding(
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
                child: Text(message),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _hisMessage(BuildContext context, CubitClass cub, String message) {
    return Padding(
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
                child: Text(message),
              ),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundImage: NetworkImage(model!.profilePhoto!),
            radius: 15,
          ),
        ],
      ),
    );
  }

  _sendMessageBox(BuildContext context, CubitClass cub) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF556B2F),
            child: IconButton(
              icon: const Icon(
                IconlyBroken.camera,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              controller: messageCo,
              minLines: 1, // الحد الأدنى لعدد الأسطر
              maxLines: 5, // الحد الأقصى لعدد الأسطر
              decoration: const InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: const Color(0xFF556B2F),
            child: IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: const Color(0xFF77B300),
            child: IconButton(
              icon: const Icon(IconlyBroken.send),
              onPressed: () async {
                if (messageCo.text != '') {
                  await cub.sendMessage(
                    receiverUid: model!.uid!,
                    date: DateTime.now().toString(),
                    message: messageCo.text,
                  );
                  messageCo.clear();
                  // التمرير إلى الأسفل عند إرسال رسالة جديدة
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
