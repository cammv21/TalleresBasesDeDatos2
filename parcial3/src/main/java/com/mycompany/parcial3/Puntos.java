/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial3;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import static com.mongodb.client.model.Filters.gt;
import org.bson.Document;

/**
 *
 * @author Camilo M
 */
public class Puntos {
    // -------------------------------------- Punto 1 -----------------------------------
    public void punto1(MongoCollection<Document> productos, MongoCollection<Document> pedidos, MongoCollection<Document> detalles){
        this.crearProducto(productos, "Camisa", "100% de algodon", 20, 200);
        this.editarProducto(productos, "Camisa", 100);
        this.eliminarProducto(productos, "Camisa");
        this.listar(productos);
    }
    
    public void listar(MongoCollection<Document> collection){
        MongoCursor<Document> cursor = collection.find().iterator();
        try {
            while (cursor.hasNext()){
                System.out.println(cursor.next().toJson());
            }
        } catch (Exception e) {
        }
    }
    
    // ------------------------ Producto ----------------------------
    public void crearProducto(MongoCollection<Document> collection, String nombre, String descripcion, int precio, int stock){
        Document producto = new Document ("_id", "producto001")
                    .append("nombre", nombre)
                    .append("descripcion", descripcion)
                    .append("precio", precio)
                    .append("stock", stock);
        try {
            collection.insertOne(producto);
            System.out.println("Producto creado exitosamente");
        } catch (Exception e) {
            System.out.println("Error al crear: " + e.getMessage());
        }
    }
    
    public void editarProducto(MongoCollection<Document> collection, String nombre, int stock_actualizado){
        collection.updateOne( eq("nombre", nombre), set("stock", stock_actualizado));
        System.out.println("Documento actualizado");
        
    }
    
    public void eliminarProducto(MongoCollection<Document> collection, String nombre){
        collection.deleteOne(eq("nombre", nombre));
        System.out.println("Producto de nombre " + nombre + "eliminado correctamente");
    }
    
    // ------------------------ Pedido ----------------------------
    public void crearPedido(MongoCollection<Document> collection, String cliente, String fecha_pedido, String estado, int total){
        Document producto = new Document ("_id", "detalle001")
                    .append("cliente", cliente)
                    .append("fecha_pedido", fecha_pedido)
                    .append("estado", estado)
                    .append("total", total);
        try {
            collection.insertOne(producto);
            System.out.println("Detalle creado exitosamente");
        } catch (Exception e) {
            System.out.println("Error al crear: " + e.getMessage());
        }
    }
    
    public void editarPedido(MongoCollection<Document> collection, String id, int total_actualizado){
        collection.updateOne( eq("_id", id), set("total", total_actualizado));
        System.out.println("Pedido actualizado");
        
    }
    
    public void eliminarPedido(MongoCollection<Document> collection, String id){
        collection.deleteOne(eq("_id", id));
        System.out.println("Pedido de id " + id + "eliminado correctamente");
    }
    
    // ------------------------ Detalle ----------------------------
    public void crearDetalle(MongoCollection<Document> collection, String pedido, String producto, int cantidad, int precio_unitario){
        Document detalle = new Document ("pedido_id", pedido)
                    .append("producto_id", producto)
                    .append("cantidad", cantidad)
                    .append("precio_unitario", precio_unitario);
        try {
            collection.insertOne(detalle);
            System.out.println("Detalle creado exitosamente");
        } catch (Exception e) {
            System.out.println("Error al crear: " + e.getMessage());
        }
    }
    
    public void editarDetalle(MongoCollection<Document> collection, String nombre, int stock_actualizado){
        collection.updateOne( eq("nombre", nombre), set("stock", stock_actualizado));
        System.out.println("Detalle actualizado");
        
    }
    
    public void eliminarDetalle(MongoCollection<Document> collection, String id){
        collection.deleteOne(eq("_id", id));
        System.out.println("Detalle de id " + id + "eliminado correctamente");
    }
    
    
    // -------------------------------------- Punto 2 -----------------------------------
    public void punto2(MongoCollection<Document> productos, MongoCollection<Document> pedidos, MongoCollection<Document> detalles){
        this.consulta_1(productos);
        this.consulta_2(pedidos);
    }
    
    public void consulta_1(MongoCollection<Document> collection){
        MongoCursor<Document> cursor = collection.find( gt("precio", 20)).iterator();
        try {
            while(cursor.hasNext()){
                System.out.println(cursor.next().toJson());
            }
        } catch (Exception e) {
        }
    }
    
    public void consulta_2(MongoCollection<Document> collection){
        MongoCursor<Document> cursor = collection.find( gt("total", 100)).iterator();
        try {
            while(cursor.hasNext()){
                System.out.println(cursor.next().toJson());
            }
        } catch (Exception e) {
        }
    }
}
