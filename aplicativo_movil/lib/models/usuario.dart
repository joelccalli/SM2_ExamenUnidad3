class Usuario {
  final int id; // Cambia 'id_usuario' a 'id'
  final String nombre;
  final String apellido;
  final String email;
  final String contrasena;
  final String tipoUsuario;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.contrasena,
    required this.tipoUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': id, // Aquí sigue usando 'id_usuario' para la base de datos
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'contraseña': contrasena,
      'tipo_usuario': tipoUsuario,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id_usuario'], // Asegúrate de usar 'id_usuario' aquí
      nombre: map['nombre'],
      apellido: map['apellido'],
      email: map['email'],
      contrasena: map['contraseña'],
      tipoUsuario: map['tipo_usuario'],
    );
  }
}
