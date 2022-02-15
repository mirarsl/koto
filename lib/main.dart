import 'package:flutter/material.dart';
import 'package:koto/pages/home.dart';
import 'package:koto/pages/loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Loader(),
        '/home': (context) => const Home(),
      },
    );
  }
}
