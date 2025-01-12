import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<String?> registerUser({
    required String nombre,
    required String email,
    required String rfc,
    required String password,
  }) async {
    final user = UserModel(
      nombre: nombre,
      email: email,
      rfc: rfc,
      password: password,
    );
    return await _authService.registerUser(user);
  }

  Future<bool> login(String email, String password) async {
    final response = await _authService.login(email, password);
    if (response != null) {
      //-
      return true;
    }
    return false;
  }
}
