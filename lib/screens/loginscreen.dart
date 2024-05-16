import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import '../components/components.dart';
import '../cubit/appstates.dart';
import '../cubit/cubit.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.onRegisterPressed});

  final void Function()? onRegisterPressed;

  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7.2,
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(fontFamily: 'rocky', fontSize: 50),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    defaultTextFormField(
                      textColorIfFieldEnable:
                          cub.isDark ? Colors.white : Colors.black,
                      labelText: 'Email Address',
                      labelColor: cub.isDark ? Colors.white : Colors.black,
                      prefixIcon: const Icon(IconlyBroken.message,
                          color: Color(0xFF7FFFD4)),
                      defaultBorderColor: const Color(0xFF7FFFD4),
                      focusedBorderColor: Colors.purple,
                      borderColorOnNotFocus: const Color(0xFF7FFFD4),
                      maxLength: 50,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        topLeft: Radius.circular(50.0),
                      ),
                      borderRadiusOnFocus: const BorderRadius.only(
                        bottomRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                      ),
                      borderRadiusOnNotFocus: const BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        topLeft: Radius.circular(50.0),
                      ),
                      controller: emailController,
                      validatorFunction: (String? value) {
                        if (value!.isEmpty) {
                          return 'This filed is required';
                        }
                        return null;
                      },
                      context: context,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextFormField(
                      textColorIfFieldEnable:
                          cub.isDark ? Colors.white : Colors.black,
                      labelText: 'Password',
                      labelColor: cub.isDark ? Colors.white : Colors.black,
                      prefixIcon: const Icon(
                        IconlyBroken.lock,
                        color: Color(0xFF7FFFD4),
                      ),
                      defaultBorderColor: const Color(0xFF7FFFD4),
                      focusedBorderColor: Colors.purple,
                      borderColorOnNotFocus: const Color(0xFF7FFFD4),
                      maxLength: 50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                      borderRadiusOnFocus: const BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        topLeft: Radius.circular(50.0),
                      ),
                      borderRadiusOnNotFocus: const BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                      controller: passController,
                      validatorFunction: (value) {
                        if (value!.isEmpty) {
                          return 'This filed is required';
                        }
                        return null;
                      },
                      context: context,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: Container(
                      height: 70,
                      width: 270,
                      decoration: BoxDecoration(
                        color: cub.isDark ? Colors.white : Colors.black,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(200),
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(200),
                        ),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          formKey.currentState!.validate()
                              ?
                                  cub.signInWithEmailAndPass(
                                      context: context,
                                      email: emailController.text,
                                      pass: passController.text)
                              : null;
                        },
                        child: ShimmerEffect(
                          baseColor: const Color(0xFF40E0D0),
                          highlightColor: Colors.purple,
                          child: Ink(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(200),
                                topRight: Radius.circular(200),
                                bottomRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.purple,
                                  Color(0xFF40E0D0),
                                ],
                              ),
                            ),
                            child: const SizedBox(
                              height: 50,
                              width: 250,
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(
                      height: 50,
                    ),
                    const Center(child: Text('don\'t have an account ?')),
                    Center(
                      child: MaterialButton(
                          onPressed: () => onRegisterPressed!(),
                          child: const Text(
                            'Register now ^_^ !',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Divider()),
                        Expanded(child: Center(child: Text('or'))),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     imageButton(
                    //       textColor: cub.isDark ? Colors.black : Colors.white,
                    //         onPressed: () => cub.signInWithGoogle(context  ),
                    //         imagePath: 'assets/images/google.png' , context: context),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }
}
