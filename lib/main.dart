import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yk_creation_booking/pages/onboarding_page.dart';
import 'package:yk_creation_booking/pages/otp_page.dart';
import 'package:yk_creation_booking/pages/service_page.dart';

bool? hasVisitedBefore;
bool? hasSignedIn;
String? number;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  hasVisitedBefore = await prefs.getBool('visit');
  var suid = await prefs.getString('uid');
  number = await prefs.getString('number');
  hasSignedIn = suid != null;
  suid = (suid == null) ? 'null' : suid;
  print('suid = ' + suid);
  await Firebase.initializeApp();
  final user = FirebaseAuth.instance.currentUser;
  final uid = user == null ? 'null' : user.uid;
  print('fa = ' + uid);
  runApp(MyApp());
}
//#503929

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late var initRout;
    if (hasVisitedBefore == null) {
      initRout = OnBoardingPage();
    } else {
      if (hasSignedIn == null || number == null) {
        initRout = OTPPage();
      } else
        initRout = ServicePage(number: number!);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: initRout,
      //home: OnBoardingPage(),
      /*initialRoute: hasVisitedBefore == null ? "first" : "/",
      routes: {
        '/': (context) => ServicePage(),
        "first": (context) => OnBoardingPage(),
      },*/
    );
  }
}
