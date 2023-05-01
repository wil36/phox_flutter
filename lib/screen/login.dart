import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phox_mizz_up/helpers.dart';
import 'package:phox_mizz_up/services/auth_service.dart';
import 'package:phox_mizz_up/services/database_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  var box = Hive.box('Phox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logo.png'),
          width: 120,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'LOG IN',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black87),
                          decoration: inputDecorationComponent(
                              hintText: 'Enter email ...'),
                          onChanged: (value) {
                            setState(() {
                              email = value.toString();
                            });
                          },
                          //check validator
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          autofocus: false,
                          obscureText: true,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black87),
                          decoration: inputDecorationComponent(
                              hintText: 'Enter password ...'),
                          onChanged: (value) {
                            setState(() {
                              password = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Password must be at last 6 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : elevatedButtonComponent(
                                  context: context,
                                  texte: "LOGIN",
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  textColor: Colors.white,
                                  function: () {
                                    login(context);
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                    },
                    child: Text(
                      "FORGOT PASSWORD ?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ))
                ],
              ),
            ),
          ),
          // Container(),
        ],
      ),
    );
  }

  login(context) async {
    if (formKey.currentState!.validate() && _isLoading == false) {
      setState(() {
        _isLoading = true;
      });
      await AuthService()
          .loginUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving data to local storage
          box.putAll({
            'STATUTLOGIN': true,
            'USERNAME': snapshot.docs[0]['fullname'],
            'USEREMAIL': email,
          });
          Navigator.pushReplacementNamed(context, '/myFilters');
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
