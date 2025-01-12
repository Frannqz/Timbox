import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _rfcController = TextEditingController();

    Future<void> _recoverPassword() async {
      final email = _emailController.text;
      final rfc = _rfcController.text;

      if (email.isEmpty || rfc.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos')),
        );
        return;
      }

      // Simulación de recuperación de contraseña
      print('Recuperar contraseña para Email: $email y RFC: $rfc');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de recuperación enviada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _rfcController,
              decoration: const InputDecoration(
                labelText: 'RFC',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recoverPassword,
              child: const Text('Recuperar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
