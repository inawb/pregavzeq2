package dto;

public class FuncionarioDTO {
    private int id;
    private String nombre;
    private String cargo;

    public FuncionarioDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }
    
    // Método útil para mostrar "Juan Perez (Inspector)" en el menú
    public String getEtiqueta() {
        return nombre + " (" + cargo + ")";
    }
}