import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:koto/pages/home.dart';
import 'package:koto/pages/loader.dart';
import 'package:koto/pages/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Koto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Loader(),
        '/start': (context) => const Start(),
        '/home': (context) => const Home(),
      },
    );
  }
}
