package servicios;
import db.ConexionGenericaDB;

public interface iFactoria {
    public ConexionGenericaDB getConexionDB() throws Exception;
}