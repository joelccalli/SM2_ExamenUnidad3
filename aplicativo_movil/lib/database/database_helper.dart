import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/usuario.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'gestion_historia_clinica.db');
    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Crear tabla Usuarios
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Usuarios (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        contraseña TEXT NOT NULL,
        tipo_usuario TEXT CHECK(tipo_usuario IN ('paciente', 'profesional')),
        fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        ultimo_acceso DATETIME DEFAULT NULL
      )
    ''');

    // Crear tabla Historias Clínicas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Historias_Clinicas (
        id_historia INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        nombre_profesional TEXT,
        apellido_profesional TEXT,
        fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        diagnostico TEXT,
        sintomas TEXT,
        motivo_consulta TEXT,
        antecedentes_personales TEXT,
        antecedentes_familiares TEXT,
        alergias TEXT,
        medicamentos_actuales TEXT,
        indicaciones TEXT,
        recomendaciones TEXT,
        observaciones TEXT,
        resultados_examenes TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
    );
  ''');

    // Crear tabla Citas Médicas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Citas_Medicas (
        id_cita INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        id_profesional INTEGER NOT NULL,
        fecha_cita DATETIME NOT NULL,
        estado TEXT CHECK(estado IN ('pendiente', 'confirmada', 'cancelada')),
        observaciones TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
        FOREIGN KEY (id_profesional) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
      )
    ''');

    // Crear tabla Mensajes del Asistente Virtual
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Mensajes_Asistente (
        id_mensaje INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        mensaje TEXT NOT NULL,
        respuesta TEXT,
        fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
      )
    ''');

    // Crear tabla Historial de Accesos
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Historial_Accesos (
        id_acceso INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        fecha_acceso DATETIME DEFAULT CURRENT_TIMESTAMP,
        direccion_ip TEXT,
        tipo_dispositivo TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
      )
    ''');
  }

  // Métodos para insertar, obtener, actualizar y eliminar

  Future<void> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.insert('Usuarios', usuario);
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query('Usuarios');
  }

  Future<int> updateUsuario(int id, Map<String, dynamic> usuario) async {
    final db = await database;
    return await db
        .update('Usuarios', usuario, where: 'id_usuario = ?', whereArgs: [id]);
  }

  Future<int> deleteUsuario(int id) async {
    final db = await database;
    return await db
        .delete('Usuarios', where: 'id_usuario = ?', whereArgs: [id]);
  }

  // Método para insertar una historia clínica
  Future<void> insertHistoriaClinica(Map<String, dynamic> historia) async {
    final db = await database;
    await db.insert('Historias_Clinicas', historia);
  }

  Future<List<Usuario>> getUsuariosPorTipo(String tipo) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Usuarios',
      where: 'tipo_usuario = ?',
      whereArgs: [tipo],
    );

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }

  // Método para obtener historias clínicas por usuario
  Future<List<Map<String, dynamic>>> getHistoriasClinicasPorUsuario(
      int idUsuario) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT h.*, u.nombre AS nombre_paciente, u.apellido AS apellido_paciente
    FROM Historias_Clinicas h
    JOIN Usuarios u ON h.id_usuario = u.id_usuario
    WHERE h.id_usuario = ?
  ''', [idUsuario]);
  }

  // Método para obtener todas las historias clínicas
  Future<List<Map<String, dynamic>>> getTodasLasHistoriasClinicas() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT h.*, u.nombre AS nombre_paciente, u.apellido AS apellido_paciente
    FROM Historias_Clinicas h
    JOIN Usuarios u ON h.id_usuario = u.id_usuario
  ''');
  }

  // Método para eliminar una historia clínica
  Future<int> deleteHistoriaClinica(int idHistoria) async {
    final db = await database;
    return await db.delete(
      'Historias_Clinicas',
      where: 'id_historia = ?',
      whereArgs: [idHistoria],
    );
  }

      // Obtener todas las citas
    Future<List<Map<String, dynamic>>> getTodasLasCitas() async {
      final db = await database;
      return db.query('Citas_Medicas');
    }

    // Insertar una nueva cita
    Future<void> insertCita(Map<String, dynamic> cita) async {
      final db = await database;
      await db.insert('Citas_Medicas', cita);
    }

    // Actualizar una cita existente
    Future<int> updateCita(int idCita, Map<String, dynamic> cita) async {
      final db = await database;
      return db.update('Citas_Medicas', cita,
          where: 'id_cita = ?', whereArgs: [idCita]);
    }

    // Eliminar una cita
    Future<int> deleteCita(int idCita) async {
      final db = await database;
      return db.delete('Citas_Medicas', where: 'id_cita = ?', whereArgs: [idCita]);
    }

    Future<List<Map<String, dynamic>>> buscarHistoriasClinicas(String query) async {
      final db = await database;
      return await db.rawQuery('''
        SELECT h.*, u.nombre AS nombre_paciente, u.apellido AS apellido_paciente
        FROM Historias_Clinicas h
        JOIN Usuarios u ON h.id_usuario = u.id_usuario
        WHERE u.nombre LIKE ? OR u.apellido LIKE ? OR h.diagnostico LIKE ?
      ''', ['%$query%', '%$query%', '%$query%']);
    }

}
