import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testtimbox/models/collaborator_model.dart';
import 'package:testtimbox/services/collaborators_service.dart';
import 'package:testtimbox/utils/validators.dart';
import 'package:intl/intl.dart';

class CollaboratorsScreen extends StatefulWidget {
  const CollaboratorsScreen({super.key});

  @override
  _CollaboratorsScreenState createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = CollaboratorService();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _domicilioFiscalController =
      TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _nssController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _tipoContratoController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _puestoController = TextEditingController();
  final TextEditingController _salarioDiarioController =
      TextEditingController();
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _claveEntidadController = TextEditingController();
  String? _estado;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId'); //Recupera el userId del almacenamiento
    });
  }

  Future<void> _selectFechaInicio() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        _fechaInicioController.text = formattedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final collaborator = CollaboratorModel(
        nombre: _nombreController.text,
        correo: _correoController.text,
        rfc: _rfcController.text,
        domicilioFiscal: _domicilioFiscalController.text,
        curp: _curpController.text,
        nss: _nssController.text,
        fechaInicioLaboral: _fechaInicioController.text,
        tipoContrato: _tipoContratoController.text,
        departamento: _departamentoController.text,
        puesto: _puestoController.text,
        salarioDiario: double.parse(_salarioDiarioController.text),
        salario: double.parse(_salarioController.text),
        claveEntidad: int.parse(_claveEntidadController.text),
        estado: _estado!,
        userId: _userId!,
      );

      final result = await _service.addCollaborator(collaborator);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      if (result.contains('Colaborador Agregado')) {
        _formKey.currentState!.reset();
        _nombreController.clear();
        _correoController.clear();
        _rfcController.clear();
        _domicilioFiscalController.clear();
        _curpController.clear();
        _nssController.clear();
        _rfcController.clear();
        _fechaInicioController.clear();
        _tipoContratoController.clear();
        _departamentoController.clear();
        _nombreController.clear();
        _puestoController.clear();
        _salarioDiarioController.clear();
        _claveEntidadController.clear();
        setState(() {
          _estado = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Colaborador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidEmail(value)) return 'Correo no válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _rfcController,
                decoration: const InputDecoration(labelText: 'RFC'),
                maxLength: 13,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidRFC(value))
                    return 'RFC no válido (debe tener 13 caracteres)';
                  return null;
                },
              ),
              TextFormField(
                  controller: _domicilioFiscalController,
                  decoration:
                      const InputDecoration(labelText: 'Domicilio Fiscal'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null),
              TextFormField(
                controller: _curpController,
                decoration: const InputDecoration(labelText: 'CURP'),
                maxLength: 18,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidCURP(value)) return 'CURP no válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _nssController,
                decoration: const InputDecoration(labelText: 'NSS'),
                maxLength: 11,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidNSS(value)) return 'NSS no válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaInicioController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Inicio Laboral',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectFechaInicio,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                  try {
                    DateTime.parse(value);
                    return null;
                  } catch (_) {
                    return 'Fecha no válida';
                  }
                },
              ),
              TextFormField(
                  controller: _tipoContratoController,
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Contrato'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null),
              TextFormField(
                  controller: _departamentoController,
                  decoration: const InputDecoration(labelText: 'Departamento'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null),
              TextFormField(
                  controller: _puestoController,
                  decoration: const InputDecoration(labelText: 'Puesto'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null),
              TextFormField(
                controller: _salarioDiarioController,
                decoration: const InputDecoration(labelText: 'Salario Diario'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidSalario(value!)) return 'Formato incorrecto';
                  return null;
                },
              ),
              TextFormField(
                controller: _salarioController,
                decoration: const InputDecoration(labelText: 'Salario'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidSalario(value!)) return 'Formato incorrecto';
                  return null;
                },
              ),
              TextFormField(
                  controller: _claveEntidadController,
                  decoration: const InputDecoration(labelText: 'Clave Entidad'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null),
              DropdownButtonFormField(
                value: _estado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: [
                  'Ciudad de México',
                  'Jalisco',
                  'Nuevo León',
                  // Agrega todos los estados aquí...
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _estado = value as String?),
                validator: (value) => value == null ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Agregar Colaborador')),
            ],
          ),
        ),
      ),
    );
  }
}
