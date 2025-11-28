package dto;

public class UsuarioDTO {
    private int id;
    private String usuario;
    private String pass;
    private String rol;

    public UsuarioDTO() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsuario() { return usuario; }
    public void setUsuario(String usuario) { this.usuario = usuario; }
    public String getPass() { return pass; }
    public void setPass(String pass) { this.pass = pass; }
    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
}