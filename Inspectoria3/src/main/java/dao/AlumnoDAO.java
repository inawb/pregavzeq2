package dao;

import dto.AlumnoDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import servicios.FactoriaServiciosImpl;

public class AlumnoDAO {
    
    public ArrayList<AlumnoDTO> read() {
        ArrayList<AlumnoDTO> list = new ArrayList<>();
        Connection con = null;
        try {
            // Consulta actualizada sin tabla Persona
            String sql = "SELECT a.id, a.rut, a.nombre, a.apellido_paterno, a.apellido_materno, c.nombre_curso, a.id_curso, a.nombre_apoderado, a.telefono_apoderado "
                       + "FROM Alumno a "
                       + "INNER JOIN curso c ON a.id_curso = c.id_curso";
            
            con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                AlumnoDTO dto = new AlumnoDTO();
                dto.setId(rs.getInt("id"));
                dto.setRut(rs.getString("rut"));
                dto.setNombre(rs.getString("nombre"));
                dto.setApellidoPaterno(rs.getString("apellido_paterno"));
                dto.setApellidoMaterno(rs.getString("apellido_materno"));
                dto.setCurso(rs.getString("nombre_curso"));
                dto.setIdCurso(rs.getInt("id_curso"));
                dto.setApoderado(rs.getString("nombre_apoderado"));
                dto.setTelefono(rs.getString("telefono_apoderado"));
                list.add(dto);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return list;
    }
}