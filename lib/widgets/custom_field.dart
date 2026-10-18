import 'package:flutter/material.dart';

Widget customField({
  required String hintText,
  TextEditingController? controller,
  required TextInputType type,
  bool obscureText = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      keyboardType: type,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
    ),
  );
}
