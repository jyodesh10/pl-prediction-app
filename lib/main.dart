import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'local/sharedPref.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA4fqUKPIKzyGAeQoZ1btiMz_HaU20X0R8",
      appId: "1:196895963767:android:e69904550b0a99c7f86472",
      messagingSenderId: "196895963767",
      projectId: "pl-prediction-d61a7",
    ),
  );
  await SharedPrefs().setPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
