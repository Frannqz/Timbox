import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LoadFilesScreen extends StatefulWidget {
  const LoadFilesScreen({super.key});

  @override
  _LoadFilesScreenState createState() => _LoadFilesScreenState();
}

class _LoadFilesScreenState extends State<LoadFilesScreen> {
  String _fileName = '';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'pdf']);
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
      // Luego, puedes llamar al método de backend para cargar el archivo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carga de Archivos')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Seleccionar archivo'),
            ),
            if (_fileName.isNotEmpty) Text('Archivo seleccionado: $_fileName'),
            // Aquí llamas a la función para subir el archivo
          ],
        ),
      ),
    );
  }
}
