import 'package:flutter/material.dart';
import 'package:testtimbox/collaborators_screen.dart';
import 'package:testtimbox/employees_screen.dart';
import 'package:testtimbox/load_files_screen.dart';
import 'package:testtimbox/login_screen.dart';
import 'package:testtimbox/menu_screen.dart';
import 'package:testtimbox/password_recovery_screen.dart';
import 'package:testtimbox/register_screen.dart';
import 'package:testtimbox/services_screen.dart';

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
      home: const LoginScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/passwordRecovery': (context) => const PasswordRecoveryScreen(),
        '/menu': (context) => const MenuScreen(),
        '/loadFiles': (context) => const LoadFilesScreen(),
        '/collaborators': (context) => const CollaboratorsScreen(),
        '/employees': (context) => const EmployeesScreen(),
        '/services': (context) => const ServicesScreen(),
      },
    );
  }
}
