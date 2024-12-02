/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial3;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCursor;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author Camilo M
 */
public class Main {
    public static void main(String[] args){
        //URI
        String uri = "mongodb://localhost:27017/";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("parcial-3");
        System.out.println("Conexion Exitosa");
        System.out.println("Conectado a la base de datos: " + mongoDatabase.getName());
        
        MongoCollection<Document> productos = mongoDatabase.getCollection("productos");
        MongoCollection<Document> pedidos = mongoDatabase.getCollection("pedidos");
        MongoCollection<Document> detalles = mongoDatabase.getCollection("detalles");
      
        Puntos ejercicios = new Puntos();
        ejercicios.punto1(productos, pedidos, detalles);
        ejercicios.punto2(productos, pedidos, detalles);
        
        mongoClient.close();
    }
    
    
    
}

