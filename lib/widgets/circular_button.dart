import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Function() onButtonTap;
  final String text;
  final Color backColor;
  final Color textColor;

  CircularButton(
      {required this.text,
      required this.onButtonTap,
      this.backColor = Colors.deepPurple,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onButtonTap,
      child: Container(
        width: double.infinity,
        //margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: backColor,
          //border: Border.all(color: Colors.blueGrey.shade700, width: 2),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
