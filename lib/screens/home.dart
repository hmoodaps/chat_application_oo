import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../components/components.dart';
import '../cubit/appstates.dart';
import '../cubit/cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  //   final cub = CubitClass.get(context);
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     for (var provider in FirebaseAuth.instance.currentUser!.providerData) {
  //       if (provider.providerId != 'google.com') {
  //         cub.getData();
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitClass, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        CubitClass cub = CubitClass.get(context);
        cub.getPosts();
        return Scaffold(
          key: _scaffoldKey,
          drawer: myDrawer(profileImage: cub.model.profilePhoto ?? '',context: context,
            name: cub.model.userName ?? '',
            drawerColor: cub.isDark ? Colors.grey.shade500 : Colors.grey.shade200,
            drawerHeaderColor: cub.isDark ? Colors.grey.shade800 : Colors.grey.shade500,
            nameColor: cub.isDark ? Colors.white : Colors.black,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 40,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            items: const [
              BottomNavigationBarItem(icon: Icon(IconlyBroken.home), label: ''),
              BottomNavigationBarItem(icon: Icon(IconlyBroken.chat), label: ''),
              BottomNavigationBarItem(icon: Icon(IconlyBroken.home), label: ''),
              BottomNavigationBarItem(icon: Icon(IconlyBroken.call), label: ''),
              BottomNavigationBarItem(icon: Icon(IconlyBroken.profile), label: ''),
            ],
            onTap: (index) {
              if (index != 2) {
                cub.changBottomNavBarIndex(index);
              }else if(index == 0 ){
                cub.getPosts().then((value){
                  cub.changBottomNavBarIndex(index);
                });
              }else if (index == 1){
                cub.getAllUsers();
                cub.changBottomNavBarIndex(index);
              }
            },
            currentIndex: cub.currentIndex,
          ),
          floatingActionButton: MaterialButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: cub.isDark ? defaultPurpleColor : defaultBlueColor,
              child: CircleAvatar(
                radius: 37,
                backgroundColor: cub.isDark ? Colors.black : Colors.white,
                child: shimmer(
                  child: const Icon(
                    IconlyBroken.category,
                    size: 45,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            automaticallyImplyLeading :false , // hide drawer button
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  cub.signOut(context);
                },
                icon:  Icon(Icons.logout , color: defaultBlueColor,),
              ),
            ],
            title: Text(
              'S t o r y t e l l i n g',
              style: TextStyle(fontFamily: 'rocky', fontSize: 12 , color: defaultPurpleColor),
            ),
            centerTitle: false,
          ),
          body: SafeArea(child: cub.screens[cub.currentIndex]),
        );
      },
    );
  }
}
