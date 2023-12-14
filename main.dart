import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void backgroundCompute(args){
    print('background compute callback');
    print('calculating fibonanci from background process');

    int first = 0;
    int second = 1;
    for (var i = 2; i <= 50; i++) {
      var tmp = second;
      second = first + second;
      first = tmp;
      sleep(const Duration(milliseconds: 200));
      print('first : $first, second : $second.'); 
    }
    print('finished calculating fibo');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo 12',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                compute(backgroundCompute, null);
              },
              child: const Text('calculate fibo on compute isolate')),
        ),
      ),
    );
  }
}