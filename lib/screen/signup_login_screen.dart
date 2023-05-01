import 'package:flutter/material.dart';
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
          Positioned(
            bottom: 0,
            child: Image(
              alignment: Alignment.bottomLeft,
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
                const SizedBox(
                  height: 40,
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
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
      // bottomNavigationBar: const SizedBox(
      //   width: double.infinity,
      //   child: Image(
      //     image: AssetImage('assets/image_signup_login.png'),
      //   ),
      // ),
    );
  }
}
