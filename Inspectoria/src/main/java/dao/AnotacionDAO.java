package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import servicios.FactoriaServiciosImpl;

// ESTE ES NECESARIO PARA GUARDAR LOS DATOS DEL FORMULARIO
public class AnotacionDAO implements iCrud{
    public boolean guardar(String prof, String cur, String alum, String grav, String fal, String desc) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "INSERT INTO anotaciones (profesor, curso, alumno, gravedad, falta, descripcion) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, prof); ps.setString(2, cur); ps.setString(3, alum);
            ps.setString(4, grav); ps.setString(5, fal); ps.setString(6, desc);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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