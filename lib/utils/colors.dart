import 'dart:math';
import 'package:flutter/material.dart';

Color rainbow() {
  final colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.pink,
    Colors.lightBlue,
    Colors.blueGrey
  ];
  final random = Random();
  final index = random.nextInt(colors.length);
  return colors[index];
}
