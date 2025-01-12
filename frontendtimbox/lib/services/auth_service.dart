import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testtimbox/models/user_model.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:3000/api';

  Future<String?> registerUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/registro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return null;
      } else {
        final error = jsonDecode(response.body)['error'];
        return error;
      }
    } catch (e) {
      return 'Error de conexión';
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
