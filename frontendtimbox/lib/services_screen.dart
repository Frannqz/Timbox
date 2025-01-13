import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<dynamic> posts = [];
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  int? _selectedPostId;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1'));
      if (response.statusCode == 200) {
        setState(() {
          posts = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar publicaciones: $e')));
    }
  }

  Future<void> createPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final newPost = json.decode(response.body);
        setState(() {
          posts.insert(0, newPost);
        });
        _titleController.clear();
        _bodyController.clear();
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear publicación: $e')));
    }
  }

  Future<void> editPost(int id, String title, String body) async {
    try {
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'id': id,
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 200) {
        final updatedPost = json.decode(response.body);
        setState(() {
          int index = posts.indexWhere((post) => post['id'] == id);
          if (index != -1) {
            posts[index] = updatedPost;
          }
        });
        _titleController.clear();
        _bodyController.clear();
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al editar publicación: $e')));
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts.removeWhere((post) => post['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Publicación eliminada')));
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar publicación: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title:
            const Text('Publicaciones', style: TextStyle(color: Colors.white)),
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blue[50],
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      posts[index]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text(
                      posts[index]['body'],
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            _selectedPostId = posts[index]['id'];
                            _titleController.text = posts[index]['title'];
                            _bodyController.text = posts[index]['body'];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Editar Publicación'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _titleController,
                                        decoration: const InputDecoration(
                                            labelText: 'Título'),
                                      ),
                                      TextField(
                                        controller: _bodyController,
                                        decoration: const InputDecoration(
                                            labelText: 'Contenido'),
                                        maxLines: 4,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final title = _titleController.text;
                                        final body = _bodyController.text;
                                        if (title.isEmpty || body.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Campos requeridos')));
                                        } else {
                                          editPost(
                                              _selectedPostId!, title, body);
                                        }
                                      },
                                      child: const Text('Guardar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deletePost(posts[index]['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Crear Publicación'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: _bodyController,
                      decoration: const InputDecoration(labelText: 'Contenido'),
                      maxLines: 4,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      final title = _titleController.text;
                      final body = _bodyController.text;
                      if (title.isEmpty || body.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Campos requeridos')));
                      } else {
                        createPost(title, body);
                      }
                    },
                    child: const Text('Crear'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
