import 'package:flutter/material.dart';
import 'package:m04/my_home.dart';
import 'package:m04/pertemuan4_provider.dart';
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
        ChangeNotifierProvider<ProviderPertemuan4>(
          create: (_) => ProviderPertemuan4()
            ..loadApiGenre()
            ..loadApiNowPlaying(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Pertemuan 4 Latihan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePertemuan4(),
      ),
    );
  }
}
