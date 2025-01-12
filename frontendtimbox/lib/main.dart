import 'package:flutter/material.dart';
import 'package:testtimbox/home_screen.dart';
import 'package:testtimbox/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exámen Desarrollador Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const HomeScreen(),
      },
    );
  }
}
