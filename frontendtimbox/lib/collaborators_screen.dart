import 'package:flutter/material.dart';

class CollaboratorsScreen extends StatefulWidget {
  const CollaboratorsScreen({super.key});

  @override
  _CollaboratorsScreenState createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();

  Future<void> _addColaborador() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Colaborador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  return null;
                },
              ),
              TextFormField(
                controller: _rfcController,
                decoration: const InputDecoration(labelText: 'RFC'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  return null;
                },
              ),
              TextFormField(
                controller: _curpController,
                decoration: const InputDecoration(labelText: 'CURP'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _addColaborador,
                child: const Text('Agregar Colaborador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
