package modelo;

public class Alumno extends Persona {
    private int id;
    private int idCurso;
    private int cantidadAtrasos;
    private int cantidadInasistencias;

    public Alumno() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdCurso() { return idCurso; }
    public void setIdCurso(int idCurso) { this.idCurso = idCurso; }
    public int getCantidadAtrasos() { return cantidadAtrasos; }
    public void setCantidadAtrasos(int c) { this.cantidadAtrasos = c; }
    public int getCantidadInasistencias() { return cantidadInasistencias; }
    public void setCantidadInasistencias(int c) { this.cantidadInasistencias = c; }
}