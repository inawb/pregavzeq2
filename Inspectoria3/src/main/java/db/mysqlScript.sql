DROP DATABASE IF EXISTS prgavz;
CREATE DATABASE prgavz;
USE prgavz;

-- 1. TABLA USUARIOS (Login)
CREATE TABLE user(
    id int auto_increment primary key,
    usuario varchar(50),
    pass varchar(50),
    rol varchar(50)
);

-- 2. TABLA CURSO
CREATE TABLE curso(
    id_curso int auto_increment primary key,
    nombre_curso varchar(50),
    nivel int,
    anio_academico int
);

-- 3. TABLA FUNCIONARIOS (Reemplaza a Profesores)
-- Aquí van Inspectores, Profesores, Directores, etc.
CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL -- Ej: 'Profesor', 'Inspector General', 'Asistente'
);

-- 4. TABLA ALUMNO (Independiente, con datos de apoderado)
CREATE TABLE Alumno(
    id int AUTO_INCREMENT primary key,
    rut varchar(12),
    nombre varchar(50),
    apellido_paterno varchar(50),
    apellido_materno varchar(50),
    direccion varchar(100),
    nombre_apoderado varchar(100), -- Nuevo
    telefono_apoderado varchar(20), -- Nuevo
    id_curso int,
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso),
    cantidad_atrasos int DEFAULT 0,
    cantidad_inasistencias int DEFAULT 0
);

-- 5. TABLA ANOTACIONES
CREATE TABLE anotaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    nombre_funcionario VARCHAR(100), -- Quién hizo la anotación
    cargo_funcionario VARCHAR(50),   -- Su cargo
    curso VARCHAR(50),
    alumno VARCHAR(100),
    gravedad VARCHAR(50),
    falta TEXT, -- TEXT para soportar muchas faltas
    descripcion TEXT
);

-- =============================================
-- DATOS DE PRUEBA
-- =============================================

INSERT INTO user (usuario, pass, rol) VALUES ('admin', '1234', 'Admin');

INSERT INTO curso (nombre_curso, nivel, anio_academico) VALUES 
('1 Medio A', 1, 2024), 
('1 Medio B', 1, 2024), 
('2 Medio A', 2, 2024);

-- FUNCIONARIOS (Mezcla de cargos)
INSERT INTO funcionarios (nombre, cargo) VALUES 
('Juan Perez', 'Profesor Matemáticas'), 
('Maria Lopez', 'Inspectoría'), 
('Pedro Silva', 'Profesor Historia'),
('Roberto Gomez', 'Inspector de Patio'),
('Ana Torres', 'Directora');

-- ALUMNOS (Datos completos)
INSERT INTO Alumno (rut, nombre, apellido_paterno, apellido_materno, direccion, nombre_apoderado, telefono_apoderado, id_curso) VALUES
('21.111.111-1', 'Carlos', 'Ruiz', 'Soto', 'Calle 1', 'Mama de Carlos', '911111111', 1),
('21.222.222-2', 'Ana', 'Diaz', 'Castro', 'Calle 2', 'Papa de Ana', '922222222', 1),
('21.333.333-3', 'Luis', 'Gomez', 'Tapia', 'Calle 3', 'Abuela de Luis', '933333333', 2);