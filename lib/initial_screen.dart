import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/screens.dart';

// The page where all logic starts
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushNamed(context, ScreenNames.tables),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.black),
      ),
    );
  }
}
