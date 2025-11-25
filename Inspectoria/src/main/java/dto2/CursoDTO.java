package dto;

public class CursoDTO {
    private int idCurso;
    private String nombreCurso;
    private int nivel;
    private int anioAcademico;

    public int getIdCurso() { return idCurso; }
    public void setIdCurso(int idCurso) { this.idCurso = idCurso; }
    public String getNombreCurso() { return nombreCurso; }
    public void setNombreCurso(String nombreCurso) { this.nombreCurso = nombreCurso; }
    public int getNivel() { return nivel; }
    public void setNivel(int nivel) { this.nivel = nivel; }
    public int getAnioAcademico() { return anioAcademico; }
    public void setAnioAcademico(int anioAcademico) { this.anioAcademico = anioAcademico; }
}