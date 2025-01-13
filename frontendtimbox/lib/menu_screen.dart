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
        title: const Text('Bienvenido', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/user_icon.png',
                    height: 52,
                    width: 52,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Timbox',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.file_upload,
                color: Colors.blue,
              ),
              title: const Text('Carga de Archivos'),
              onTap: () {
                Navigator.of(context).pushNamed('/loadFiles');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Colors.blue,
              ),
              title: const Text('Colaboradores'),
              onTap: () {
                Navigator.of(context).pushNamed('/collaborators');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: const Text('Empleados'),
              onTap: () {
                Navigator.of(context).pushNamed('/employees');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.design_services,
                color: Colors.blue,
              ),
              title: const Text('Servicios'),
              onTap: () {
                Navigator.of(context).pushNamed('/services');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
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
      body: Center(
          child: Image.asset(
        'assets/images/timbox_logo.png',
        width: 350,
        fit: BoxFit.cover,
      )),
    );
  }
}
