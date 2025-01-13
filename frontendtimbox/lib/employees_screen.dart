import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testtimbox/models/employee_model.dart';
import 'package:testtimbox/services/employees_service.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final EmployeeService _controller = EmployeeService();
  List<EmployeeModel> _collaborators = [];
  List<EmployeeModel> _filteredCollaborators = [];
  final TextEditingController _searchController = TextEditingController();
  int? _userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userId == null) {
      _getUserId();
    }
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
    if (_userId != null) {
      _fetchCollaborators();
    }
  }

  Future<void> _fetchCollaborators() async {
    try {
      final collaborators = await _controller.fetchCollaborators(_userId!);
      setState(() {
        _collaborators = collaborators;
        _filteredCollaborators = collaborators;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterCollaborators(String query) {
    setState(() {
      _filteredCollaborators = _collaborators.where((collaborator) {
        return collaborator.nombre
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            collaborator.curp.toLowerCase().contains(query.toLowerCase()) ||
            collaborator.rfc.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _deleteCollaborator(int id) async {
    try {
      await _controller.deleteCollaborator(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Colaborador eliminado')),
      );
      _fetchCollaborators();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Empleados',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por Nombre, CURP o RFC',
                labelStyle: const TextStyle(color: Colors.blue),
                hintText: 'Introduce el nombre, CURP o RFC del colaborador...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              onChanged: _filterCollaborators,
            ),
            const SizedBox(height: 20),
            // Lista de colaboradores
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCollaborators.length,
                itemBuilder: (context, index) {
                  final collaborator = _filteredCollaborators[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        collaborator.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'CURP: ${collaborator.curp} | RFC: ${collaborator.rfc}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCollaborator(collaborator.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
