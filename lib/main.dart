import 'package:flutter/material.dart';
import 'package:movieapp/Screens/Home_screen.dart';
import 'package:movieapp/Screens/bottom_nav.dart';
import 'package:movieapp/Screens/splach_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplachScreen(),
    );
  }
}


