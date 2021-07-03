import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}

class PushNotificationManager{

  PushNotificationManager._privateConstructor();

  static final PushNotificationManager _instance = PushNotificationManager._privateConstructor();

  factory PushNotificationManager(){
    return _instance;
  }

  final _messaging = FirebaseMessaging.instance;

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      // For testing purposes print the Firebase Messaging token
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // Parse the message received
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );

        });
      } else {
        print('User declined or has not accepted permission');
      }
      String token = await _messaging.getToken() ?? 'empty';
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

}