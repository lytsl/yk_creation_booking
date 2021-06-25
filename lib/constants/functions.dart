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
}
