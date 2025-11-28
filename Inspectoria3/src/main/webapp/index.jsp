<%@page import="dto.FuncionarioDTO"%>
<%@page import="dao.FuncionarioDAO"%>
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
    // --- LÓGICA DE CARGA ---
    try { FactoriaServiciosImpl.getFactoria().setMotor("mysql"); } catch(Exception e){}

    // 1. Cursos
    CursoDAO cursoDao = new CursoDAO();
    List<CursoDTO> listaCursos = new ArrayList<>();
    try { listaCursos = cursoDao.listarCursos(); } catch(Exception e) {}

    // 2. Alumnos
    AlumnoDAO alumnoDao = new AlumnoDAO();
    StringBuilder jsonAlumnos = new StringBuilder("[");
    try {
        ArrayList<AlumnoDTO> todos = alumnoDao.read();
        boolean f = true;
        for(AlumnoDTO a : todos) {
            if(!f) jsonAlumnos.append(",");
            // CORRECCIÓN: Usamos getNombreCompleto()
            String nombre = a.getNombreCompleto().replace("'", "\\'"); 
            jsonAlumnos.append("{nombre:\"").append(nombre).append("\", curso:\"").append(a.getCurso()).append("\"}");
            f = false;
        }
    } catch(Exception e) {}
    jsonAlumnos.append("]");

    // 3. FUNCIONARIOS
    FuncionarioDAO funcionarioDao = new FuncionarioDAO();
    List<FuncionarioDTO> listaFuncionarios = new ArrayList<>();
    try { listaFuncionarios = funcionarioDao.listar(); } catch(Exception e) {}

    // 4. Anotaciones
    AnotacionDAO anotacionDao = new AnotacionDAO();
    List<AnotacionDTO> listaAnotaciones = anotacionDao.listar();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sistema de Inspectoría</title>
    <link href="css/bootstrap.min.css" rel="stylesheet"> 
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; padding: 20px; }
        .container { max-width: 1200px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        /* Checkboxes */
        .checkbox-container { height: 400px; border: 1px solid #ced4da; border-radius: 4px; padding: 10px; overflow-y: auto; background-color: white; }
        .grupo-titulo { font-weight: bold; padding: 5px 10px; margin-top: 10px; border-radius: 4px; font-size: 0.9em; text-transform: uppercase; letter-spacing: 0.5px; }
        .grupo-positivo { background-color: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .grupo-leve { background-color: #fff3cd; color: #856404; border-left: 4px solid #ffc107; }
        .grupo-grave { background-color: #ffe8cc; color: #fd7e14; border-left: 4px solid #fd7e14; }
        .grupo-gravisima { background-color: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        .form-check { margin-bottom: 3px; margin-left: 10px; font-size: 0.9em; }

        /* Badges */
        .badge-positiva { background-color: #28a745; color: white; }
        .badge-leve { background-color: #ffc107; color: #212529; }
        .badge-grave { background-color: #fd7e14; color: white; }
        .badge-gravisima { background-color: #dc3545; color: white; }

        /* Tabla */
        .tabla-contenedor { overflow-x: auto; border-radius: 4px; }
        table { table-layout: fixed; width: 100%; }
        td { word-wrap: break-word; overflow-wrap: break-word; white-space: normal; vertical-align: middle; }
        .col-fecha { width: 15%; font-size: 0.85em; }
        .col-profe { width: 20%; font-size: 0.9em; font-weight: bold; color: #555; }
        .col-alumno { width: 25%; font-weight: bold; }
        .col-curso { width: 10%; text-align: center; }
        .col-tipo { width: 15%; text-align: center; }
        .col-acciones { width: 15%; text-align: center; }

        /* Modal */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-contenido { background: white; padding: 25px; border-radius: 8px; width: 90%; max-width: 600px; max-height: 90vh; overflow-y: auto; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .modal-header { border-bottom: 1px solid #dee2e6; margin-bottom: 15px; padding-bottom: 10px; display: flex; justify-content: space-between; align-items: center; }
        .modal-title { font-size: 1.25rem; font-weight: bold; color: #2c3e50; margin: 0; }
        .btn-cerrar-modal { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #6c757d; }
        .info-label { font-weight: bold; color: #555; display: block; margin-bottom: 2px; }
        .caja-texto-largo { background: #f8f9fa; padding: 10px; border: 1px solid #dee2e6; margin-top: 5px; word-wrap: break-word; font-style: italic; border-radius: 4px; }
    </style>
</head>
<body>

    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold">Libro de Anotaciones</h2>
            <div>
                <a href="filtros.jsp" class="btn btn-primary me-2">🔍 Ver Historial Completo</a>
                <button onclick="location.reload()" class="btn btn-outline-secondary">Actualizar</button>
            </div>
        </div>

        <input type="hidden" id="idEditar" value="">

        <div class="row mb-4 p-3 bg-light rounded border">
            <div class="col-md-4">
                <div class="mb-3">
                    <label>Funcionario (Quién registra):</label>
                    <select id="profesor" class="form-control">
                        <option value="">-- Seleccionar --</option>
                        <% for(FuncionarioDTO f : listaFuncionarios) { %>
                            <option value="<%= f.getNombre() %>|<%= f.getCargo() %>"><%= f.getEtiqueta() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Curso:</label>
                    <select id="curso" class="form-control" onchange="filtrarAlumnos()">
                        <option value="">-- Seleccionar --</option>
                        <% for(CursoDTO c : listaCursos) { %><option value="<%= c.getNombreCurso() %>"><%= c.getNombreCurso() %></option><% } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Alumno:</label>
                    <select id="alumno" class="form-control" disabled><option value="">-- Primero elija curso --</option></select>
                </div>
                <div>
                    <label>Observación Adicional:</label>
                    <textarea id="descripcion" class="form-control" rows="4" placeholder="Detalles extra..." maxlength="500" oninput="actualizarContador()"></textarea>
                    <div class="text-end"><small class="text-muted" id="contadorDesc">0/500</small></div>
                </div>
            </div>

            <div class="col-md-8">
                <label>Seleccione el tipo de anotación (Puede marcar varias):</label>
                
                <div class="checkbox-container">
                    
                    <!-- POSITIVA -->
                    <div class="grupo-titulo grupo-positivo">ANOTACIÓN POSITIVA</div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Comportamiento Destacado" data-tipo="Positiva" id="chk_pos"><label class="form-check-label" for="chk_pos">Comportamiento Destacado / Sin Falta</label></div>

                    <!-- FALTAS LEVES -->
                    <div class="grupo-titulo grupo-leve">FALTAS LEVES</div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Manifestaciones afectivas exageradas" data-tipo="Leve"><label class="form-check-label">Manifestaciones afectivas exageradas</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="No portar Agenda Oficial o usarla incorrectamente" data-tipo="Leve"><label class="form-check-label">No portar Agenda Oficial o usarla incorrectamente</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Atrasos en la jornada" data-tipo="Leve"><label class="form-check-label">Atrasos en la jornada</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Permanecer en espacios no autorizados" data-tipo="Leve"><label class="form-check-label">Permanecer en espacios no autorizados</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Ventas no autorizadas" data-tipo="Leve"><label class="form-check-label">Ventas no autorizadas</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="No asistir a actividades comprometidas sin justificación" data-tipo="Leve"><label class="form-check-label">No asistir a actividades comprometidas sin justificación</label></div>

                    <!-- FALTAS GRAVES -->
                    <div class="grupo-titulo grupo-grave">FALTAS GRAVES</div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Eludir clases o retirarse sin autorización" data-tipo="Grave"><label class="form-check-label">Eludir clases o retirarse sin autorización</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Abandonar el colegio sin autorización o con engaño" data-tipo="Grave"><label class="form-check-label">Abandonar el colegio sin autorización o con engaño</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Copiar, recibir o dar ayuda en evaluaciones" data-tipo="Grave"><label class="form-check-label">Copiar, recibir o dar ayuda en evaluaciones</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Faltar a la verdad" data-tipo="Grave"><label class="form-check-label">Faltar a la verdad</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Copia no autorizada o sustracción de documentos o materiales" data-tipo="Grave"><label class="form-check-label">Copia no autorizada o sustracción de documentos o materiales</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Suplantar a personal o apoderados" data-tipo="Grave"><label class="form-check-label">Suplantar a personal o apoderados</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Fotografiar o grabar a integrantes de la comunidad sin permiso" data-tipo="Grave"><label class="form-check-label">Fotografiar o grabar a integrantes de la comunidad sin permiso</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Reiteración de faltas leves" data-tipo="Grave"><label class="form-check-label">Reiteración de faltas leves</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Reiteración de faltas tecnológicas menos graves" data-tipo="Grave"><label class="form-check-label">Reiteración de faltas tecnológicas menos graves</label></div>

                    <!-- FALTAS GRAVÍSIMAS -->
                    <div class="grupo-titulo grupo-gravisima">FALTAS GRAVÍSIMAS</div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Acumular una o más hojas de anotaciones negativas" data-tipo="Gravísima"><label class="form-check-label">Acumular una o más hojas de anotaciones negativas</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Discriminación a un integrante de la comunidad educativa" data-tipo="Gravísima"><label class="form-check-label">Discriminación a un integrante de la comunidad educativa</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Uso del celular en horario de clases (según protocolo)" data-tipo="Gravísima"><label class="form-check-label">Uso del celular en horario de clases (según protocolo)</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Agresión física, verbal o psicológica" data-tipo="Gravísima"><label class="form-check-label">Agresión física, verbal o psicológica</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Subir contenido multimedia a redes sociales sin consentimiento" data-tipo="Gravísima"><label class="form-check-label">Subir contenido multimedia a redes sociales sin consentimiento</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Rendir evaluaciones utilizando celular" data-tipo="Gravísima"><label class="form-check-label">Rendir evaluaciones utilizando celular</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Portar, descargar o compartir contenido sexual" data-tipo="Gravísima"><label class="form-check-label">Portar, descargar o compartir contenido sexual</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Grabar a un integrante sin consentimiento" data-tipo="Gravísima"><label class="form-check-label">Grabar a un integrante sin consentimiento</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Grooming, cyberbullying o vulneración de privacidad" data-tipo="Gravísima"><label class="form-check-label">Grooming, cyberbullying o vulneración de privacidad</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Hostigamiento digital reiterado" data-tipo="Gravísima"><label class="form-check-label">Hostigamiento digital reiterado</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Falsificación o manipulación de información digital del colegio" data-tipo="Gravísima"><label class="form-check-label">Falsificación o manipulación de información digital del colegio</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Ataques informáticos al establecimiento" data-tipo="Gravísima"><label class="form-check-label">Ataques informáticos al establecimiento</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Desacato a la autoridad" data-tipo="Gravísima"><label class="form-check-label">Desacato a la autoridad</label></div>
                    <div class="form-check"><input class="form-check-input falta-check" type="checkbox" value="Reiteración de faltas graves" data-tipo="Gravísima"><label class="form-check-label">Reiteración de faltas graves</label></div>
                </div>
                
                <div class="mt-3 text-end">
                    <button type="button" class="btn btn-secondary me-2" id="btnCancelar" onclick="cancelarEdicion()" style="display:none;">Cancelar Edición</button>
                    <button type="button" class="btn btn-success" id="btnAccion" onclick="procesarFormulario()">Guardar Anotación</button>
                </div>
            </div>
        </div>

        <div class="tabla-contenedor">
            <table class="table table-hover table-bordered table-sm align-middle">
                <thead class="table-dark">
                    <tr>
                        <th class="col-fecha">Fecha</th>
                        <th class="col-profe">Funcionario</th>
                        <th class="col-alumno">Alumno</th>
                        <th class="col-curso">Curso</th>
                        <th class="col-tipo">Tipo</th>
                        <th class="col-acciones">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(AnotacionDTO a : listaAnotaciones) { 
                        String g = a.getGravedad();
                        String badge = "secondary";
                        if(g!=null){ 
                            if(g.contains("Pos")) badge="success"; 
                            else if(g.contains("Lev")) badge="warning text-dark"; 
                            else if(g.contains("Gra") && !g.contains("sima")) badge="danger"; // Grave
                            else if(g.contains("sima")) badge="danger"; // Gravísima
                        }
                        
                        String mProf = a.getNombreFuncionario().replace("'", "\\'");
                        String mCargo = a.getCargoFuncionario().replace("'", "\\'");
                        String mAlum = a.getAlumno().replace("'", "\\'");
                        String mDesc = (a.getDescripcion()!=null) ? a.getDescripcion().replace("'", "\\'").replace("\n", " ") : "";
                        String mFalta = a.getFalta().replace("'", "\\'");
                    %>
                    <tr>
                        <td><%= a.getFecha().substring(0, 16) %></td>
                        <td><%= a.getNombreFuncionario() %><br><small class="text-muted"><%= a.getCargoFuncionario() %></small></td>
                        <td><%= a.getAlumno() %></td>
                        <td class="text-center"><%= a.getCurso() %></td>
                        <td class="text-center"><span class="badge bg-<%= badge %>"><%= a.getGravedad() %></span></td>
                        <td class="text-center">
                            <button class="btn btn-info btn-sm text-white" onclick="verDetalle('<%= a.getFecha() %>', '<%= mProf %>', '<%= mCargo %>', '<%= mAlum %>', '<%= a.getCurso() %>', '<%= a.getGravedad() %>', '<%= mFalta %>', '<%= mDesc %>')">👁</button>
                            <button class="btn btn-warning btn-sm" onclick="cargarParaEditar(<%= a.getId() %>, '<%= mProf %>|<%= mCargo %>', '<%= a.getCurso() %>', '<%= mAlum %>', '<%= mFalta %>', '<%= mDesc %>')">✏</button>
                            <button class="btn btn-danger btn-sm" onclick="eliminarAnotacion(<%= a.getId() %>)">🗑</button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- MODAL -->
    <div id="miModal" class="modal-overlay">
        <div class="modal-contenido">
            <div class="modal-header"><h3 class="modal-title">Detalles</h3><button class="btn-cerrar-modal" onclick="cerrarModal()">×</button></div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-6 mb-2"><span class="info-label">Fecha:</span> <span id="mFecha"></span></div>
                    <div class="col-6 mb-2"><span class="info-label">Gravedad:</span> <span id="mGravedad" class="badge"></span></div>
                    <div class="col-12 mb-2"><span class="info-label">Funcionario:</span> <span id="mProfesor"></span> <small id="mCargo" class="text-muted"></small></div>
                    <div class="col-6 mb-2"><span class="info-label">Curso:</span> <span id="mCurso"></span></div>
                    <div class="col-12 mb-3"><span class="info-label">Alumno:</span> <span id="mAlumno" class="fw-bold"></span></div>
                    <div class="col-12 mb-3"><span class="info-label">Faltas Registradas:</span> <div id="mFaltas" class="caja-texto-largo"></div></div>
                    <div class="col-12"><span class="info-label">Observación:</span> <div id="mDesc" class="caja-texto-largo"></div></div>
                </div>
            </div>
            <div class="mt-4 text-end border-top pt-3"><button class="btn btn-secondary" onclick="cerrarModal()">Cerrar</button></div>
        </div>
    </div>

    <script>
        const baseDatosAlumnos = <%= jsonAlumnos.toString() %>;

        function actualizarContador() {
            document.getElementById('contadorDesc').innerText = document.getElementById('descripcion').value.length + "/500";
        }

        function verDetalle(fecha, prof, cargo, alum, curso, grav, faltas, desc) {
            document.getElementById('mFecha').innerText = fecha;
            document.getElementById('mProfesor').innerText = prof;
            document.getElementById('mCargo').innerText = "(" + cargo + ")";
            document.getElementById('mAlumno').innerText = alum;
            document.getElementById('mCurso').innerText = curso;
            document.getElementById('mFaltas').innerText = faltas;
            document.getElementById('mDesc').innerText = desc || "Sin observación.";
            
            const badge = document.getElementById('mGravedad');
            badge.innerText = grav;
            badge.className = 'badge bg-secondary';
            if(grav.includes("Pos")) badge.className = 'badge bg-success';
            else if(grav.includes("Lev")) badge.className = 'badge bg-warning text-dark';
            else if(grav.includes("Gra") && !grav.includes("vi")) badge.className = 'badge bg-danger';
            else badge.className = 'badge bg-danger';

            document.getElementById('miModal').style.display = 'flex';
        }

        function cerrarModal() { document.getElementById('miModal').style.display = 'none'; }
        window.onclick = function(event) { if (event.target == document.getElementById('miModal')) cerrarModal(); }

        function filtrarAlumnos(pre = null) {
            const cur = document.getElementById('curso').value;
            const sel = document.getElementById('alumno');
            sel.innerHTML = '<option value="">-- Alumno --</option>';
            sel.disabled = true;
            if(cur !== "") {
                baseDatosAlumnos.filter(a => a.curso === cur).forEach(a => {
                    let opt = document.createElement("option"); opt.value = a.nombre; opt.text = a.nombre; sel.add(opt);
                });
                sel.disabled = false;
                if(pre) sel.value = pre;
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll('.falta-check').forEach(chk => {
                chk.addEventListener('change', function() {
                    const esPos = this.getAttribute('data-tipo') === 'Positiva';
                    if (this.checked) {
                        document.querySelectorAll('.falta-check').forEach(c => {
                            if (esPos ? c.getAttribute('data-tipo')!=='Positiva' : c.getAttribute('data-tipo')==='Positiva') c.checked = false;
                        });
                    }
                });
            });
        });

        async function procesarFormulario() {
            const profData = document.getElementById('profesor').value; 
            const cur = document.getElementById('curso').value;
            const alum = document.getElementById('alumno').value;
            const desc = document.getElementById('descripcion').value;
            
            if(!profData || !cur || !alum) { alert("Faltan datos básicos (Funcionario, Curso o Alumno)"); return; }
            
            const [nombreFunc, cargoFunc] = profData.split("|");

            const checks = document.querySelectorAll('.falta-check:checked');
            if(checks.length === 0) { alert("⚠ Seleccione al menos una falta."); return; }

            let lista = [], grav = "Positiva";
            const prio = { "Positiva":0, "Leve":1, "Grave":2, "Gravísima":3 };

            checks.forEach(c => {
                lista.push(c.value);
                let t = c.getAttribute('data-tipo');
                if(prio[t] > prio[grav]) grav = t;
            });

            const id = document.getElementById('idEditar').value;
            const params = new URLSearchParams();
            if(id) params.append('id', id);
            
            params.append('nombreFunc', nombreFunc); 
            params.append('cargoFunc', cargoFunc);
            params.append('curso', cur); 
            params.append('alumno', alum);
            params.append('gravedad', grav); 
            params.append('falta', lista.join(", ")); 
            params.append('descripcion', desc);

            try {
                const res = await fetch(id ? 'modificar.jsp' : 'guardar.jsp', { method: 'POST', body: params });
                const txt = await res.text();
                if(txt.trim() === 'exito') { alert("Operación exitosa"); location.reload(); }
                else alert("Error en servidor: " + txt);
            } catch(e) { alert("Error conexión"); }
        }

        function cargarParaEditar(id, profFull, cur, alum, faltas, desc) {
            document.getElementById('idEditar').value = id;
            document.getElementById('profesor').value = profFull;
            document.getElementById('curso').value = cur;
            filtrarAlumnos(alum);
            document.getElementById('descripcion').value = desc;
            actualizarContador();
            
            document.querySelectorAll('.falta-check').forEach(chk => {
                chk.checked = faltas.includes(chk.value);
            });

            const btn = document.getElementById('btnAccion');
            btn.className = "btn btn-warning";
            btn.innerText = "Modificar Anotación";
            document.getElementById('btnCancelar').style.display = "inline-block";
            window.scrollTo(0,0);
        }

        function cancelarEdicion() { location.reload(); }

        async function eliminarAnotacion(id) {
            if(confirm("¿Eliminar registro?")) {
                const res = await fetch('eliminar.jsp?id='+id, { method: 'POST' });
                if((await res.text()).trim() === 'exito') location.reload();
            }
        }
    </script>
</body>
</html>