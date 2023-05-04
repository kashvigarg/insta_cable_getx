import 'package:flutter/material.dart';

Shader linearGradient = const LinearGradient(colors: [
  Color.fromARGB(255, 129, 221, 132),
  Colors.yellow,
  Colors.green,
]).createShader(const Rect.fromLTWH(200, 100, 120, 100));
