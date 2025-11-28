<%@page import="dto.AnotacionDTO"%>
<%@page import="dao.AnotacionDAO"%>
<%@page import="java.util.*"%>
<%@page import="dto.CursoDTO"%>
<%@page import="dao.CursoDAO"%>
<%@page import="dto.AlumnoDTO"%>
<%@page import="dao.AlumnoDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Configuración inicial
    try { FactoriaServiciosImpl.getFactoria().setMotor("mysql"); } catch(Exception e){}

    // 2. Cargar Cursos
    CursoDAO cursoDao = new CursoDAO();
    List<CursoDTO> listaCursos = new ArrayList<>();
    try { listaCursos = cursoDao.listarCursos(); } catch(Exception e) {}

    // 3. Cargar Alumnos
    AlumnoDAO alumnoDao = new AlumnoDAO();
    StringBuilder jsonAlumnos = new StringBuilder("[");
    try {
        ArrayList<AlumnoDTO> todos = alumnoDao.read();
        boolean f = true;
        for(AlumnoDTO a : todos) {
            if(!f) jsonAlumnos.append(",");
            // CORRECCIÓN: Usamos getNombreCompleto() del nuevo DTO
            String nombre = a.getNombreCompleto();
            // Escapar comillas para evitar errores en JS
            nombre = nombre.replace("'", "\\'"); 
            jsonAlumnos.append("{nombre:\"").append(nombre)
                       .append("\", curso:\"").append(a.getCurso()).append("\"}");
            f = false;
        }
    } catch(Exception e) {}
    jsonAlumnos.append("]");

    // 4. LÓGICA DE BÚSQUEDA
    String alumnoBusqueda = request.getParameter("alumnoBusqueda");
    String cursoSeleccionado = request.getParameter("cursoSeleccionado"); 
    
    List<AnotacionDTO> resultados = new ArrayList<>();
    
    if(alumnoBusqueda != null && !alumnoBusqueda.isEmpty()) {
        // Aseguramos la codificación correcta
        alumnoBusqueda = new String(alumnoBusqueda.getBytes("ISO-8859-1"), "UTF-8");
        AnotacionDAO anotacionDao = new AnotacionDAO();
        resultados = anotacionDao.listarPorAlumno(alumnoBusqueda);
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial - Inspectoría</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; padding: 20px; }
        .container { max-width: 1100px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        /* --- SOLUCIÓN DE DESBORDAMIENTO --- */
        .tabla-contenedor {
            overflow-x: auto;
            border-radius: 4px;
            margin-top: 20px;
            border: 1px solid #dee2e6;
        }
        
        table { table-layout: fixed; width: 100%; margin-bottom: 0; }
        td { word-wrap: break-word; overflow-wrap: break-word; white-space: normal; vertical-align: middle; font-size: 0.9em; padding: 10px !important; }

        /* Anchos de columna */
        .col-fecha { width: 12%; }
        .col-profe { width: 15%; font-weight: bold; color: #555; }
        .col-tipo { width: 12%; text-align: center; }
        .col-faltas { width: 25%; font-weight: 500; }
        .col-desc { width: 36%; color: #444; font-style: italic; }

        /* Colores de gravedad */
        .badge-positiva { background-color: #28a745; color: white; }
        .badge-leve { background-color: #ffc107; color: #212529; }
        .badge-grave { background-color: #fd7e14; color: white; }
        .badge-gravisima { background-color: #dc3545; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Encabezado -->
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <h2 class="text-primary fw-bold">🔎 Historial del Alumno</h2>
            <a href="index.jsp" class="btn btn-outline-secondary">← Volver al Libro</a>
        </div>

        <!-- BUSCADOR -->
        <div class="card p-4 mb-4 bg-light border-0 shadow-sm">
            <form action="filtros.jsp" method="GET" class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label fw-bold">1. Selecciona el Curso:</label>
                    <select name="cursoSeleccionado" id="curso" class="form-select" onchange="filtrarAlumnos()">
                        <option value="">-- Seleccionar --</option>
                        <% for(CursoDTO c : listaCursos) { 
                            String selected = (cursoSeleccionado != null && cursoSeleccionado.equals(c.getNombreCurso())) ? "selected" : "";
                        %>
                            <option value="<%= c.getNombreCurso() %>" <%= selected %>><%= c.getNombreCurso() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-5">
                    <label class="form-label fw-bold">2. Selecciona el Alumno:</label>
                    <select name="alumnoBusqueda" id="alumno" class="form-select" disabled>
                        <option value="">-- Primero elija curso --</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">Buscar</button>
                </div>
            </form>
        </div>

        <!-- RESULTADOS -->
        <% if(alumnoBusqueda != null && !alumnoBusqueda.isEmpty()) { %>
            
            <div class="d-flex justify-content-between align-items-center">
                <h4 class="mb-0">Historial de: <span class="text-primary fw-bold"><%= alumnoBusqueda %></span></h4>
                <span class="badge bg-secondary"><%= resultados.size() %> Registros</span>
            </div>
            
            <% if(resultados.isEmpty()) { %>
                <div class="alert alert-success text-center p-5 mt-3">
                    <h4>🌟 Hoja de Vida Impecable</h4>
                    <p class="mb-0">Este alumno no registra anotaciones en el sistema.</p>
                </div>
            <% } else { %>
                
                <!-- TABLA RESPONSIVA Y AJUSTADA -->
                <div class="tabla-contenedor">
                    <table class="table table-hover table-bordered mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="col-fecha">Fecha</th>
                                <th class="col-profe">Funcionario</th> <!-- Nombre actualizado -->
                                <th class="col-tipo">Tipo</th>
                                <th class="col-faltas">Faltas Registradas</th>
                                <th class="col-desc">Descripción / Observación</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(AnotacionDTO a : resultados) { 
                                String g = a.getGravedad();
                                String badgeClass = "secondary";
                                if(g != null) {
                                    if(g.contains("Pos")) badgeClass = "badge-positiva";
                                    else if(g.contains("Lev")) badgeClass = "badge-leve";
                                    else if(g.contains("Gra") && !g.contains("sima")) badgeClass = "badge-grave";
                                    else if(g.contains("sima")) badgeClass = "badge-gravisima";
                                }
                            %>
                            <tr>
                                <td><%= a.getFecha().substring(0, 16) %></td>
                                <!-- CORRECCIÓN: getNombreFuncionario() en vez de getProfesor() -->
                                <td>
                                    <%= a.getNombreFuncionario() %><br>
                                    <small class="text-muted"><%= a.getCargoFuncionario() %></small>
                                </td>
                                <td class="text-center"><span class="badge <%= badgeClass %>"><%= a.getGravedad() %></span></td>
                                <td><%= a.getFalta() %></td>
                                <td><%= (a.getDescripcion() != null) ? a.getDescripcion() : "" %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
            <% } %>
        <% } %>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        // Datos traídos desde Java
        const baseDatosAlumnos = <%= jsonAlumnos.toString() %>;
        
        // Variable para mantener seleccionado al alumno después de recargar
        const alumnoPreseleccionado = "<%= (alumnoBusqueda != null) ? alumnoBusqueda : "" %>";

        function filtrarAlumnos() {
            const cursoSeleccionado = document.getElementById('curso').value;
            const selectAlumno = document.getElementById('alumno');
            
            // Limpiar y reiniciar
            selectAlumno.innerHTML = '<option value="">-- Seleccionar Alumno --</option>';
            selectAlumno.disabled = true;

            if(cursoSeleccionado !== "") {
                const alumnosFiltrados = baseDatosAlumnos.filter(a => a.curso === cursoSeleccionado);
                
                alumnosFiltrados.forEach(alum => {
                    const option = document.createElement("option");
                    option.text = alum.nombre;
                    option.value = alum.nombre;
                    // Mantener selección tras buscar
                    if(alum.nombre === alumnoPreseleccionado) {
                        option.selected = true;
                    }
                    selectAlumno.add(option);
                });
                
                selectAlumno.disabled = false;
            }
        }

        // Ejecutar al cargar por si hay búsqueda activa
        window.onload = function() {
            if(document.getElementById('curso').value !== "") {
                filtrarAlumnos();
            }
        };
    </script>
</body>
</html>