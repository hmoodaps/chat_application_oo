import 'package:chat_application/components/components.dart';
import 'package:chat_application/cubit/appstates.dart';
import 'package:chat_application/cubit/cubit.dart';
import 'package:chat_application/screens/add_post.dart';
import 'package:chat_application/screens/edit_Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class Profile extends StatelessWidget {
   Profile({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
        builder: (context, state) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await cub.getData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.zero,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          cub.model.backgroundPhoto == null ? Image.asset('assets/images/person.png'):
                          Image.network(
                            cub.model.backgroundPhoto!,
                            height: MediaQuery.of(context).size.height / 3.7,
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
                                  backgroundImage:
                                  cub.model.backgroundPhoto == null ?
                                  const AssetImage('assets/images/person.png')as ImageProvider:
                                  NetworkImage(cub.model.profilePhoto!),
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
                    Text(cub.model.name ?? '', style: const TextStyle(fontSize: 25 , fontWeight: FontWeight.bold) , ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      cub.model.bio ?? "",
                      maxLines: 3,
                      style: TextStyle(color: defaultBlueColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //we can use outlinedButton
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.blue),
                            ),
                            onPressed: () {
                              navigatorTo(context, AddPost());
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Add Post',
                                    style: TextStyle(color: Colors.blue)),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(IconlyBroken.upload, color: Colors.blue)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          onPressed: () {
                            navigatorTo(context,  EditProfile());
                          },
                          child:  const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Edit', style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                IconlyBroken.edit_square,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
