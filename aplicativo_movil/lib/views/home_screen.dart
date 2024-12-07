import 'package:flutter/material.dart';
import 'usuarios_page.dart';
import 'registrar_page.dart';
import 'login_page.dart';
import 'historia_clinica_page.dart'; 
import 'gestionar_citas_page.dart'; 

class HomeScreen extends StatefulWidget {
  final String tipoUsuario;
  final int idUsuario; 
  final String nombre; 
  final String apellido; 

  const HomeScreen({
    Key? key,
    required this.tipoUsuario,
    required this.idUsuario,
    required this.nombre, 
    required this.apellido, 
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tipoUsuario == 'paciente') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tienes un historial clínico pendiente'),
            action: SnackBarAction(
              label: 'Ver Ahora',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoriaClinicaPage(
                      idUsuario: widget.idUsuario,
                      tipoUsuario: widget.tipoUsuario,
                      nombre: widget.nombre,
                      apellido: widget.apellido,
                    ),
                  ),
                );
              },
            ),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Bienvenido, ${widget.nombre} ${widget.apellido}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoriaClinicaPage(
                      idUsuario: widget.idUsuario,
                      tipoUsuario: widget.tipoUsuario, 
                      nombre: widget.nombre, 
                      apellido: widget.apellido, 
                    ),
                  ),
                );
              },
              child: const Text('Ver Historial Clínico'),
            ),
            if (widget.tipoUsuario == 'profesional') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UsuariosPage()),
                  );
                },
                child: const Text('Ver Usuarios'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const GestionarCitasPage(), 
                    ),
                  );
                },
                child: const Text('Gestionar Citas'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrarPage()),
                  );
                },
                child: const Text('Registrar Usuario'),
              ),
            ] else if (widget.tipoUsuario == 'paciente') ...[
              ElevatedButton(
                onPressed: () {
                  // Navegar a la página de citas o similar
                },
                child: const Text('Solicitar Cita'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
