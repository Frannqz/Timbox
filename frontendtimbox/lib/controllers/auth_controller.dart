import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  String? token;

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

  Future<bool> loginUser(String email, String password) async {
    final error =
        await _authService.loginUser(email: email, password: password);

    if (error == null) {
      token = _authService.token;
      return true;
    }
    return false;
  }
}
