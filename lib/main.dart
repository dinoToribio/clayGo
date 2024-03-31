import 'package:claygo_app/firebase_options.dart';
import 'package:claygo_app/screens/initial_screen.dart';
import 'package:claygo_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
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