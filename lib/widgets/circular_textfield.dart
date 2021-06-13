import 'package:flutter/material.dart';

class CircularTextField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final IconData? icon;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;

  CircularTextField(
      {required this.hint,
      this.icon,
      required this.onChanged,
      this.textInputAction,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: TextStyle(fontSize: 14),
        textInputAction: this.textInputAction,
        onChanged: this.onChanged,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          prefixIcon: Icon(icon),
          hintText: hint,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          filled: true,
          fillColor: Colors.white70,
          hintStyle: new TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
