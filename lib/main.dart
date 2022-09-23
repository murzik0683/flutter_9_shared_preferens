import 'package:flutter/material.dart';
import 'package:flutter_lesson_13/screens/login_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: 'Хранение данных',
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
