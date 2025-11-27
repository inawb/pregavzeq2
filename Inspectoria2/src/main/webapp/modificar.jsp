<%@page import="dao.AnotacionDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    FactoriaServiciosImpl.getFactoria().setMotor("mysql");
    
    int id = Integer.parseInt(request.getParameter("id")); // ID para saber a quién modificar
    String prof = request.getParameter("profesor");
    String cur = request.getParameter("curso");
    String alum = request.getParameter("alumno");
    String grav = request.getParameter("gravedad");
    String fal = request.getParameter("falta");
    String desc = request.getParameter("descripcion");

    AnotacionDAO dao = new AnotacionDAO();
    if(dao.modificar(id, prof, cur, alum, grav, fal, desc)) {
        out.print("exito");
    } else {
        out.print("error");
    }
%>