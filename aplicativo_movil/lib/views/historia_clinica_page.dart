import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/historia_clinica.dart';
import 'crear_historia_clinica_page.dart';
import '../controllers/historia_clinica_controller.dart';

class HistoriaClinicaPage extends StatefulWidget {
  final int idUsuario;
  final String tipoUsuario;
  final String nombre;
  final String apellido;

  const HistoriaClinicaPage({
    Key? key,
    required this.idUsuario,
    required this.tipoUsuario,
    required this.nombre,
    required this.apellido,
  }) : super(key: key);

  @override
  _HistoriaClinicaPageState createState() => _HistoriaClinicaPageState();
}

class _HistoriaClinicaPageState extends State<HistoriaClinicaPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<HistoriaClinica> _historiasClinicas = [];
  List<HistoriaClinica> _historiasClinicasFiltradas = [];
  final HistoriaClinicaController _controller = HistoriaClinicaController();

  @override
  void initState() {
    super.initState();
    _cargarHistoriasClinicas();
  }

  Future<void> _cargarHistoriasClinicas() async {
    List<Map<String, dynamic>> historias;

    if (widget.tipoUsuario == 'profesional') {
      historias = await _databaseHelper.getTodasLasHistoriasClinicas();
    } else {
      historias = await _databaseHelper.getHistoriasClinicasPorUsuario(widget.idUsuario);
    }

    setState(() {
      _historiasClinicas = historias.map((json) => HistoriaClinica.fromMap(json)).toList();
      _historiasClinicasFiltradas = _historiasClinicas;
    });
  }

  void _agregarHistoriaClinica() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearHistoriaClinicaPage(
          idUsuario: widget.idUsuario,
          tipoUsuario: widget.tipoUsuario,
          nombre: widget.nombre,
          apellido: widget.apellido,
        ),
      ),
    ).then((_) => _cargarHistoriasClinicas());
  }

  void _eliminarHistoriaClinica(int idHistoria) async {
    await _databaseHelper.deleteHistoriaClinica(idHistoria);
    _cargarHistoriasClinicas();
  }

  void _confirmarEliminacion(int idHistoria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Historia Clínica'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar esta historia clínica?'),
        actions: [
          TextButton(
            onPressed: () {
              _eliminarHistoriaClinica(idHistoria);
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

  void _buscarHistorias(String query) {
    setState(() {
      if (query.isEmpty) {
        _historiasClinicasFiltradas = _historiasClinicas;
      } else {
        _historiasClinicasFiltradas = _historiasClinicas.where((historia) {
          final nombreCompleto = '${historia.nombrePaciente} ${historia.apellidoPaciente}'.toLowerCase();
          final diagnosticoLower = historia.diagnostico.toLowerCase();
          final queryLower = query.toLowerCase();
          
          return nombreCompleto.contains(queryLower) || 
                 diagnosticoLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historias Clínicas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar historias clínicas',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                hintText: 'Buscar por nombre',
              ),
              onChanged: _buscarHistorias,
            ),
          ),
          if (widget.tipoUsuario == 'profesional') ...[
            ElevatedButton(
              onPressed: _agregarHistoriaClinica,
              child: const Text('Agregar Historia Clínica'),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: _historiasClinicasFiltradas.isEmpty
                ? const Center(child: Text('No hay historias clínicas disponibles'))
                : ListView.builder(
                    itemCount: _historiasClinicasFiltradas.length,
                    itemBuilder: (context, index) {
                      final historia = _historiasClinicasFiltradas[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Historia #${historia.idHistoria}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Paciente: ${historia.nombrePaciente} ${historia.apellidoPaciente}'),
                              Text('Profesional: ${historia.nombreProfesional} ${historia.apellidoProfesional}'),
                              Text('Diagnóstico: ${historia.diagnostico ?? 'N/A'}'),
                              Text('Síntomas: ${historia.sintomas}'),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Historia Clínica #${historia.idHistoria}'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Paciente: ${historia.nombrePaciente} ${historia.apellidoPaciente}'),
                                      const SizedBox(height: 8),
                                      Text('Profesional: ${historia.nombreProfesional} ${historia.apellidoProfesional}'),
                                      const SizedBox(height: 8),
                                      Text('Diagnóstico: ${historia.diagnostico}'),
                                      const SizedBox(height: 8),
                                      Text('Síntomas: ${historia.sintomas}'),
                                      const SizedBox(height: 8),
                                      Text('Motivo de Consulta: ${historia.motivoConsulta}'),
                                      const SizedBox(height: 8),
                                      Text('Antecedentes Personales: ${historia.antecedentesPersonales}'),
                                      const SizedBox(height: 8),
                                      Text('Antecedentes Familiares: ${historia.antecedentesFamiliares}'),
                                      const SizedBox(height: 8),
                                      Text('Alergias: ${historia.alergias}'),
                                      const SizedBox(height: 8),
                                      Text('Medicamentos Actuales: ${historia.medicamentosActuales}'),
                                      const SizedBox(height: 8),
                                      Text('Indicaciones: ${historia.indicaciones}'),
                                      const SizedBox(height: 8),
                                      Text('Recomendaciones: ${historia.recomendaciones}'),
                                      const SizedBox(height: 8),
                                      Text('Observaciones: ${historia.observaciones}'),
                                      const SizedBox(height: 8),
                                      Text('Resultados de Exámenes: ${historia.resultadosExamenes}'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          trailing: widget.tipoUsuario == 'profesional'
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmarEliminacion(historia.idHistoria),
                                )
                              : null,
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
