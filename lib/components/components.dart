import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

ThemeData? myTheme({
  required Color shadowColor,
  required Color appBarBackgroundColor,
  required Color statusBarColor,
  required Brightness statusBarBrightness,
  required Brightness statusBarIconBrightness,
  required Color scaffoldBackgroundColor,
  required Color appBarIconColor,
  required double titleFontSize,
  required Color textColor,
  required Color selectedItemColor,
  required Color unselectedItemColor,
  required Color ifIconPressingColor,
  required Color iconInIconButtonColor,
}) {
  return ThemeData(
    listTileTheme: ListTileThemeData(
      textColor: textColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return ifIconPressingColor;
          }
          return iconInIconButtonColor;
        }),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: unselectedItemColor,
      backgroundColor: scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0.9,
      selectedItemColor: selectedItemColor,
      showSelectedLabels: false,
    ),
    shadowColor: shadowColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarColor: statusBarColor,
      ),
      shadowColor: shadowColor,
      backgroundColor: appBarBackgroundColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: appBarIconColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: titleFontSize,
      ),
    ),
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: textColor),
      bodyLarge: TextStyle(color: textColor),
      bodySmall: TextStyle(color: textColor),
    ),
  );
}

ThemeData? dark = myTheme(
  selectedItemColor: Colors.greenAccent,
  unselectedItemColor: Colors.grey,
  shadowColor: Colors.white,
  appBarBackgroundColor: Colors.black,
  statusBarColor: Colors.black,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  scaffoldBackgroundColor: Colors.black,
  textColor: Colors.white,
  appBarIconColor: Colors.white,
  titleFontSize: 30,
  iconInIconButtonColor: Colors.deepOrange,
  ifIconPressingColor: Colors.white,
);
ThemeData? light = myTheme(
  selectedItemColor: Colors.deepOrange,
  unselectedItemColor: Colors.black,
  shadowColor: Colors.black,
  appBarBackgroundColor: Colors.white,
  statusBarColor: Colors.white,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.white,
  textColor: Colors.black,
  appBarIconColor: Colors.black,
  titleFontSize: 30,
  iconInIconButtonColor: Colors.deepOrange,
  ifIconPressingColor: Colors.grey,
);

defaultTextFormField({
  required context,
  required TextEditingController controller,
  String labelText = 'labelText',
  double labelFontSize = 16,
  Color labelColor = Colors.black,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Color prefixIconColor = Colors.grey,
  Color suffixIconColor = Colors.grey,
  Color defaultBorderColor = Colors.black,
  Color focusedBorderColor = Colors.orange,
  Color borderColorOnNotFocus = Colors.black,
  int? maxLength = 9999999999,
  BorderRadius borderRadius = BorderRadius.zero,
  BorderRadius borderRadiusOnFocus = BorderRadius.zero,
  BorderRadius borderRadiusOnNotFocus = BorderRadius.zero,
  String? Function(String?)? validatorFunction,
  bool obscureText = false,
  bool readOnly = false,
  bool enabled = true,
  Color textColorIfFieldNotEnable = Colors.black,
  Color textColorIfFieldEnable = Colors.white,
  TextInputType textInputType = TextInputType.text,
  textInputAction = TextInputAction.next ,
  int maxLines = 1 ,
}) {
  return TextFormField(
    maxLines: maxLines,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    enabled: enabled,
    style: TextStyle(
        color: enabled ? textColorIfFieldEnable : textColorIfFieldNotEnable),
    readOnly: readOnly,
    controller: controller,
    obscureText: obscureText,
    validator: validatorFunction,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: labelFontSize,
        color: labelColor,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: enabled ? borderColorOnNotFocus : borderColorOnNotFocus,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusOnFocus,
        borderSide: BorderSide(
          color: enabled ? focusedBorderColor : focusedBorderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusOnNotFocus,
        borderSide: BorderSide(
          color: enabled ? borderColorOnNotFocus : borderColorOnNotFocus,
        ),
      ),
    ),
    maxLength: maxLength,
    buildCounter: (BuildContext context,
            {int? currentLength, int? maxLength, bool? isFocused}) =>
        null,
  );
}

navigatorTo(context, nextPage) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ));
}

navigatorReplace(context, nextPage) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ));
}

List<Color> myColorList = [
  const Color(0xFFFFF0F5), // Lavender Blush
  const Color(0xFFFFDAB9), // Peach Puff
  const Color(0xFF7FFFD4), // Aqua Marine
  const Color(0xFF6495ED), // Cornflower Blue
  const Color(0xFFFFEFD5), // Papaya Whip
  const Color(0xFFFFF5EE), // Sea Shell
  const Color(0xFFE6E6FA), // Lavender
  const Color(0xFFF08080), // Light Coral
  const Color(0xFF7B68EE), // Medium Slate Blue
  const Color(0xFFEEE8AA), // Pale Goldenrod
];

//toast message require : fluttertoast and min sdk 21
showToastMSG(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0);
}

//defaultColor
Color defaultBlueColor = const Color(0xFF40E0D0);
Color defaultPurpleColor = const Color(0xFF8A2BE2);

//fade out the child
class FadeIn extends StatefulWidget {
  final Widget child;
  final double delay;

  const FadeIn({super.key, required this.child, required this.delay});

  @override
  FadeInState createState() => FadeInState();
}

class FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 700),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

//Type writer Text : writing text lick a writing machine
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const TypewriterText({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 20.0),
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  TypewriterTextState createState() => TypewriterTextState();
}

class TypewriterTextState extends State<TypewriterText> {
  String _animatedText = '';

  @override
  void initState() {
    super.initState();
    _animateText();
  }

  void _animateText() async {
    for (int i = 0; i < widget.text.length; i++) {
      await Future.delayed(widget.duration);
      setState(() {
        _animatedText = widget.text.substring(0, i + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _animatedText,
      style: widget.style,
    );
  }
}

//beautiful  snack bar require : awesome_snackbar_content
ScaffoldMessengerState showMessageWrong(
    {required ContentType contentType, required BuildContext   context, required String msg}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    duration: const Duration(seconds: 7),
    content: AwesomeSnackbarContent(
      title: 'OH SORRY !!',
      message: msg,
      contentType: contentType,
    ),
  );
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Widget imageButton(
        {required String imagePath, required Function()? onPressed ,required context , required Color textColor}) =>
GestureDetector(
  onTap: onPressed ,
  child: Card(
    child: Container(
      width: MediaQuery.of(context).size.width-150,
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(50),
      ),
      child:Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Image.asset(
              imagePath,
            ),
          ),
          Text('Sign in with google' , style: TextStyle(color:textColor ),),
        ],
      ) ,
    ),
  ),
);




//flutter pub add cupertino_icons firebase_analytics firebase_core firebase_auth cloud_firestore google_sign_in awesome_snackbar_content flutter_facebook_auth twitter_login http font_awesome_flutter firebase_messaging_platform_interface onboarding flutter_bloc shared_preferences smooth_page_indicator dio conditional_builder_null_safety flutter_icon_snackbar shimmer_effect carousel_slider fluttertoast iconly lottie awesome_dialog

//these components created here
Widget myDrawer({required String profileImage , required String name,required Color nameColor ,required Color drawerColor ,required Color drawerHeaderColor , required BuildContext context}) => Drawer(
      backgroundColor: drawerColor,
      child: Column(
        children: [
          myDrawerHeader(name : name,nameColor:nameColor ,drawerHeaderColor : drawerHeaderColor , profileImage : profileImage),
          // ListTile(onTap: (){navigatorTo(context, Friends());},title: Text('friends'), ),
          // SizedBox(height: 10,),
          // ListTile(onTap: (){navigatorTo(context, FriendReq());},title: Text('FriendReq'), ),
        ],
      ),
    );

Widget myDrawerHeader({required String name , required Color drawerHeaderColor ,required Color nameColor , required String profileImage  }) => DrawerHeader(
      decoration: BoxDecoration(color: drawerHeaderColor),
      child: Column(
        children: [
           Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(profileImage??''),
              radius: 50,
            ),
          ),
          const Spacer(),
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: nameColor,
              fontFamily: 'rocky',
            ),
          ),
        ],
      ),
    );

Widget shimmer({required Widget child }) => ShimmerEffect(
      baseColor: defaultBlueColor,
      highlightColor: defaultPurpleColor,
      child: Ink(
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                defaultPurpleColor,
                defaultPurpleColor,
              ],
            ),
          ),
          child: child),
    );
