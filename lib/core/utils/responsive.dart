import 'package:flutter/material.dart';

class ResponsiveSize {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;
  late final double scale;

  ResponsiveSize(this.context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scale = (screenWidth / 800).clamp(0.8, 2.0);
  }

  double fontSize(double base) => base * scale;
  double padding(double base) => base * scale;
  double iconSize(double base) => base * scale;
  double radius(double base) => base * scale;
}

class SizeConfig {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _scale = 1.0;

  static const double designWidth = 1200;
  static const double designHeight = 700;

  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    final wScale = _screenWidth / designWidth;
    final hScale = _screenHeight / designHeight;
    _scale = (wScale < hScale ? wScale : hScale).clamp(0.35, 2.0);
  }

  static double sp(double size) => size * _scale;
  static double wp(double size) => size * _scale;
  static double hp(double size) => size * _scale;

  static bool get isTablet => _screenWidth >= 600;
  static bool get isLandscape => _screenWidth > _screenHeight;
}
