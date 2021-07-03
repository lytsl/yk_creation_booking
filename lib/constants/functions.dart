import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Fun {
  static void toast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
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
