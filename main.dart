import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m07/login_page.dart';
// import 'package:flutter_application_1/pertemuan6_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pertemuan 4 Latihan',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const LoginScreen(),
    );
  }
}
