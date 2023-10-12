import 'package:flutter/material.dart';
import 'package:m03/MyProvider.dart';
import 'package:m03/screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProductProvider>(
          create: (_) => ListProductProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Pertemuan 3 Latihan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ScreenPertemuan3(),
      ),
    );
  }
}