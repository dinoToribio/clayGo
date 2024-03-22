import 'package:claygo_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  ScreenNames.login: (context) => const LoginScreen(),
  ScreenNames.home: (context) => const HomeScreen(),
  ScreenNames.waterLevel: (context) => const WaterLevelScreen(),
  ScreenNames.dirtLevel: (context) => const DirtLevelScreen(),
};
