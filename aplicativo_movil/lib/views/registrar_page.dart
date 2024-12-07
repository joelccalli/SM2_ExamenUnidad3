import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RegistrarPage extends StatefulWidget {
  const RegistrarPage({super.key});

  @override
  _RegistrarPageState createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String _tipoUsuario = 'paciente';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _contrasenaController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _tipoUsuario,
              onChanged: (String? newValue) {
                setState(() {
                  _tipoUsuario = newValue!;
                });
              },
              items: <String>['paciente', 'profesional']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _registrarUsuario();
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrarUsuario() async {
    final usuario = {
      'nombre': _nombreController.text,
      'apellido': _apellidoController.text,
      'email': _emailController.text,
      'contraseña': _contrasenaController.text,
      'tipo_usuario': _tipoUsuario,
    };
    await _databaseHelper.insertUsuario(usuario);
    Navigator.pop(context);
  }
}
