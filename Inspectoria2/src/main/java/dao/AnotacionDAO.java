package dao;

import dto.AnotacionDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import servicios.FactoriaServiciosImpl;

public class AnotacionDAO {

    // 1. LISTAR (Para mostrar todas las anotaciones en la tabla)
    public List<AnotacionDTO> listar() {
        List<AnotacionDTO> lista = new ArrayList<>();
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "SELECT * FROM anotaciones ORDER BY fecha DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                AnotacionDTO a = new AnotacionDTO();
                a.setId(rs.getInt("id"));
                a.setFecha(rs.getString("fecha"));
                a.setProfesor(rs.getString("profesor"));
                a.setCurso(rs.getString("curso"));
                a.setAlumno(rs.getString("alumno"));
                a.setGravedad(rs.getString("gravedad"));
                a.setFalta(rs.getString("falta"));
                a.setDescripcion(rs.getString("descripcion"));
                lista.add(a);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return lista;
    }

    // 2. GUARDAR (Crear una nueva anotación)
    public boolean guardar(String prof, String cur, String alum, String grav, String fal, String desc) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "INSERT INTO anotaciones (profesor, curso, alumno, gravedad, falta, descripcion) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, prof);
            ps.setString(2, cur);
            ps.setString(3, alum);
            ps.setString(4, grav);
            ps.setString(5, fal);
            ps.setString(6, desc);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. MODIFICAR (Actualizar una anotación existente por su ID)
    public boolean modificar(int id, String prof, String cur, String alum, String grav, String fal, String desc) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "UPDATE anotaciones SET profesor=?, curso=?, alumno=?, gravedad=?, falta=?, descripcion=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, prof);
            ps.setString(2, cur);
            ps.setString(3, alum);
            ps.setString(4, grav);
            ps.setString(5, fal);
            ps.setString(6, desc);
            ps.setInt(7, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. ELIMINAR (Borrar una anotación por su ID)
    public boolean eliminar(int id) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "DELETE FROM anotaciones WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}