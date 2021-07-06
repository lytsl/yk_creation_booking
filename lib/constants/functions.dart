import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Fun {
  static void toast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        );
  }

  snackBar(String? message,BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static double textHeight(double fontSize, BuildContext context) =>
      (TextPainter(
          text: TextSpan(text: 'text', style: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold)),
          maxLines: 1,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.ltr)
        ..layout())
          .size.height;

}
