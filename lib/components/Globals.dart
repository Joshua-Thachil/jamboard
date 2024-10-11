import 'package:flutter/material.dart';

class Globals{
  static late double screenWidth;
  static late double screenHeight;

  void initialize(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}