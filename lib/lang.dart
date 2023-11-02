import 'package:flutter/material.dart';

enum Lang {
  primaryColor(Color(0xFFFFECB3)),
  oasisImg("https://i.imgur.com/rgbSkHE.png");

  final Object value;
  const Lang(this.value);

  String getString() {
    return value as String;
  }

  Color getColor() {
    return value as Color;
  }
}
