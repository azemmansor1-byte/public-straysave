import 'package:flutter/material.dart';

Widget makeTestableWidget(Widget child){
  return MaterialApp(
    home: Scaffold(body: child),
  );
}