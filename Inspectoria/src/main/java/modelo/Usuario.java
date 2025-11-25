package modelo;

public class Usuario {
    private int id;
    private String usuario;
    private String pass;
    private String rol;

    public Usuario() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsuario() { return usuario; }
    public void setUsuario(String u) { this.usuario = u; }
    public String getPass() { return pass; }
    public void setPass(String p) { this.pass = p; }
    public String getRol() { return rol; }
    public void setRol(String r) { this.rol = r; }
}