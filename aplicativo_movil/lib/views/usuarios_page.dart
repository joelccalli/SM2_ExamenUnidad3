import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _usuariosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    final usuarios = await _databaseHelper.getUsuarios();
    setState(() {
      _usuarios = usuarios;
      _usuariosFiltrados = usuarios;
    });
  }

  void _buscarUsuarios(String query) {
    setState(() {
      if (query.isEmpty) {
        _usuariosFiltrados = _usuarios;
      } else {
        _usuariosFiltrados = _usuarios.where((usuario) {
          final nombreCompleto = '${usuario['nombre']} ${usuario['apellido']}'.toLowerCase();
          final email = usuario['email'].toLowerCase();
          final queryLower = query.toLowerCase();
          return nombreCompleto.contains(queryLower) || 
                 email.contains(queryLower);
        }).toList();
      }
    });
  }

  void _editarUsuario(Map<String, dynamic> usuario) {
    final nombreController = TextEditingController(text: usuario['nombre']);
    final apellidoController = TextEditingController(text: usuario['apellido']);
    final emailController = TextEditingController(text: usuario['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final usuarioActualizado = {
                ...usuario,
                'nombre': nombreController.text,
                'apellido': apellidoController.text,
                'email': emailController.text,
              };
              await _databaseHelper.updateUsuario(
                usuario['id_usuario'], 
                usuarioActualizado
              );
              Navigator.pop(context);
              _loadUsuarios();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarUsuario(int idUsuario) async {
    await _databaseHelper.deleteUsuario(idUsuario);
    _loadUsuarios();
  }

  void _confirmarEliminacion(int idUsuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () {
              _eliminarUsuario(idUsuario);
              Navigator.of(context).pop();
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar usuarios',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                hintText: 'Buscar por nombre o email',
              ),
              onChanged: _buscarUsuarios,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _usuariosFiltrados.length,
              itemBuilder: (context, index) {
                final usuario = _usuariosFiltrados[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text('${usuario['nombre']} ${usuario['apellido']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${usuario['email']}'),
                        Text('Tipo: ${usuario['tipo_usuario']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (usuario['tipo_usuario'] != 'profesional')
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarEliminacion(usuario['id_usuario']),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarUsuario(usuario),
                        ),
                      ],
                    ),
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
