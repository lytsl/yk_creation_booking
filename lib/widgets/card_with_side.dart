import 'package:flutter/material.dart';

class CardWithSide extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function()? onTap;
  final double height;

  CardWithSide(
      {this.color = Colors.orange,
      required this.child,
      this.onTap,
      this.height = 100.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height + 5,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 2,
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: color, width: 16)),
                color: Colors.blueGrey.shade50,
              ),
              child: SizedBox(
                height: this.height,
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: color,
                      width: 40,
                      height: this.height,
                      child: Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Icon(Icons.calendar_today)),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
