import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/collaborator_model.dart';

class CollaboratorService {
  final String apiUrl = 'http://localhost:3000/api/addCollaborator';

  Future<String> addCollaborator(CollaboratorModel collaborator) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(collaborator.toJson()),
      );

      if (response.statusCode == 201) {
        return 'Colaborador agregado exitosamente';
      } else {
        final error =
            json.decode(response.body)['error'] ?? 'Error desconocido';
        return 'Error: $error';
      }
    } catch (e) {
      return 'Error al agregar colaborador: $e';
    }
  }
}
