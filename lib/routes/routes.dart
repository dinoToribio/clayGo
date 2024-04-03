import 'package:claygo_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  RouteNames.login: (context) => const LoginScreen(),
  RouteNames.tables: (context) => const TablesScreen(),
  RouteNames.waterLevelLogs: (context) => const WaterLevelLogsScreen(),
  RouteNames.dirtLevelLogs: (context) => const DirtLevelLogsScreen(),
  RouteNames.usageCountLogs: (context) => const UsageCountLogsScreen(),
  RouteNames.table: (context) => const TableScreen(),
};
