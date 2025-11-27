<%@page import="dao.AnotacionDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    // VALIDACIÓN Y GUARDADO DE DATOS
    
    // 1. Asegurar codificación correcta de caracteres
    request.setCharacterEncoding("UTF-8");
    
    // 2. Asegurar motor MySQL
    FactoriaServiciosImpl.getFactoria().setMotor("mysql");
    
    // 3. Obtener parámetros del POST
    String profesor = request.getParameter("profesor");
    String curso = request.getParameter("curso");
    String alumno = request.getParameter("alumno");
    String gravedad = request.getParameter("gravedad");
    String falta = request.getParameter("falta");
    String descripcion = request.getParameter("descripcion");

    // 4. Validación básica en servidor (por seguridad extra)
    if(profesor == null || curso == null || alumno == null || falta == null) {
        out.print("error: datos incompletos");
        return;
    }

    // 5. Llamar al DAO para guardar
    AnotacionDAO dao = new AnotacionDAO();
    boolean guardado = dao.guardar(profesor, curso, alumno, gravedad, falta, descripcion);
    
    // 6. Responder al frontend
    if(guardado) {
        out.print("exito");
    } else {
        out.print("error al insertar en BD");
    }
%>