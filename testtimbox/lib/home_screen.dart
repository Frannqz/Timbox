import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/usuarios'));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuarios')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Usuario: ${users[index]['nombre']}'),
            subtitle: Text('Correo: ${users[index]['email']}'),
          );
        },
      ),
    );
  }
}
