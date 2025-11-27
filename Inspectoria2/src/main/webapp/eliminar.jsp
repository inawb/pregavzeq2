<%@page import="dao.AnotacionDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    FactoriaServiciosImpl.getFactoria().setMotor("mysql");
    
    int id = Integer.parseInt(request.getParameter("id"));

    AnotacionDAO dao = new AnotacionDAO();
    if(dao.eliminar(id)) {
        out.print("exito");
    } else {
        out.print("error");
    }
%>