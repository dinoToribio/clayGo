import 'package:claygo_app/core/core.dart';
import 'package:claygo_app/firebase_options.dart';
import 'package:claygo_app/screens/initial_screen.dart';
import 'package:claygo_app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    NotificationService.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final response =
        await FirebaseFirestore.instance.collection("tables").get();
    for (var doc in response.docs) {
      print("dino: $doc");
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Workmanager().initialize(
    callbackDispatcher,
  );
  Workmanager().registerPeriodicTask(
    "table-status-reports",
    "check-tables-status",
    frequency: const Duration(seconds: 60),
    initialDelay: const Duration(seconds: 5),
  );
  runApp(const ClayGoApp());
}

class ClayGoApp extends StatelessWidget {
  const ClayGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService.init();
    return MaterialApp(
      title: "ClayGo App",
      color: Colors.blue,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const InitialScreen(),
      routes: routes,
    );
  }
}
