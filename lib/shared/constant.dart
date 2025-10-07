import 'package:flutter/material.dart';

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
