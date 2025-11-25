-- =============================================
-- SCRIPT BASE DE DATOS: PRGAVZ (SISTEMA ESCOLAR)
-- =============================================

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

-- 2. TABLA PERSONA (Datos personales base)
CREATE TABLE Persona(
    rut int primary key,
    nombre varchar(50),
    apellido_paterno varchar(50),
    apellido_materno varchar(50),
    direccion varchar(50)
);

-- 3. TABLA CURSO
CREATE TABLE curso(
    id_curso int auto_increment primary key,
    nombre_curso varchar(50),
    nivel int,
    anio_academico int
);

-- 4. TABLA ALUMNO (Hereda de Persona y pertenece a un Curso)
CREATE TABLE Alumno(
    id int AUTO_INCREMENT primary key,
    rut int,
    FOREIGN KEY (rut) REFERENCES Persona(rut), 
    id_curso int,
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso),
    cantidad_atrasos int DEFAULT 0,
    cantidad_inasistencias int DEFAULT 0
);

-- 5. TABLA FUNCIONARIO (Hereda de Persona)
CREATE TABLE Funcionario(
    id_funcionario int auto_increment primary key,
    rut int,
    FOREIGN KEY (rut) REFERENCES Persona(rut), 
    cursos varchar(50)
);

-- 6. TABLA ATRASO (Para historial de atrasos)
CREATE TABLE Atraso (
    id_atraso INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    razon VARCHAR(100),
    FOREIGN KEY (id_alumno) REFERENCES Alumno(id) ON DELETE CASCADE
);

-- 7. TABLA INASISTENCIA (Para historial de inasistencias)
CREATE TABLE Inasistencia (
    id_inasistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    fecha DATE NOT NULL,
    justificada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_alumno) REFERENCES Alumno(id) ON DELETE CASCADE
);

-- 8. TABLA ANOTACIONES (¡CRUCIAL! Para tu página web de anotaciones)
CREATE TABLE anotaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    profesor VARCHAR(100),
    curso VARCHAR(50),
    alumno VARCHAR(100),
    gravedad VARCHAR(50),
    falta VARCHAR(255),
    descripcion TEXT
);

-- 9. TABLA AUXILIAR PROFESORES (Para llenar el menú desplegable del Index)
CREATE TABLE profesores_lista (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- =============================================
-- TRIGGERS (AUTOMATIZACIÓN DE CONTADORES)
-- =============================================
delimiter //

CREATE TRIGGER aumentaAtrasosAlumno AFTER INSERT ON Atraso
FOR EACH ROW
BEGIN
    UPDATE Alumno SET cantidad_atrasos = cantidad_atrasos + 1
    WHERE Alumno.id = NEW.id_alumno;
END;//

CREATE TRIGGER aumentaInasistenciasAlumno AFTER INSERT ON Inasistencia
FOR EACH ROW
BEGIN
    UPDATE Alumno SET cantidad_inasistencias = cantidad_inasistencias + 1
    WHERE Alumno.id = NEW.id_alumno;
END;//

CREATE TRIGGER disminuyeAtrasosAlumno AFTER DELETE ON Atraso
FOR EACH ROW
BEGIN
    UPDATE Alumno SET cantidad_atrasos = cantidad_atrasos - 1
    WHERE Alumno.id = old.id_alumno;
END;//

CREATE TRIGGER disminuyeInasistenciasAlumno AFTER DELETE ON Inasistencia
FOR EACH ROW
BEGIN
    UPDATE Alumno SET cantidad_inasistencias = cantidad_inasistencias - 1
    WHERE Alumno.id = old.id_alumno;
END;//

delimiter ;

-- =============================================
-- DATOS DE PRUEBA (POBLADO INICIAL)
-- =============================================

-- Usuarios del sistema
INSERT INTO user (usuario,pass,rol) VALUES ('Leo','1234', 'Profesor');
INSERT INTO user (usuario,pass,rol) VALUES ('admin','1234', 'Admin');

-- Profesores (Para que aparezcan en el menú de Anotaciones)
INSERT INTO profesores_lista (nombre) VALUES ('Leo Profe'), ('Juan Perez'), ('Maria Lopez');

-- Cursos
INSERT INTO curso (nombre_curso, nivel, anio_academico) VALUES 
('1 Medio A', 1, 2024), 
('1 Medio B', 1, 2024), 
('2 Medio A', 2, 2024);

-- Personas (Base de datos de gente real)
INSERT INTO Persona (rut, nombre, apellido_paterno, apellido_materno, direccion) VALUES
(1111, 'Benjamin', 'Vicuna', 'Mackenna', 'Santiago'),
(2222, 'Ana', 'Diaz', 'Castro', 'Calle 2'),
(3333, 'Luis', 'Gomez', 'Tapia', 'Calle 3');

-- Alumnos (Vinculamos la Persona con el Curso)
-- Benjamin y Ana van al "1 Medio A" (id_curso 1)
INSERT INTO Alumno (rut, id_curso) VALUES (1111, 1);
INSERT INTO Alumno (rut, id_curso) VALUES (2222, 1);

-- Luis va al "1 Medio B" (id_curso 2)
INSERT INTO Alumno (rut, id_curso) VALUES (3333, 2);