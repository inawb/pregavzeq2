package servicios;
import db.ConexionGenericaDB;

public class FactoriaServiciosImpl implements iFactoria {
    private static String motor;
    private static FactoriaServiciosImpl factoriaServicios; 
    private static ConexionGenericaDB conexionGenericaDB;
    
    public void setMotor(String motor) { FactoriaServiciosImpl.motor = motor; }
    
    public synchronized static FactoriaServiciosImpl getFactoria() {
        if (factoriaServicios == null) {
            factoriaServicios = new FactoriaServiciosImpl();
        }
        return factoriaServicios;
    }
     
    @Override
    public synchronized ConexionGenericaDB getConexionDB() throws Exception {
        if (conexionGenericaDB == null) {
            switch (motor) {
                case "mysql": 
                    // Instancia la clase dinámicamente
                    conexionGenericaDB = (ConexionGenericaDB) Class.forName("db.ConexionMySql").newInstance(); 
                    break;
            }
        }
        return conexionGenericaDB;
    }
}