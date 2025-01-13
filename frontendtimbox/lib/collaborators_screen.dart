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

  final Map<String, int> _estadoClave = {
    'Aguascalientes': 1,
    'Baja California': 2,
    'Baja California Sur': 3,
    'Campeche': 4,
    'Chiapas': 5,
    'Chihuahua': 6,
    'Coahuila': 7,
    'Colima': 8,
    'Ciudad de México': 9,
    'Durango': 10,
    'Guanajuato': 11,
    'Guerrero': 12,
    'Hidalgo': 13,
    'Jalisco': 14,
    'Mexico': 15,
    'Michoacán': 16,
    'Morelos': 17,
    'Nayarit': 18,
    'Nuevo León': 19,
    'Oaxaca': 20,
    'Puebla': 21,
    'Querétaro': 22,
    'Quintana Roo': 23,
    'San Luis Potosí': 24,
    'Sinaloa': 25,
    'Sonora': 26,
    'Tabasco': 27,
    'Tamaulipas': 28,
    'Tlaxcala': 29,
    'Veracruz': 30,
    'Yucatán': 31,
    'Zacatecas': 32,
  };

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
        claveEntidad: _estadoClave[_estado] ?? 0,
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
        _fechaInicioController.clear();
        _tipoContratoController.clear();
        _departamentoController.clear();
        _puestoController.clear();
        _salarioDiarioController.clear();
        _salarioController.clear();
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
      appBar: AppBar(
        title: const Text('Agregar Colaborador'),
        backgroundColor: Colors.blue,
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _correoController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidEmail(value)) return 'Correo no válido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rfcController,
                decoration: InputDecoration(
                  labelText: 'RFC',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment_ind, color: Colors.blue),
                ),
                maxLength: 13,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidRFC(value))
                    return 'RFC no válido (debe tener 13 caracteres y formato correcto)';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _domicilioFiscalController,
                decoration: InputDecoration(
                  labelText: 'Domicilio Fiscal',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home, color: Colors.blue),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _curpController,
                decoration: InputDecoration(
                  labelText: 'CURP',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_pin, color: Colors.blue),
                ),
                maxLength: 18,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nssController,
                decoration: InputDecoration(
                  labelText: 'NSS',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.nature_people, color: Colors.blue),
                ),
                maxLength: 11,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidNSS(value)) return 'NSS no válido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio Laboral',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _tipoContratoController,
                decoration: InputDecoration(
                  labelText: 'Tipo de Contrato',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _departamentoController,
                decoration: InputDecoration(
                  labelText: 'Departamento',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _puestoController,
                decoration: InputDecoration(
                  labelText: 'Puesto',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _salarioDiarioController,
                decoration: InputDecoration(
                  labelText: 'Salario Diario',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidSalario(value!)) return 'Formato incorrecto';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _salarioController,
                decoration: InputDecoration(
                  labelText: 'Salario',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (!isValidSalario(value!)) return 'Formato incorrecto';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _estado,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Aguascalientes',
                  'Baja California',
                  'Baja California Sur',
                  'Campeche',
                  'Chiapas',
                  'Chihuahua',
                  'Coahuila',
                  'Colima',
                  'Durango',
                  'Estado de México',
                  'Guanajuato',
                  'Guerrero',
                  'Hidalgo',
                  'Jalisco',
                  'Michoacán',
                  'Morelos',
                  'Nayarit',
                  'Nuevo León',
                  'Oaxaca',
                  'Puebla',
                  'Querétaro',
                  'Quintana Roo',
                  'San Luis Potosí',
                  'Sinaloa',
                  'Sonora',
                  'Tabasco',
                  'Tamaulipas',
                  'Tlaxcala',
                  'Veracruz',
                  'Yucatán',
                  'Zacatecas',
                  'Ciudad de México'
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _estado = value as String?;
                    // Asignar la clave de entidad correspondiente
                    _claveEntidadController.text =
                        _estadoClave[_estado]?.toString() ?? '';
                  });
                },
                validator: (value) => value == null ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Agregar Colaborador',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
