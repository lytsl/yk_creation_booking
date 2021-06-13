import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yk_creation_booking/pages/onboarding_page.dart';
import 'package:yk_creation_booking/pages/service_page.dart';

int? location, gender;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  location = await prefs.getInt("location");
  gender = await prefs.getInt("gender");
  print('Location $location');
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: OnBoardingPage(),
      initialRoute: location == null ? "first" : "/",
      routes: {
        '/': (context) => ServicePage(gender: gender!, location: location!),
        "first": (context) => OnBoardingPage(),
      },
    );
  }
}
