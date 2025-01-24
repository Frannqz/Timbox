import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  String? token;
  int? user_id;

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
    final response =
        await _authService.loginUser(email: email, password: password);

    if (response == null) {
      token = _authService.token;
      user_id = _authService.userId;
      return true;
    }
    return false;
  }
}
