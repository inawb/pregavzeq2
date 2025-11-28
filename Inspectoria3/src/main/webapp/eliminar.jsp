<%@page import="dao.AnotacionDAO"%>
<%@page import="servicios.FactoriaServiciosImpl"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    FactoriaServiciosImpl.getFactoria().setMotor("mysql");
    AnotacionDAO dao = new AnotacionDAO();
    if(dao.eliminar(Integer.parseInt(request.getParameter("id")))) out.print("exito"); else out.print("error");
%>