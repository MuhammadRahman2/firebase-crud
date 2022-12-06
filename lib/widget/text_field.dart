import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final TextEditingController textControl;
  final String hintText;
  VoidCallback onsubmit ;
  bool obscureTexts = false;
  Icon? icon;
  TextFields(
      {required this.textControl,
      required this.hintText,
      required this.obscureTexts,
      required this.onsubmit,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textControl,
      obscureText: obscureTexts,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: icon),
      // onFieldSubmitted: onsubmit,
    );
  }
}
