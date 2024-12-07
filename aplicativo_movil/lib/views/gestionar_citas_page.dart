import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class GestionarCitasPage extends StatefulWidget {
  const GestionarCitasPage({Key? key}) : super(key: key);

  @override
  _GestionarCitasPageState createState() => _GestionarCitasPageState();
}

class _GestionarCitasPageState extends State<GestionarCitasPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _citasFuture;

  @override
  void initState() {
    super.initState();
    _cargarCitas();
  }

  void _cargarCitas() {
    setState(() {
      _citasFuture = _databaseHelper.getTodasLasCitas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Citas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _citasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar citas.'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay citas registradas.'));
          } else if (snapshot.hasData) {
            final citas = snapshot.data!;
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                final cita = citas[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Cita con Profesional ID: ${cita['id_profesional']}',
                    ),
                    subtitle: Text(
                        'Fecha: ${cita['fecha_cita']} \nEstado: ${cita['estado']}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'Editar') {
                          _editarCita(context, cita);
                        } else if (value == 'Eliminar') {
                          _eliminarCita(cita['id_cita']);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return ['Editar', 'Eliminar']
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearCita(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _crearCita(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CitaFormPage(
          onSave: (nuevaCita) async {
            await _databaseHelper.insertCita(nuevaCita);
            _cargarCitas();
          },
        ),
      ),
    );
  }

  void _editarCita(BuildContext context, Map<String, dynamic> cita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CitaFormPage(
          cita: cita,
          onSave: (citaEditada) async {
            await _databaseHelper.updateCita(cita['id_cita'], citaEditada);
            _cargarCitas();
          },
        ),
      ),
    );
  }

  void _eliminarCita(int idCita) async {
    await _databaseHelper.deleteCita(idCita);
    _cargarCitas();
  }
}

class _CitaFormPage extends StatefulWidget {
  final Map<String, dynamic>? cita;
  final Function(Map<String, dynamic>) onSave;

  const _CitaFormPage({Key? key, this.cita, required this.onSave})
      : super(key: key);

  @override
  __CitaFormPageState createState() => __CitaFormPageState();
}

class __CitaFormPageState extends State<_CitaFormPage> {
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _profesionalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cita != null) {
      _fechaController.text = widget.cita!['fecha_cita'];
      _estadoController.text = widget.cita!['estado'];
      _profesionalController.text = widget.cita!['id_profesional'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _profesionalController,
              decoration: const InputDecoration(labelText: 'ID Profesional'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fechaController,
              decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _estadoController,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final nuevaCita = {
                  'id_profesional': int.tryParse(_profesionalController.text),
                  'fecha_cita': _fechaController.text,
                  'estado': _estadoController.text,
                };
                widget.onSave(nuevaCita);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
