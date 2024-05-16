import 'package:flutter/material.dart';
import '../screens/loginscreen.dart';
import '../screens/register.dart';
class ToggleBetweenLoginAndRegisterClass extends StatefulWidget {
  const ToggleBetweenLoginAndRegisterClass({super.key});

  @override
  State<ToggleBetweenLoginAndRegisterClass> createState() => _ToggleBetweenLoginAndRegisterClassState();
}

class _ToggleBetweenLoginAndRegisterClassState extends State<ToggleBetweenLoginAndRegisterClass> {
  bool showLoginScreen = true;

  togglePages(){
    setState(() {
      showLoginScreen = !showLoginScreen ;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return Login(onRegisterPressed: () => togglePages(),);
    } else {
      return Register(onLoginPressed: () => togglePages());
    }
  }
}

