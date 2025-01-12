import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _authController = AuthController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final error = await _authController.registerUser(
        nombre: _nombreController.text,
        email: _emailController.text,
        rfc: _rfcController.text,
        password: _passwordController.text,
      );

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );

        _nombreController.clear();
        _emailController.clear();
        _rfcController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidEmail(value))
                    return 'Correo electrónico no válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _rfcController,
                decoration: const InputDecoration(labelText: 'RFC'),
                maxLength: 13,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidRFC(value))
                    return 'RFC no válido (debe tener 13 caracteres)';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirmar Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
