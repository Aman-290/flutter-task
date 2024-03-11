import 'package:flutter/material.dart';
import 'package:studize_interview/screens/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: const Color.fromARGB(255, 255, 255, 255),
          displayColor: const Color.fromARGB(255, 254, 254, 254),
        ),
      ),
      home: HomePage(),
    );
  }
}
