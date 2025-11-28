<%@page import="dao.AnotacionDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    FactoriaServiciosImpl.getFactoria().setMotor("mysql");
    AnotacionDAO dao = new AnotacionDAO();
    if(dao.modificar(
        Integer.parseInt(request.getParameter("id")),
        request.getParameter("nombreFunc"),
        request.getParameter("cargoFunc"),
        request.getParameter("curso"),
        request.getParameter("alumno"),
        request.getParameter("gravedad"),
        request.getParameter("falta"),
        request.getParameter("descripcion")
    )) out.print("exito"); else out.print("error");
%>