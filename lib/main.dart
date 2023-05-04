import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBnzn-DHcTrPnI_AeGF97z2qaZwzbS_AIA',
        appId: 'com.water.phox',
        messagingSenderId: '80991382913',
        projectId: 'phox-39c06'),
  );
  // await Firebase.initializeApp(options: DefaultFirebaseOptions .currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('Phox');
    return ScreenUtilInit(
      builder: (_, child) => MaterialApp(
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
      ),
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
}
// wtiam36@gmail.com
