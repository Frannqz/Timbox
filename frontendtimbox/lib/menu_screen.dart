import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú de la Aplicación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Inicio'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            ListTile(
              title: const Text('Carga de Archivos'),
              onTap: () {
                Navigator.of(context).pushNamed('/loadFiles');
              },
            ),
            ListTile(
              title: const Text('Colaboradores'),
              onTap: () {
                Navigator.of(context).pushNamed('/collaborators');
              },
            ),
            ListTile(
              title: const Text('Empleados'),
              onTap: () {
                Navigator.of(context).pushNamed('/employees');
              },
            ),
            ListTile(
              title: const Text('Servicios'),
              onTap: () {
                Navigator.of(context).pushNamed('/services');
              },
            ),
            ListTile(
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token'); //Remove token
                await prefs.remove('userId'); //Remove userId
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Contenido Principal')),
    );
  }
}
