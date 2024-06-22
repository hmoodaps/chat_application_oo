import 'package:chat_application/backend_screens/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../components/components.dart';
import '../components/explosion_effect.dart';
import '../cubit/appstates.dart';
import '../cubit/cubit.dart';
class FirstAtAll extends StatelessWidget {
  const FirstAtAll({super.key});
  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass();

    return BlocConsumer<CubitClass , AppState>(builder: (context , state){
      return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(child: Shimmer.fromColors(
          baseColor: cub.isDark
              ? defaultPurpleColor
              : const Color(0xFF40E0D0),
          highlightColor: cub.isDark
              ? const Color(0xFF40E0D0)
              : defaultPurpleColor,
          child: ExplodeText(text: 'S t o r y t e l l i n g', style:const TextStyle(
            fontFamily: 'rocky',
            fontSize: 28,
            color: Colors.white,
           ), duration: const Duration(seconds: 5), onComplete: () { navigatorReplace(context, const AuthPage()); },
          ),
        ),),
      );
    }, listener: (context , state){});
  }
}
