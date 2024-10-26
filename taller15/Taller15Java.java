/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package taller15.java;

/**
 *
 * @author Camilo M
 */
public class Taller15Java {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";  
    private static final String USER = "postgres";  
    private static final String PASSWORD = "2108";
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Llamada a la función 'guardar_libro'
            CallableStatement guardarLibroStmt = conn.prepareCall("SELECT taller15.guardar_libro(?, ?)");
            guardarLibroStmt.setString(1, "9781233597931");
            guardarLibroStmt.setString(2, "<libro><titulo>El Principito 3</titulo><autor>Antoine de Saint-Exupéry</autor><anio>1943</anio></libro>");
            guardarLibroStmt.execute();
            System.out.println("Función 'guardar_libro' ejecutada correctamente.");
            guardarLibroStmt.close();

            // Llamada al procedimiento 'actualizar_libro'
            CallableStatement actualizarLibroStmt = conn.prepareCall("CALL taller15.actualizar_libro(?, ?)");
            actualizarLibroStmt.setString(1, "9781234597832");
            actualizarLibroStmt.setString(2, "<libro><titulo>El Principito 3 - Edición actualizada</titulo><autor>Camilo Valencia</autor><año>1943</año></libro>");
            actualizarLibroStmt.execute();
            System.out.println("Procedimiento 'actualizar_libro' ejecutado correctamente.");
            actualizarLibroStmt.close();

            // Llamada a la función 'obtener_autor_libro_por_isbn'
            CallableStatement obtenerAutorPorISBNStmt = conn.prepareCall("SELECT taller15.obtener_autor_libro_por_isbn(?)");
            obtenerAutorPorISBNStmt.setString(1, "9781234597832");
            ResultSet autorPorISBNResult = obtenerAutorPorISBNStmt.executeQuery();
            if (autorPorISBNResult.next()) {
                String autor = autorPorISBNResult.getString(1);
                System.out.println("Autor del libro con ISBN 9781234597832: " + autor);
            }
            obtenerAutorPorISBNStmt.close();

            // Llamada a la función 'obtener_autor_libro_por_titulo'
            CallableStatement obtenerAutorPorTituloStmt = conn.prepareCall("SELECT taller15.obtener_autor_libro_por_titulo(?)");
            obtenerAutorPorTituloStmt.setString(1, "El Principito 3 - Edición actualizada");
            ResultSet autorPorTituloResult = obtenerAutorPorTituloStmt.executeQuery();
            if (autorPorTituloResult.next()) {
                String autor = autorPorTituloResult.getString(1);
                System.out.println("Autor del libro con título 'El Principito 3 - Edición actualizada': " + autor);
            }
            obtenerAutorPorTituloStmt.close();

            // Llamada a la función 'obtener_libros_por_anio'
            CallableStatement obtenerLibrosPorAnioStmt = conn.prepareCall("SELECT * FROM taller15.obtener_libros_por_anio(?)");
            obtenerLibrosPorAnioStmt.setString(1, "1967");
            ResultSet librosPorAnioResult = obtenerLibrosPorAnioStmt.executeQuery();
            while (librosPorAnioResult.next()) {
                String isbn = librosPorAnioResult.getString("isbn");
                String titulo = librosPorAnioResult.getString("titulo");
                String autor = librosPorAnioResult.getString("autor");
                System.out.println("Libro - ISBN: " + isbn + ", Título: " + titulo + ", Autor: " + autor);
            }
            obtenerLibrosPorAnioStmt.close();

            // Cerrar la conexión
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
    
}
