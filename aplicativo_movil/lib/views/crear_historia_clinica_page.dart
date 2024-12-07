import 'package:flutter/material.dart';
import '../controllers/historia_clinica_controller.dart';
import '../models/usuario.dart';
import 'home_screen.dart';

class CrearHistoriaClinicaPage extends StatefulWidget {
  final int idUsuario;
  final String tipoUsuario;
  final String nombre;
  final String apellido;

  const CrearHistoriaClinicaPage({
    Key? key,
    required this.idUsuario,
    required this.tipoUsuario,
    required this.nombre,
    required this.apellido,
  }) : super(key: key);

  @override
  _CrearHistoriaClinicaPageState createState() =>
      _CrearHistoriaClinicaPageState();
}

class _CrearHistoriaClinicaPageState extends State<CrearHistoriaClinicaPage> {
  final HistoriaClinicaController _controller = HistoriaClinicaController();
  List<Usuario> _pacientes = [];
  Usuario? _selectedPaciente;

  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _sintomasController = TextEditingController();
  final TextEditingController _motivoConsultaController =
      TextEditingController();
  final TextEditingController _antecedentesPersonalesController =
      TextEditingController();
  final TextEditingController _antecedentesFamiliaresController =
      TextEditingController();
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _medicamentosActualesController =
      TextEditingController();
  final TextEditingController _indicacionesController = TextEditingController();
  final TextEditingController _recomendacionesController =
      TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();
  final TextEditingController _resultadosExamenesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPacientes();
  }

  void _fetchPacientes() async {
    List<Usuario> pacientes = await _controller.obtenerPacientes();
    setState(() {
      _pacientes = pacientes;
    });
  }

  void _guardarHistoriaClinica() async {
    if (_selectedPaciente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, seleccione un paciente.')),
      );
      return;
    }

    await _controller.guardarHistoriaClinica(
      idUsuario: _selectedPaciente!.id,
      nombreProfesional: widget.nombre,
      apellidoProfesional: widget.apellido,
      diagnostico: _diagnosticoController.text,
      sintomas: _sintomasController.text,
      motivoConsulta: _motivoConsultaController.text,
      antecedentesPersonales: _antecedentesPersonalesController.text,
      antecedentesFamiliares: _antecedentesFamiliaresController.text,
      alergias: _alergiasController.text,
      medicamentosActuales: _medicamentosActualesController.text,
      indicaciones: _indicacionesController.text,
      recomendaciones: _recomendacionesController.text,
      observaciones: _observacionesController.text,
      resultadosExamenes: _resultadosExamenesController.text,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          tipoUsuario: widget.tipoUsuario,
          idUsuario: widget.idUsuario,
          nombre: widget.nombre,
          apellido: widget.apellido,
        ),
      ),
    );
  }

  void _generarDiagnosticoIA() async {
    String sintomas = _sintomasController.text;
    String antecedentes = _antecedentesPersonalesController.text + ' ' + _antecedentesFamiliaresController.text;
    String alergias = _alergiasController.text;
    String medicamentos  = _medicamentosActualesController.text;

    String prompt = "Mi paciente tiene los sintomas " + sintomas + ", Sus atecendetes son:" + antecedentes + ", sus alergias son: " +  alergias + ". Y esta tomando los siguientes medicamentos:" + medicamentos +". Cual podria ser el diagnóstico médico? No me digas que la informacion proporcionada es insuficiente. Solo dame las posibilidades a considerar, se corto y preciso.";
    String diagnostico = await _controller.generarDiagnosticoIA(prompt);
    setState(() {
      _resultadosExamenesController.text = diagnostico;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Historia Clínica'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Usuario>(
              hint: const Text('Seleccionar Paciente'),
              value: _selectedPaciente,
              items: _pacientes.map((paciente) {
                return DropdownMenuItem<Usuario>(
                  value: paciente,
                  child: Text('${paciente.nombre} ${paciente.apellido}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaciente = value;
                });
              },
            ),
            TextField(
              controller: _diagnosticoController,
              decoration: const InputDecoration(labelText: 'Diagnóstico'),
              maxLines: 2,
            ),
            TextField(
              controller: _sintomasController,
              decoration: const InputDecoration(labelText: 'Síntomas'),
              maxLines: 2,
            ),
            TextField(
              controller: _motivoConsultaController,
              decoration:
                  const InputDecoration(labelText: 'Motivo de Consulta'),
              maxLines: 2,
            ),
            TextField(
              controller: _antecedentesPersonalesController,
              decoration:
                  const InputDecoration(labelText: 'Antecedentes Personales'),
              maxLines: 2,
            ),
            TextField(
              controller: _antecedentesFamiliaresController,
              decoration:
                  const InputDecoration(labelText: 'Antecedentes Familiares'),
              maxLines: 2,
            ),
            TextField(
              controller: _alergiasController,
              decoration: const InputDecoration(labelText: 'Alergias'),
              maxLines: 2,
            ),
            TextField(
              controller: _medicamentosActualesController,
              decoration:
                  const InputDecoration(labelText: 'Medicamentos Actuales'),
              maxLines: 2,
            ),
            TextField(
              controller: _indicacionesController,
              decoration: const InputDecoration(labelText: 'Indicaciones'),
              maxLines: 2,
            ),
            TextField(
              controller: _recomendacionesController,
              decoration: const InputDecoration(labelText: 'Recomendaciones'),
              maxLines: 2,
            ),
            TextField(
              controller: _observacionesController,
              decoration: const InputDecoration(labelText: 'Observaciones'),
              maxLines: 2,
            ),
            ElevatedButton(
              onPressed: _generarDiagnosticoIA,
              child: const Text('Generar Diagnostico con IA'),
            ),
            TextField(
              controller: _resultadosExamenesController,
              decoration:
                  const InputDecoration(labelText: 'Resultados de Exámenes'),
              maxLines: 10,
              minLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarHistoriaClinica,
              child: const Text('Guardar Historia Clínica'),
            ),
          ],
        ),
      ),
    );
  }
}
