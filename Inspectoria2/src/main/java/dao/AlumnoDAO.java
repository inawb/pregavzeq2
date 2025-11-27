package dao;

import dto.AlumnoDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import modelo.Alumno;
import servicios.FactoriaServiciosImpl;

public class AlumnoDAO implements iCrud<Alumno, AlumnoDTO>{
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    @Override
    public ArrayList<AlumnoDTO> read() throws Exception {
        ArrayList<AlumnoDTO> list = new ArrayList<>();
        String sql = "SELECT a.id, a.rut, p.nombre, p.apellido_paterno, p.apellido_materno, c.nombre_curso, a.id_curso, a.cantidad_atrasos, a.cantidad_inasistencias "
                   + "FROM Alumno a "
                   + "INNER JOIN Persona p ON a.rut = p.rut "
                   + "INNER JOIN curso c ON a.id_curso = c.id_curso";
        
        con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            AlumnoDTO dto = new AlumnoDTO();
            dto.setId(rs.getInt("id"));
            dto.setNombreAlumno(rs.getString("nombre"));
            dto.setApellidoPAlumno(rs.getString("apellido_paterno"));
            dto.setApellidoMAlumno(rs.getString("apellido_materno"));
            dto.setRut(rs.getInt("rut"));
            dto.setCurso(rs.getString("nombre_curso"));
            dto.setIdCurso(rs.getInt("id_curso"));
            list.add(dto);
        }
        return list;
    }
    
    // Métodos vacíos obligatorios por la interfaz iCrud (puedes implementarlos si quieres)
    public Alumno read(int id) throws Exception { return null; }
    public int create(Alumno a) throws Exception { return 0; }
    public int update(Alumno a) throws Exception { return 0; }
    public int delete(int id) throws Exception { return 0; }
}