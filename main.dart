import 'package:flutter/material.dart';
import 'package:m02/provider.dart';
import 'package:provider/provider.dart';

import 'm02_01.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<M02Provider>(
          create: (_) => M02Provider(),
        ),
      ],
      child: const MaterialApp(
        title: 'Flutter Pertemuan 2 Latihan',
        home: MyBio(),
      ),
    );
  }
}