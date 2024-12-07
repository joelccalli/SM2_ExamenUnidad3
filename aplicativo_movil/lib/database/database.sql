CREATE DATABASE IF NOT EXISTS gestion_historia_clinica;
USE gestion_historia_clinica;

-- Tabla Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('paciente', 'profesional') NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso DATETIME DEFAULT NULL
);

-- Tabla Historias Clínicas
CREATE TABLE IF NOT EXISTS Historias_Clinicas (
    id_historia INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    diagnostico TEXT,
    tratamientos TEXT,
    observaciones TEXT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla Citas Médicas
CREATE TABLE IF NOT EXISTS Citas_Medicas (
    id_cita INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    id_profesional INTEGER NOT NULL,
    fecha_cita DATETIME NOT NULL,
    estado TEXT CHECK(estado IN ('pendiente', 'confirmada', 'cancelada')),
    observaciones TEXT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_profesional) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla Mensajes del Asistente Virtual
CREATE TABLE IF NOT EXISTS Mensajes_Asistente (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    mensaje TEXT NOT NULL,
    respuesta TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla Historial de Accesos
CREATE TABLE IF NOT EXISTS Historial_A accesos (
    id_acceso INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_acceso DATETIME DEFAULT CURRENT_TIMESTAMP,
    direccion_ip VARCHAR(45),
    tipo_dispositivo VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);
