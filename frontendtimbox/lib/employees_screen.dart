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
        title: const Text('Empleados'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por Nombre, CURP o RFC',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCollaborators,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCollaborators.length,
              itemBuilder: (context, index) {
                final collaborator = _filteredCollaborators[index];
                return ListTile(
                  title: Text(collaborator.nombre),
                  subtitle: Text(
                      'CURP: ${collaborator.curp} | RFC: ${collaborator.rfc}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCollaborator(collaborator.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
