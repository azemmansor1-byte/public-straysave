import 'package:flutter/material.dart';

//text form field default style - need to add .copywith(hint...)
final textInputDecoration = InputDecoration(
  fillColor: Color(0xFFF1F3F5),
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.blue, width: 1.5),
  ),
);

void showToast(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      behavior: SnackBarBehavior.floating, // makes it float like a toast
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: Colors.black87,
    ),
  );
}
