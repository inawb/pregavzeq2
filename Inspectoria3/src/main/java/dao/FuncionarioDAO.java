package dao;

import dto.FuncionarioDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import servicios.FactoriaServiciosImpl;

public class FuncionarioDAO {
    
    public List<FuncionarioDTO> listar() {
        List<FuncionarioDTO> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = FactoriaServiciosImpl.getFactoria().getConexionDB().getConexion();
            String sql = "SELECT * FROM funcionarios ORDER BY nombre ASC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                FuncionarioDTO f = new FuncionarioDTO();
                f.setId(rs.getInt("id"));
                f.setNombre(rs.getString("nombre"));
                f.setCargo(rs.getString("cargo"));
                lista.add(f);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}