package dao;
import java.util.ArrayList;

public interface iCrud<T, DTO> {
    public int create(T t) throws Exception;
    public ArrayList<DTO> read() throws Exception;
    public T read(int id) throws Exception;
    public int update(T t) throws Exception;
    public int delete(int id) throws Exception;
}