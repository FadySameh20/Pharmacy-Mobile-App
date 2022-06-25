import 'package:flutter/material.dart';

var defaultColor = Colors.blueAccent;

var defaultForeground = Paint()
  ..shader = const LinearGradient(
    colors: [Colors.blue, Colors.red, Colors.pink],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0));
