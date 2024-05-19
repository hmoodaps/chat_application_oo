import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import '../components/components.dart';
import '../cubit/appstates.dart';
import '../cubit/cubit.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Register extends StatelessWidget {
  Register({super.key, required this.onLoginPressed});
  final void Function()? onLoginPressed;
  final TextEditingController emailCo = TextEditingController();
  final TextEditingController userNameCo = TextEditingController();
  final TextEditingController passCo = TextEditingController();
  final TextEditingController repassCo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
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
                        const SizedBox(height: 30,),
                        const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(fontFamily: 'rocky', fontSize: 50),
                          ),
                        ),
                        defaultTextFormField(
                          textColorIfFieldEnable:
                              cub.isDark ? Colors.white : Colors.black,
                          labelText: 'UserName',
                          labelColor: cub.isDark ? Colors.white : Colors.black,
                          prefixIcon: const Icon(
                            IconlyBroken.profile,
                            color: Color(0xFF7FFFD4),
                          ),
                          defaultBorderColor: const Color(0xFF7FFFD4),
                          focusedBorderColor: defaultPurpleColor,
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
                          controller: userNameCo,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return 'This filed is required';
                            }
                            return null;
                          },
                          context: context,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                          textColorIfFieldEnable:
                              cub.isDark ? Colors.white : Colors.black,
                          labelText: 'Email Address',
                          labelColor: cub.isDark ? Colors.white : Colors.black,
                          prefixIcon: const Icon(
                            Icons.mail,
                            color: Color(0xFF7FFFD4),
                          ),
                          defaultBorderColor: const Color(0xFF7FFFD4),
                          focusedBorderColor: defaultPurpleColor,
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
                          controller: emailCo,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return 'This filed is required';
                            }
                            return null;
                          },
                          context: context,
                        ),
                        const SizedBox(
                          height: 15,
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
                          focusedBorderColor: defaultPurpleColor,
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
                          controller: passCo,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return 'This filed is required';
                            }
                            return null;
                          },
                          context: context,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                          textColorIfFieldEnable:
                              cub.isDark ? Colors.white : Colors.black,
                          labelText: 'rePassword',
                          labelColor: cub.isDark ? Colors.white : Colors.black,
                          prefixIcon: const Icon(
                            IconlyBroken.lock,
                            color: Color(0xFF7FFFD4),
                          ),
                          defaultBorderColor: const Color(0xFF7FFFD4),
                          focusedBorderColor: defaultPurpleColor,
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
                          controller: repassCo,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return 'This filed is required';
                            }
                            return null;
                          },
                          context: context,
                        ),
                        const SizedBox(
                          height: 15,
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
                                  ?(
                                  passCo.text==repassCo.text
                                  ?(cub.addUser(context: context,
                                      email: emailCo.text, pass: passCo.text, name: userNameCo.text ,),)
                                  :showMessageWrong(
                                      contentType: ContentType.warning,
                                      context: context, msg: 'Seems like pass not match'),
                              )
                                  :null ;
                            },
                            child: ShimmerEffect(
                              baseColor: const Color(0xFF40E0D0),
                              highlightColor: defaultPurpleColor,
                              child: Ink(
                                decoration:  BoxDecoration(
                                  borderRadius:const BorderRadius.only(
                                    bottomLeft: Radius.circular(200),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(200),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      defaultPurpleColor,
                                      Color(0xFF40E0D0),
                                    ],
                                  ),
                                ),
                                child: const SizedBox(
                                  height: 50,
                                  width: 250,
                                  child: Center(
                                    child: Text(
                                      'Register',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                   const SizedBox(height: 10,),
                        const Center(child: Text('don\'t have an account ?')),
                        Center(
                          child: MaterialButton(
                              onPressed: () => onLoginPressed!(),
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
                            Expanded(child: Text('  or Sign In with')),
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
                        //         textColor: cub.isDark ? Colors.black : Colors.white,
                        //         onPressed: () => cub.signInWithGoogle(context),
                        //         imagePath: 'assets/images/google.png',
                        //       context: context
                        //     ),
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
