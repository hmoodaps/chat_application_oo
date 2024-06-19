import 'package:flutter/material.dart';
class Wrong extends StatelessWidget {
  const Wrong({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset('assets/images/wrong.png' ,),
            const Text('Myby somthing went wrong'),
          ],
        ),
      );
    }
  }

