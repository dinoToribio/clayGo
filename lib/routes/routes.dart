import 'package:claygo_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  RouteNames.login: (context) => const LoginScreen(),
  RouteNames.tables: (context) => const TablesScreen(),
  RouteNames.waterLevel: (context) => const WaterLevelScreen(),
  RouteNames.dirtLevel: (context) => const DirtLevelScreen(),
  RouteNames.table: (context) => const TableScreen(),
};
