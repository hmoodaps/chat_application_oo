import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'cubit/appstates.dart';
import 'cubit/cubit.dart';
import 'backend_screens/auth_service.dart';
import 'screens/home.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top
  ]);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitClass()..getData()..getPosts()..getAllUsers(),
      child: BlocConsumer<CubitClass, AppState>(
          listener: (context, state) {},
          builder: (context, state) {
            CubitClass cub = CubitClass.get(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: cub.toggleLightAndDark(context),
              home:const AuthPage(),
              // const AuthPage(),
              //RegisterByGooglePage(),
              // const AuthPage(),
            );
          }),
    );
  }
}
