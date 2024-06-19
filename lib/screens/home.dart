import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';  // استيراد مكتبة shimmer

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

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);

    return Builder(
      builder: (context) {
        return BlocConsumer<CubitClass, AppState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                elevation: 40,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                items: [
                  BottomNavigationBarItem(
                    icon: _bottomBarIcon(
                      cub: cub,
                      child: const Icon(IconlyBroken.home),
                      index: 0,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _bottomBarIcon(
                      cub: cub,
                      child: const Icon(IconlyBroken.chat),
                      index: 1,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _bottomBarIcon(
                      cub: cub,
                      child: const Icon(IconlyBroken.profile),
                      index: 2,
                    ),
                    label: '',
                  ),
                ],
                onTap: (index) {

                  cub.changBottomNavBarIndex(index);
                },
                currentIndex: cub.currentIndex,
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                shadowColor: Colors.transparent,
                actions: [
                  IconButton(
                    onPressed: () {
                      cub.signOut(context);
                    },
                    icon: Icon(
                      Icons.logout,
                      color: defaultBlueColor,
                    ),
                  ),
                ],
                title: Shimmer.fromColors(baseColor: cub.isDark
                      ? defaultPurpleColor
                      : const Color(0xFF40E0D0),
                  highlightColor: cub.isDark
                      ? const Color(0xFF40E0D0)
                      : defaultPurpleColor,
                  child: const Text(
                    'S t o r y t e l l i n g',
                    style: TextStyle(
                      fontFamily: 'rocky',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                centerTitle: false,
              ),
              body: SafeArea(child: cub.screens[cub.currentIndex]),
            );
          },
        );
      },
    );
  }

  Widget _bottomBarIcon(
      {required Widget child, required CubitClass cub, required int index}) {
    if (cub.currentIndex == index) {
      return Shimmer.fromColors(
        direction: ShimmerDirection.btt,
        baseColor: cub.isDark ? const Color(0xFF40E0D0) : defaultPurpleColor,
        highlightColor: cub.isDark ? defaultPurpleColor : const Color(0xFF40E0D0),
        child: child,
      );
    } else {
      return child;
    }
  }
}
