package dto;

public class AlumnoDTO {
    private int id;
    private String nombreAlumno;
    private String apellidoPAlumno;
    private String apellidoMalumno;
    private int rut;
    private String curso;
    private int idCurso;
    private int cantidadAtrasos;
    private int cantidadInasistencias;

    public AlumnoDTO() {}

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombreAlumno() { return nombreAlumno; }
    public void setNombreAlumno(String nombreAlumno) { this.nombreAlumno = nombreAlumno; }
    public String getApellidoPAlumno() { return apellidoPAlumno; }
    public void setApellidoPAlumno(String apellidoPAlumno) { this.apellidoPAlumno = apellidoPAlumno; }
    public String getApellidoMAlumno() { return apellidoMalumno; }
    public void setApellidoMAlumno(String apellidoMalumno) { this.apellidoMalumno = apellidoMalumno; }
    public int getRut() { return rut; }
    public void setRut(int rut) { this.rut = rut; }
    public String getCurso() { return curso; }
    public void setCurso(String curso) { this.curso = curso; }
    public int getIdCurso() { return idCurso; }
    public void setIdCurso(int idCurso) { this.idCurso = idCurso; }
    public int getCantidadAtrasos() { return cantidadAtrasos; }
    public void setCantidadAtrasos(int cantidadAtrasos) { this.cantidadAtrasos = cantidadAtrasos; }
    public int getCantidadInasistencias() { return cantidadInasistencias; }
    public void setCantidadInasistencias(int cantidadInasistencias) { this.cantidadInasistencias = cantidadInasistencias; }
    
    // Método extra útil para el frontend
    public String getNombreCompleto() { return nombreAlumno + " " + apellidoPAlumno + " " + apellidoMalumno; }
}