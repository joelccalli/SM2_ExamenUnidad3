import 'package:flutter/material.dart';

class SeleccionarPaciente extends StatelessWidget {
  final List<String> pacientes;
  final String? selectedPaciente;
  final ValueChanged<String?> onChanged;

  const SeleccionarPaciente({
    Key? key,
    required this.pacientes,
    required this.selectedPaciente,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Selecciona un paciente'),
      value: selectedPaciente,
      onChanged: onChanged,
      items: pacientes.map<DropdownMenuItem<String>>((String paciente) {
        return DropdownMenuItem<String>(
          value: paciente,
          child: Text(paciente),
        );
      }).toList(),
    );
  }
}
