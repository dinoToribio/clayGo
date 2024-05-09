import 'package:flutter/material.dart';

double getPercentageOf2Numbers({
  required double startValue,
  required double endValue,
}) {
  return ((startValue - endValue) / startValue);
}

Color getOfflineOrWarningColor({
  required bool isOnline,
  required color,
  required bool showWarningColor,
}) {
  return isOnline
      ? showWarningColor
          ? Colors.red
          : color
      : Colors.grey;
}
