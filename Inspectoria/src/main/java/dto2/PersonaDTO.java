package dto;

public class PersonaDTO {
    private int rut;
    private String nombre;
    private String apellido;
    private String direccion;

    public PersonaDTO() {}
    public int getRut() { return rut; }
    public void setRut(int rut) { this.rut = rut; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
}