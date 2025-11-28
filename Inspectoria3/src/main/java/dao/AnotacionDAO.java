package dao;

import dto.AnotacionDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import servicios.FactoriaServiciosImpl;

public class AnotacionDAO {

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
                a.setNombreFuncionario(rs.getString("nombre_funcionario"));
                a.setCargoFuncionario(rs.getString("cargo_funcionario"));
                a.setCurso(rs.getString("curso"));
                a.setAlumno(rs.getString("alumno"));
                a.setGravedad(rs.getString("gravedad"));
                a.setFalta(rs.getString("falta"));
                a.setDescripcion(rs.getString("descripcion"));
                lista.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // Ahora guardamos nombre y cargo del funcionario
    public boolean guardar(String nombreFunc, String cargoFunc, String cur, String alum, String grav, String fal, String desc) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "INSERT INTO anotaciones (nombre_funcionario, cargo_funcionario, curso, alumno, gravedad, falta, descripcion) VALUES (?,?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombreFunc);
            ps.setString(2, cargoFunc);
            ps.setString(3, cur);
            ps.setString(4, alum);
            ps.setString(5, grav);
            ps.setString(6, fal);
            ps.setString(7, desc);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { return false; }
    }

    public boolean modificar(int id, String nombreFunc, String cargoFunc, String cur, String alum, String grav, String fal, String desc) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "UPDATE anotaciones SET nombre_funcionario=?, cargo_funcionario=?, curso=?, alumno=?, gravedad=?, falta=?, descripcion=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombreFunc);
            ps.setString(2, cargoFunc);
            ps.setString(3, cur);
            ps.setString(4, alum);
            ps.setString(5, grav);
            ps.setString(6, fal);
            ps.setString(7, desc);
            ps.setInt(8, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { return false; }
    }

    public boolean eliminar(int id) {
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "DELETE FROM anotaciones WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { return false; }
    }
    
    public List<AnotacionDTO> listarPorAlumno(String nombreAlumno) {
        List<AnotacionDTO> lista = new ArrayList<>();
        try {
            Connection con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "SELECT * FROM anotaciones WHERE alumno = ? ORDER BY fecha DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombreAlumno);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                AnotacionDTO a = new AnotacionDTO();
                a.setId(rs.getInt("id"));
                a.setFecha(rs.getString("fecha"));
                a.setNombreFuncionario(rs.getString("nombre_funcionario"));
                a.setCargoFuncionario(rs.getString("cargo_funcionario"));
                a.setCurso(rs.getString("curso"));
                a.setAlumno(rs.getString("alumno"));
                a.setGravedad(rs.getString("gravedad"));
                a.setFalta(rs.getString("falta"));
                a.setDescripcion(rs.getString("descripcion"));
                lista.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}