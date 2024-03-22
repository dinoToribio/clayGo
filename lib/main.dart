import 'package:claygo_app/initial_screen.dart';
import 'package:claygo_app/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClayGoApp());
}
class ClayGoApp extends StatelessWidget {
  const ClayGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const InitialScreen(),
      routes: routes,
    );
  }
}