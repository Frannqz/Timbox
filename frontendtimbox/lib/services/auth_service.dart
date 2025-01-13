import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testtimbox/models/user_model.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:3000/api';
  String? token;
  int? userId;

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

  Future<String?> loginUser(
      {required String email, required String password}) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      token = data['token'];
      userId = data['userId'];

      final prefs = await SharedPreferences.getInstance(); //Save token
      await prefs.setString('token', token!);
      await prefs.setInt('userId', userId!);

      return null;
    } else {
      print('Error: ${response.statusCode}');
      final error = json.decode(response.body)['error'];
      return error;
    }
  }
}
