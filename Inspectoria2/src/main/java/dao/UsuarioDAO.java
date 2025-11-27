package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import modelo.Usuario;
import servicios.FactoriaServiciosImpl;

public class UsuarioDAO implements iCrud {
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;
    
    public Usuario hacerLogin(String usuario, String password) throws Exception {
        Usuario u = null;
        conn = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
        String sql = "select * from user where usuario='"+usuario+"' and pass ='"+password+"'";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        if(rs.next()){
           u = new Usuario();
           u.setId(rs.getInt("id"));
           u.setUsuario(rs.getString("usuario"));
           u.setPass(rs.getString("pass"));
           u.setRol(rs.getString("rol"));
           return u;
        }
        return null;
    }

    @Override
    public int create(Object t) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList read() throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Object read(int id) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int update(Object t) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int delete(int id) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}