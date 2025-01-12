class UserModel {
  final String nombre;
  final String email;
  final String rfc;
  final String password;

  UserModel(
      {required this.nombre,
      required this.email,
      required this.rfc,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nombre: json['nombre'],
      email: json['email'],
      rfc: json['rfc'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rfc': rfc,
      'password': password,
    };
  }
}
