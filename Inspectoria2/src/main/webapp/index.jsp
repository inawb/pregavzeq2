<%@page import="dto.AnotacionDTO"%>
<%@page import="dao.AnotacionDAO"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="dto.CursoDTO"%>
<%@page import="dao.CursoDAO"%>
<%@page import="dto.AlumnoDTO"%>
<%@page import="dao.AlumnoDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- CARGA DE DATOS INICIALES ---
    // 1. Configurar motor
    try { FactoriaServiciosImpl.getFactoria().setMotor("mysql"); } catch(Exception e){}

    // 2. Cargar Cursos
    CursoDAO cursoDao = new CursoDAO();
    List<CursoDTO> listaCursos = new ArrayList<>();
    try { listaCursos = cursoDao.listarCursos(); } catch(Exception e) {}

    // 3. Cargar Alumnos y preparar JSON para el filtro
    AlumnoDAO alumnoDao = new AlumnoDAO();
    StringBuilder jsonAlumnos = new StringBuilder("[");
    try {
        ArrayList<AlumnoDTO> todos = alumnoDao.read();
        boolean f = true;
        for(AlumnoDTO a : todos) {
            if(!f) jsonAlumnos.append(",");
            String nombre = a.getNombreAlumno() + " " + a.getApellidoPAlumno();
            jsonAlumnos.append("{nombre:\"").append(nombre).append("\", curso:\"").append(a.getCurso()).append("\"}");
            f = false;
        }
    } catch(Exception e) {}
    jsonAlumnos.append("]");

    // 4. Cargar Profesores
    List<String> listaProfesores = new ArrayList<>();
    try {
        Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
        ResultSet rs = con.createStatement().executeQuery("SELECT nombre FROM profesores_lista");
        while(rs.next()) listaProfesores.add(rs.getString("nombre"));
    } catch(Exception e) {}

    // 5. CARGAR LAS ANOTACIONES GUARDADAS (Aquí es donde aparecen los datos)
    AnotacionDAO anotacionDao = new AnotacionDAO();
    List<AnotacionDTO> listaAnotaciones = anotacionDao.listar();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Sistema Escolar</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; box-shadow: 0 0 15px rgba(0,0,0,0.1); border-radius: 8px; }
        .input-group { display: grid; grid-template-columns: 1fr 1fr 1fr 0.8fr 1fr 2fr 0.5fr; gap: 10px; background: #e9ecef; padding: 15px; border-radius: 8px; border-bottom: 2px solid #dee2e6; margin-bottom: 20px;}
        input, select { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; height: 38px; box-sizing: border-box; }
        
        /* Botones */
        button { border: none; cursor: pointer; border-radius: 4px; font-weight: bold; height: 38px; transition: 0.3s; }
        .btn-guardar { background: #28a745; color: white; width: 100%; }
        .btn-guardar:hover { background: #218838; }
        .btn-cancelar { background: #dc3545; color: white; width: 100%; display: none; } /* Oculto por defecto */
        
        /* Botones de la tabla */
        .btn-editar { background: #ffc107; color: #333; padding: 5px 10px; height: auto; font-size: 0.9em; margin-right: 5px;}
        .btn-eliminar { background: #dc3545; color: white; padding: 5px 10px; height: auto; font-size: 0.9em;}

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background: #343a40; color: white; }
        .badge { padding: 5px 10px; border-radius: 12px; color: white; font-weight: bold; font-size: 0.85em; }
        .leve { background: #ffc107; color: #333; }
        .grave { background: #fd7e14; }
        .gravisima { background: #dc3545; }
    </style>
</head>
<body>

    <div class="container">
        <h2 style="text-align: center; color: #2c3e50;">Libro de Anotaciones</h2>

        <!-- CAMPO OCULTO PARA EL ID (Si tiene valor, estamos editando) -->
        <input type="hidden" id="idEditar" value="">

        <div class="input-group">
            <select id="profesor">
                <option value="">-- Profesor --</option>
                <% for(String p : listaProfesores) { %><option value="<%= p %>"><%= p %></option><% } %>
            </select>

            <select id="curso" onchange="filtrarAlumnos()">
                <option value="">-- Curso --</option>
                <% for(CursoDTO c : listaCursos) { %><option value="<%= c.getNombreCurso() %>"><%= c.getNombreCurso() %></option><% } %>
            </select>

            <select id="alumno" disabled><option value="">-- Alumno --</option></select>

            <select id="gravedad">
                <option value="Leve">Leve</option><option value="Grave">Grave</option><option value="Gravísima">Gravísima</option>
            </select>

            <input type="text" id="falta" placeholder="Falta">
            <input type="text" id="descripcion" placeholder="Descripción...">
            
            <div style="display: flex; gap: 5px;">
                <button type="button" class="btn-guardar" id="btnAccion" onclick="procesarFormulario()">Guardar</button>
                <button type="button" class="btn-cancelar" id="btnCancelar" onclick="cancelarEdicion()">✖</button>
            </div>
        </div>

        <!-- TABLA DE RESULTADOS -->
        <table>
            <thead>
                <tr>
                    <th>Fecha</th><th>Profesor</th><th>Curso</th><th>Alumno</th><th>Gravedad</th><th>Falta</th><th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for(AnotacionDTO a : listaAnotaciones) { 
                    String color = "gravisima";
                    if(a.getGravedad() != null) {
                        if(a.getGravedad().equals("Leve")) color = "leve";
                        else if(a.getGravedad().equals("Grave")) color = "grave";
                    }
                %>
                <tr>
                    <td><%= a.getFecha() %></td>
                    <td><%= a.getProfesor() %></td>
                    <td><%= a.getCurso() %></td>
                    <td><%= a.getAlumno() %></td>
                    <td><span class="badge <%= color %>"><%= a.getGravedad() %></span></td>
                    <td><%= a.getFalta() %></td>
                    <td>
                        <!-- AQUÍ ESTÁN LOS BOTONES QUE TE FALTAN -->
                        <button class="btn-editar" onclick="cargarParaEditar(<%= a.getId() %>, '<%= a.getProfesor() %>', '<%= a.getCurso() %>', '<%= a.getAlumno() %>', '<%= a.getGravedad() %>', '<%= a.getFalta() %>', '<%= a.getDescripcion() %>')">✏️</button>
                        <button class="btn-eliminar" onclick="eliminarAnotacion(<%= a.getId() %>)">🗑️</button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script>
        const baseDatosAlumnos = <%= jsonAlumnos.toString() %>;

        // 1. FILTRO DE ALUMNOS
        function filtrarAlumnos(alumnoPreseleccionado = null) {
            const curso = document.getElementById('curso').value;
            const select = document.getElementById('alumno');
            select.innerHTML = '<option value="">-- Alumno --</option>';
            
            if(curso === "") { select.disabled = true; return; }

            baseDatosAlumnos.filter(a => a.curso === curso).forEach(a => {
                const opt = document.createElement("option");
                opt.text = a.nombre; opt.value = a.nombre;
                select.add(opt);
            });
            select.disabled = false;
            
            // Si estamos editando, volver a seleccionar al alumno original
            if(alumnoPreseleccionado) select.value = alumnoPreseleccionado;
        }

        // 2. PROCESAR FORMULARIO (GUARDAR O MODIFICAR)
        async function procesarFormulario() {
            const id = document.getElementById('idEditar').value;
            // Decide si llamamos a modificar.jsp o guardar.jsp
            const url = id ? 'modificar.jsp' : 'guardar.jsp'; 
            
            const params = new URLSearchParams();
            if(id) params.append('id', id);
            
            params.append('profesor', document.getElementById('profesor').value);
            params.append('curso', document.getElementById('curso').value);
            params.append('alumno', document.getElementById('alumno').value);
            params.append('gravedad', document.getElementById('gravedad').value);
            params.append('falta', document.getElementById('falta').value);
            params.append('descripcion', document.getElementById('descripcion').value);

            if(!params.get('profesor') || !params.get('curso') || !params.get('alumno') || !params.get('falta')) {
                alert("Faltan datos obligatorios"); return;
            }

            try {
                const res = await fetch(url, { method: 'POST', body: params });
                const txt = await res.text();
                if(txt.trim() === 'exito') {
                    alert(id ? "¡Anotación Modificada!" : "¡Anotación Guardada!");
                    location.reload(); 
                } else alert("Error en el servidor: " + txt);
            } catch(e) { alert("Error de conexión"); }
        }

        // 3. CARGAR DATOS EN EL FORMULARIO (MODO EDICIÓN)
        function cargarParaEditar(id, prof, cur, alum, grav, fal, desc) {
            document.getElementById('idEditar').value = id;
            document.getElementById('profesor').value = prof;
            document.getElementById('curso').value = cur;
            
            // Cargar alumnos del curso y seleccionar al correcto
            filtrarAlumnos(alum);
            
            document.getElementById('gravedad').value = grav;
            document.getElementById('falta').value = fal;
            document.getElementById('descripcion').value = desc;

            // Cambiar aspecto botones
            const btn = document.getElementById('btnAccion');
            btn.innerText = "Modificar";
            btn.style.background = "#ffc107";
            btn.style.color = "#333";
            document.getElementById('btnCancelar').style.display = "block";
            
            window.scrollTo(0,0);
        }

        function cancelarEdicion() {
            document.getElementById('idEditar').value = "";
            document.getElementById('falta').value = "";
            document.getElementById('descripcion').value = "";
            document.getElementById('curso').value = "";
            filtrarAlumnos(); 
            
            const btn = document.getElementById('btnAccion');
            btn.innerText = "Guardar";
            btn.style.background = "#28a745";
            btn.style.color = "white";
            document.getElementById('btnCancelar').style.display = "none";
        }

        // 4. ELIMINAR
        async function eliminarAnotacion(id) {
            if(!confirm("¿Seguro que deseas eliminar esta anotación?")) return;

            const params = new URLSearchParams();
            params.append('id', id);

            try {
                const res = await fetch('eliminar.jsp', { method: 'POST', body: params });
                if((await res.text()).trim() === 'exito') {
                    location.reload();
                } else alert("Error al eliminar");
            } catch(e) { alert("Error conexión"); }
        }
    </script>
</body>
</html>