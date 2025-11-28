<%@page import="java.sql.*"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    // 1. Obtener datos enviados desde el Javascript
    String nombre = request.getParameter("nombre");
    String tipo = request.getParameter("tipo"); // "profesor" o "alumno"
    
    boolean existe = false;
    
    // 2. Conectar a la Base de Datos
    try {
        Class.forName("com.mysql.jdbc.Driver");
        // CAMBIA "root" y "" por tu usuario y contraseña de MySQL
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/escuela_db", "root", "");
        
        String sql = "";
        if(tipo.equals("profesor")) {
            sql = "SELECT count(*) FROM profesores WHERE nombre = ?";
        } else {
            sql = "SELECT count(*) FROM alumnos WHERE nombre = ?";
        }
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, nombre);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            // Si el conteo es mayor a 0, significa que existe
            if(rs.getInt(1) > 0) {
                existe = true;
            }
        }
        con.close();
    } catch (Exception e) {
        out.print("error: " + e.getMessage());
        return;
    }

    // 3. Responder al Javascript
    if(existe) {
        out.print("ok");
    } else {
        out.print("no_existe");
    }
%>