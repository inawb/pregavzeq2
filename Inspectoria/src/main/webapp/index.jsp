<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="dto.CursoDTO"%>
<%@page import="dao.CursoDAO"%>
<%@page import="dto.AlumnoDTO"%>
<%@page import="dao.AlumnoDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- LÓGICA JAVA (BACKEND EN EL FRONTEND) ---
    
    // 1. Asegurar configuración de motor MySQL
    try { 
        FactoriaServiciosImpl.getFactoria().setMotor("mysql"); 
    } catch(Exception e){}

    // 2. CARGAR CURSOS (Usando CursoDAO)
    CursoDAO cursoDao = new CursoDAO();
    List<CursoDTO> listaCursos = new ArrayList<>();
    try { 
        listaCursos = cursoDao.listarCursos(); 
    } catch(Exception e) {
        System.out.println("Error cargando cursos: " + e.getMessage());
    }

    // 3. CARGAR ALUMNOS Y PREPARAR JSON (Usando AlumnoDAO)
    // Convertimos la lista de objetos Java a un texto JSON para que Javascript lo entienda
    AlumnoDAO alumnoDao = new AlumnoDAO();
    StringBuilder jsonAlumnos = new StringBuilder("[");
    try {
        ArrayList<AlumnoDTO> todos = alumnoDao.read();
        boolean first = true;
        for(AlumnoDTO a : todos) {
            if(!first) jsonAlumnos.append(",");
            
            // Creamos un objeto simple: {nombre: "Juan", curso: "1 Medio A"}
            String nombreCompleto = a.getNombreAlumno() + " " + a.getApellidoPAlumno();
            
            jsonAlumnos.append("{nombre:\"").append(nombreCompleto)
                       .append("\", curso:\"").append(a.getCurso()).append("\"}");
            first = false;
        }
    } catch(Exception e) {
        System.out.println("Error cargando alumnos: " + e.getMessage());
    }
    jsonAlumnos.append("]");

    // 4. CARGAR PROFESORES (Consulta Directa a tabla auxiliar para el menú)
    List<String> listaProfesores = new ArrayList<>();
    try {
        Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT nombre FROM profesores_lista ORDER BY nombre ASC");
        while(rs.next()) listaProfesores.add(rs.getString("nombre"));
    } catch(Exception e) {}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Inspectoría</title>
    <style>
        /* ESTILOS CSS */
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; padding: 20px; color: #333; margin: 0; }
        
        /* Contenedores */
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; box-shadow: 0 0 15px rgba(0,0,0,0.1); border-radius: 8px; }
        
        /* Formulario */
        .input-group { display: grid; grid-template-columns: 1fr 1fr 1fr 0.8fr 1fr 2fr 0.5fr; gap: 10px; background: #e9ecef; padding: 15px; border-radius: 8px 8px 0 0; border-bottom: 2px solid #dee2e6; }
        input, select, textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; height: 38px; box-sizing: border-box; }
        
        /* Botones */
        button.btn-agregar { background: #28a745; color: white; border: none; cursor: pointer; border-radius: 4px; font-weight: bold; height: 38px; width: 100%; transition: background 0.3s; }
        button.btn-agregar:hover { background: #218838; }
        button.btn-salir { background: #6c757d; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; margin-bottom: 10px; }
        
        /* Tabla */
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background: #343a40; color: white; }
        
        /* Etiquetas de Gravedad */
        .badge { padding: 5px 10px; border-radius: 12px; color: white; font-weight: bold; font-size: 0.85em; }
        .leve { background: #ffc107; color: #333; }
        .grave { background: #fd7e14; }
        .gravisima { background: #dc3545; }

        /* Pantalla Inicio */
        #pantalla-inicio { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 80vh; }
        .tarjeta-menu { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); font-size: 1.5rem; cursor: pointer; font-weight: bold; color: #2c3e50; transition: transform 0.2s; }
        .tarjeta-menu:hover { transform: translateY(-5px); color: #28a745; }
    </style>
</head>
<body>

    <!-- 1. PANTALLA DE INICIO -->
    <div id="pantalla-inicio">
        <h1 style="font-size: 3rem; color: #2c3e50; margin-bottom: 40px;">Sistema Escolar</h1>
        <div class="tarjeta-menu" onclick="abrirApp()">
            Ir a Libro de Anotaciones
        </div>
    </div>

    <!-- 2. PANTALLA DE APLICACIÓN -->
    <div id="pantalla-app" style="display: none;">
        <button class="btn-salir" onclick="cerrarApp()">← Volver al Inicio</button>
        
        <div class="container">
            <h2 style="text-align: center; color: #2c3e50;">Registro de Anotaciones</h2>

            <!-- FILA DE ENTRADA DE DATOS -->
            <div class="input-group">
                
                <!-- PROFESOR -->
                <select id="profesor">
                    <option value="">-- Profesor --</option>
                    <% for(String p : listaProfesores) { %>
                        <option value="<%= p %>"><%= p %></option>
                    <% } %>
                </select>

                <!-- CURSO (Filtra a los alumnos) -->
                <select id="curso" onchange="filtrarAlumnos()">
                    <option value="">-- Curso --</option>
                    <% for(CursoDTO c : listaCursos) { %>
                        <option value="<%= c.getNombreCurso() %>"><%= c.getNombreCurso() %></option>
                    <% } %>
                </select>

                <!-- ALUMNO (Se llena con JS) -->
                <select id="alumno" disabled>
                    <option value="">-- Seleccione Curso --</option>
                </select>

                <!-- GRAVEDAD -->
                <select id="gravedad">
                    <option value="Leve">Leve</option>
                    <option value="Grave">Grave</option>
                    <option value="Gravísima">Gravísima</option>
                </select>

                <!-- TEXTOS -->
                <input type="text" id="falta" placeholder="Título de la falta">
                <input type="text" id="descripcion" placeholder="Descripción breve...">
                
                <!-- BOTÓN GUARDAR -->
                <button type="button" class="btn-agregar" onclick="guardarEnBD()">Guardar</button>
            </div>

            <!-- TABLA -->
            <table id="tablaAnotaciones">
                <thead>
                    <tr>
                        <th width="12%">Fecha</th>
                        <th width="15%">Profesor</th>
                        <th width="10%">Curso</th>
                        <th width="15%">Alumno</th>
                        <th width="10%">Gravedad</th>
                        <th width="15%">Falta</th>
                        <th>Descripción</th>
                    </tr>
                </thead>
                <tbody id="cuerpoTabla">
                    <!-- Aquí aparecen las filas nuevas -->
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // --- VARIABLES GLOBALES ---
        // Recibimos el JSON generado por Java al cargar la página
        const baseDatosAlumnos = <%= jsonAlumnos.toString() %>;

        // --- FUNCIONES DE NAVEGACIÓN ---
        function abrirApp() {
            document.getElementById('pantalla-inicio').style.display = 'none';
            document.getElementById('pantalla-app').style.display = 'block';
        }
        function cerrarApp() {
            document.getElementById('pantalla-app').style.display = 'none';
            document.getElementById('pantalla-inicio').style.display = 'flex';
        }

        // --- LÓGICA DE FILTRADO ---
        function filtrarAlumnos() {
            const cursoSeleccionado = document.getElementById('curso').value;
            const selectAlumno = document.getElementById('alumno');
            
            // Reiniciar select
            selectAlumno.innerHTML = '<option value="">-- Seleccionar Alumno --</option>';
            
            if(cursoSeleccionado === "") {
                selectAlumno.disabled = true;
                return;
            }

            // Filtrar array en memoria
            const alumnosFiltrados = baseDatosAlumnos.filter(a => a.curso === cursoSeleccionado);
            
            // Llenar select
            alumnosFiltrados.forEach(alum => {
                const option = document.createElement("option");
                option.text = alum.nombre;
                option.value = alum.nombre;
                selectAlumno.add(option);
            });
            
            selectAlumno.disabled = false;
        }

        // --- LÓGICA DE GUARDADO (AJAX) ---
        async function guardarEnBD() {
            // 1. Obtener valores
            const profesor = document.getElementById('profesor').value;
            const curso = document.getElementById('curso').value;
            const alumno = document.getElementById('alumno').value;
            const gravedad = document.getElementById('gravedad').value;
            const falta = document.getElementById('falta').value;
            const descripcion = document.getElementById('descripcion').value;

            // 2. Validación Frontend (Javascript)
            if(profesor === "" || curso === "" || alumno === "" || falta === "") {
                alert("⚠ Por favor completa los campos obligatorios:\n- Profesor\n- Curso\n- Alumno\n- Falta");
                return;
            }

            // 3. Preparar datos para enviar
            const params = new URLSearchParams();
            params.append('profesor', profesor);
            params.append('curso', curso);
            params.append('alumno', alumno);
            params.append('gravedad', gravedad);
            params.append('falta', falta);
            params.append('descripcion', descripcion);

            // 4. Enviar a guardar.jsp
            try {
                const respuesta = await fetch('guardar.jsp', { 
                    method: 'POST', 
                    body: params 
                });
                const texto = await respuesta.text();

                if(texto.trim() === 'exito') {
                    // ÉXITO: Actualizar tabla visualmente
                    agregarFilaVisual(profesor, curso, alumno, gravedad, falta, descripcion);
                    alert("✅ Anotación guardada correctamente.");
                    
                    // Limpiar campos de texto
                    document.getElementById('falta').value = "";
                    document.getElementById('descripcion').value = "";
                } else {
                    alert("❌ Error al guardar en base de datos: " + texto);
                }
            } catch (error) {
                alert("❌ Error de conexión con el servidor.");
                console.error(error);
            }
        }

        // --- ACTUALIZAR TABLA VISUAL ---
        function agregarFilaVisual(prof, curso, alum, grav, fal, desc) {
            const tabla = document.getElementById('cuerpoTabla');
            const row = tabla.insertRow(0); // Insertar al principio
            const fecha = new Date().toLocaleString();
            
            let color = 'gravisima';
            if(grav === 'Leve') color = 'leve';
            if(grav === 'Grave') color = 'grave';

            row.innerHTML = `
                <td style="color:#666; font-size:0.9em;">\${fecha}</td>
                <td>\${prof}</td>
                <td>\${curso}</td>
                <td>\${alum}</td>
                <td><span class="badge \${color}">\${grav}</span></td>
                <td>\${fal}</td>
                <td>\${desc}</td>
            `;
        }
    </script>
</body>
</html>