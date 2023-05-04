import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phox_mizz_up/helpers.dart';

class SignupLoginScreen extends StatefulWidget {
  const SignupLoginScreen({super.key});

  @override
  State<SignupLoginScreen> createState() => _SignupLoginScreenState();
}

class _SignupLoginScreenState extends State<SignupLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          ScreenUtil().screenWidth > 500
              ? Container()
              : Positioned(
                  bottom: 0,
                  child: Image(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    image: const AssetImage('assets/image_signup_login.png'),
                  ),
                ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/logo.png'),
                ),
                SizedBox(
                  height: 40.h,
                ),
                const Flexible(
                  child: Text(
                    "THE SUSTAINABLE WATER FILTER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: ScreenUtil().screenWidth > 500
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 1.5,
                  child: elevatedButtonComponent(
                    context: context,
                    texte: "SIGNUP",
                    backgroundColor: Colors.white,
                    textColor: Colors.black54,
                    function: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: ScreenUtil().screenWidth > 500
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 1.5,
                  child: elevatedButtonComponent(
                    context: context,
                    texte: "LOGIN",
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                    function: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
      // bottomNavigationBar:SizedBox(
      //   width: double.infinity,
      //   child: Image(
      //     image: AssetImage('assets/image_signup_login.png'),
      //   ),
      // ),
    );
  }
}
