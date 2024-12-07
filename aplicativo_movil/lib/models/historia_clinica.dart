class HistoriaClinica {
  final int idHistoria;
  final int idUsuario;
  final String diagnostico;
  final String sintomas;
  final String motivoConsulta;
  final String antecedentesPersonales;
  final String antecedentesFamiliares;
  final String alergias;
  final String medicamentosActuales;
  final String indicaciones;
  final String recomendaciones;
  final String observaciones;
  final String resultadosExamenes;
  final String? nombrePaciente; // Agregar nombre del paciente
  final String? apellidoPaciente; // Agregar apellido del paciente
  final String? nombreProfesional;
  final String? apellidoProfesional;

  HistoriaClinica({
    required this.idHistoria,
    required this.idUsuario,
    required this.diagnostico,
    required this.sintomas,
    required this.motivoConsulta,
    required this.antecedentesPersonales,
    required this.antecedentesFamiliares,
    required this.alergias,
    required this.medicamentosActuales,
    required this.indicaciones,
    required this.recomendaciones,
    required this.observaciones,
    required this.resultadosExamenes,
    required this.nombrePaciente, // Agregar en el constructor
    required this.apellidoPaciente, // Agregar en el constructor
    this.nombreProfesional,
    this.apellidoProfesional,
  });

  factory HistoriaClinica.fromMap(Map<String, dynamic> map) {
    return HistoriaClinica(
      idHistoria: map['id_historia'],
      idUsuario: map['id_usuario'],
      diagnostico: map['diagnostico'],
      sintomas: map['sintomas'],
      motivoConsulta: map['motivo_consulta'],
      antecedentesPersonales: map['antecedentes_personales'],
      antecedentesFamiliares: map['antecedentes_familiares'],
      alergias: map['alergias'],
      medicamentosActuales: map['medicamentos_actuales'],
      indicaciones: map['indicaciones'],
      recomendaciones: map['recomendaciones'],
      observaciones: map['observaciones'],
      resultadosExamenes: map['resultados_examenes'],
      nombrePaciente:
          map['nombre_paciente'] ?? 'N/A', // Obtener el nombre del paciente
      apellidoPaciente:
          map['apellido_paciente'] ?? 'N/A', // Obtener el apellido del paciente
      nombreProfesional: map['nombre_profesional'] ?? 'N/A',
      apellidoProfesional: map['apellido_profesional'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'diagnostico': diagnostico,
      'sintomas': sintomas,
      'motivo_consulta': motivoConsulta,
      'antecedentes_personales': antecedentesPersonales,
      'antecedentes_familiares': antecedentesFamiliares,
      'alergias': alergias,
      'medicamentos_actuales': medicamentosActuales,
      'indicaciones': indicaciones,
      'recomendaciones': recomendaciones,
      'observaciones': observaciones,
      'resultados_examenes': resultadosExamenes,
    };
  }
}
