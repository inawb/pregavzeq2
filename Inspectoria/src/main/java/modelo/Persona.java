package modelo;

public abstract class Persona {
    private int rut;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String direccion;

    public Persona() {}
    public Persona(int rut, String nombre, String apP, String apM, String dir) {
        this.rut = rut; this.nombre = nombre; this.apellidoPaterno = apP; this.apellidoMaterno = apM; this.direccion = dir;
    }
    // Getters y Setters resumidos (usa los tuyos si prefieres)
    public int getRut() { return rut; }
    public void setRut(int rut) { this.rut = rut; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellidoPaterno() { return apellidoPaterno; }
    public void setApellidoPaterno(String apellidoPaterno) { this.apellidoPaterno = apellidoPaterno; }
    public String getApellidoMaterno() { return apellidoMaterno; }
    public void setApellidoMaterno(String apellidoMaterno) { this.apellidoMaterno = apellidoMaterno; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
}