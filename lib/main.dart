import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phox_mizz_up/screen/add_filters.dart';
import 'package:phox_mizz_up/screen/contact.dart';
import 'package:phox_mizz_up/screen/details_filter.dart';
import 'package:phox_mizz_up/screen/login.dart';
import 'package:phox_mizz_up/screen/my_filters.dart';
import 'package:phox_mizz_up/screen/signup.dart';
import 'package:phox_mizz_up/screen/signup_login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Phox');
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('Phox');
    return MaterialApp(
      title: 'Phox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff06303C),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff06303C),
          onPrimary: Colors.white,
          secondary: Color(0xff03E8E8),
          onSecondary: Colors.black,
          error: Colors.redAccent,
          onError: Colors.redAccent,
          background: Color(0xff06303C),
          onBackground: Colors.white,
          surface: Color(0xff06303C),
          onSurface: Colors.white,
        ),
      ),
      initialRoute: box.get("STATUTLOGIN", defaultValue: false) == true
          ? '/myFilters'
          : '/signupLoginQuestion',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/signupLoginQuestion': (context) => const SignupLoginScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/myFilters': (context) => const MyFiltersScreen(),
        '/addFilters': (context) => const AddFiltersScreen(),
        '/detailFilter': (context) => const DetailsFilterSccreen(),
        '/contact': (context) => const ContactScreen(),
      },
      // home: const SignupLoginScreen(),
    );
  }
}
// wtiam36@gmail.com
