package servicios;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class IniciadorServicios implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Aplicacion web iniciada. Configurando MySQL...");
        // Configuramos para que use MySQL por defecto
        FactoriaServiciosImpl.getFactoria().setMotor("mysql");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}