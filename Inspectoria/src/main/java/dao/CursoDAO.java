package dao;

import dto.CursoDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import servicios.FactoriaServiciosImpl;

public class CursoDAO implements iCrud{
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;
    
    public List<CursoDTO> listarCursos() throws Exception {
        List<CursoDTO> lista = new ArrayList<>();
        conn = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
        String sql = "SELECT * FROM curso ORDER BY nivel, nombre_curso";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        while (rs.next()) {
            CursoDTO c = new CursoDTO();
            c.setIdCurso(rs.getInt("id_curso"));
            c.setNombreCurso(rs.getString("nombre_curso"));
            c.setNivel(rs.getInt("nivel"));
            c.setAnioAcademico(rs.getInt("anio_academico"));
            lista.add(c);
        }
        return lista;
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