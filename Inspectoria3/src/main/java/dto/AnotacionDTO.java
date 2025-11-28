package dto;

public class AnotacionDTO {
    private int id;
    private String fecha;
    private String nombreFuncionario; // Cambiado de profesor a nombreFuncionario
    private String cargoFuncionario;  // Nuevo
    private String curso;
    private String alumno;
    private String gravedad;
    private String falta;
    private String descripcion;

    public AnotacionDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }
    
    public String getNombreFuncionario() { return nombreFuncionario; }
    public void setNombreFuncionario(String nombreFuncionario) { this.nombreFuncionario = nombreFuncionario; }
    
    public String getCargoFuncionario() { return cargoFuncionario; }
    public void setCargoFuncionario(String cargoFuncionario) { this.cargoFuncionario = cargoFuncionario; }
    
    public String getCurso() { return curso; }
    public void setCurso(String curso) { this.curso = curso; }
    public String getAlumno() { return alumno; }
    public void setAlumno(String alumno) { this.alumno = alumno; }
    public String getGravedad() { return gravedad; }
    public void setGravedad(String gravedad) { this.gravedad = gravedad; }
    public String getFalta() { return falta; }
    public void setFalta(String falta) { this.falta = falta; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}