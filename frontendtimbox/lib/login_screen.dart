import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';
import 'package:testtimbox/password_recovery_screen.dart'; // Importa tu pantalla de recuperación de contraseña

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Inicio de Sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _LoginForm(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordRecoveryScreen(),
                        ),
                      );
                    },
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final AuthController _authController = AuthController();

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authController.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _authController.token!);
        await prefs.setInt('userId', _authController.user_id!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );
        _emailController.clear();
        _passwordController.clear();
        Navigator.of(context).pushReplacementNamed('/menu');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: Credenciales incorrectas no coinciden en el sistema')),
        );
        _emailController.clear();
        _passwordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Por favor ingresa tu correo';
              if (!isValidEmail(value)) return 'Ingresa un correo válido';
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loginUser,
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }
}
