import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/data/profile_model.dart';
import 'package:yk_creation_booking/pages/login_page.dart';
import 'package:yk_creation_booking/pages/onboarding_page.dart';
import 'package:yk_creation_booking/pages/service_page.dart';
import 'package:yk_creation_booking/services/page_notifications.dart';

bool? hasVisitedBefore;
bool? hasSignedIn;
String? number, customerID;
late final FirebaseMessaging _messaging;
late PushNotification _notificationInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  hasVisitedBefore = prefs.getBool('visit');
  number = prefs.getString('number');
  customerID = prefs.getString('customerID');
  await Firebase.initializeApp();
  final user = FirebaseAuth.instance.currentUser;
  hasSignedIn = user != null;
  final uid = user == null ? 'null' : user.uid;
  print('fa = ' + uid);

  _messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // On iOS, this helps to take the user permissions
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // For handling the received notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification?.title);
      // Parse the message received
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      _notificationInfo = notification;

      showSimpleNotification(
        Text(_notificationInfo.title!),
        //leading: NotificationBadge(totalNotifications: _totalNotifications),
        subtitle: Text(_notificationInfo.body!),
        background: Colors.cyan.shade700,
        duration: Duration(seconds: 2),
      );
    });

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.notification?.title);
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      _notificationInfo = notification;
    });

    // For handling notification when the app is in terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(initialMessage.notification?.title);
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      _notificationInfo = notification;
    }
  } else {
    print('User declined or has not accepted permission');
  }

  runApp(MyApp());
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late var initRout;
    Profile profile = Profile();
    profile.customerID = customerID;
    if (hasVisitedBefore == null) {
      initRout = OnBoardingPage.ID;
    } else {
      if (hasSignedIn == null || number == null) {
        initRout = LoginPage.ID;
      } else
        initRout = ServicePage.ID;
    }
    //initRout = LoginPage();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
          primaryColor: primaryColor,
          accentColor: primaryColor,
        ),
        //home: OnBoardingPage(),
        initialRoute: initRout,
        routes: {
          OnBoardingPage.ID: (context) => OnBoardingPage(),
          LoginPage.ID: (context) => LoginPage(),
          ServicePage.ID: (context) => ServicePage(
                number: number!,
                profile: profile,
              ),
        },
      ),
    );
  }
}
