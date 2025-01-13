import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testtimbox/models/employee_model.dart';

class EmployeeService {
  final String baseUrl = 'http://localhost:3000/api';

  Future<List<EmployeeModel>> fetchCollaborators(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/collaborators?user_id=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => EmployeeModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar colaboradores');
    }
  }

  Future<void> deleteCollaborator(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/collaborators/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar colaborador');
    }
  }
}
