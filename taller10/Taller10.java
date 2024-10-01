/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package taller10;

import java.sql.*;

/**
 *
 * @author Camilo M
 */
public class Taller10 {

    /**
     * @param args the command line arguments
     */
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";  // Cambia la URL de acuerdo a tu configuración
    private static final String USER = "postgres";  // Usuario de la base de datos
    private static final String PASSWORD = "2108";  // Contraseña del usuario
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            // Llamada al procedimiento 'generar_auditoria'
            CallableStatement stmt1 = conn.prepareCall("CALL taller4.generar_auditoria(?, ?)");
            java.sql.Date fechaInicio = java.sql.Date.valueOf("2024-08-30");
            java.sql.Date fechaFin = java.sql.Date.valueOf("2024-09-01");
            
            stmt1.setDate(1, fechaInicio);
            stmt1.setDate(2, fechaFin);
            
            stmt1.execute();
            System.out.println("Procedimiento 'generar_auditoria' ejecutado correctamente.");
            
            
            // Llamada al procedimiento 'actualizar_estado_pedido'
            CallableStatement stmt2 = conn.prepareCall("CALL taller4.actualizar_estado_pedido(?, ?)");
            
            stmt2.setString(1, "F003"); 
            stmt2.setString(2, "PENDIENTE"); 
            
            stmt2.execute();
            System.out.println("Procedimiento 'actualizar_estado_pedido' ejecutado correctamente.");
            
            // Llamada a la función 'transacciones_total_mes'
            int mes = 7; 
            String identificacionCliente = "ID_1"; 

            CallableStatement stmt3 = conn.prepareCall("SELECT taller6.transacciones_total_mes(?, ?)");
            stmt3.setInt(1, mes);
            stmt3.setString(2, identificacionCliente);

            stmt3.execute();

            ResultSet rs = stmt3.executeQuery();
            if (rs.next()) {
                double totalPagos = rs.getDouble(1);
                System.out.println("Total de pagos para el cliente " + identificacionCliente + " en el mes " + mes + ": " + totalPagos);
            }
            // Cerrar las conexiones
            stmt1.close();
            stmt2.close();
            stmt3.close();
            conn.close();
        } catch (ClassNotFoundException |SQLException e) {
            e.printStackTrace();
        }   
    }
}
