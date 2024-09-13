CREATE TABLE clientes (
    id_cliente NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    nombre VARCHAR2(100) NOT NULL,
    identificacion VARCHAR2(20) UNIQUE NOT NULL,
    edad NUMBER(3),
    correo VARCHAR2(100),
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)
);

CREATE TABLE productos (
    id_producto NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    codigo VARCHAR2(50) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    stock NUMBER DEFAULT 0,
    valor_unitario NUMBER(10, 2) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (id_producto)
);

CREATE TABLE facturas (
    id_factura NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY, 
    codigo VARCHAR2(50) UNIQUE NOT NULL,
    fecha DATE DEFAULT SYSDATE, 
    cantidad NUMBER,
    valor_total NUMBER(10, 2),
    pedido_estado VARCHAR2(20) CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')),
    producto_id NUMBER,
    cliente_id NUMBER,
    CONSTRAINT pk_factura PRIMARY KEY (id_factura),
    CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES productos(id_producto),
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente)
);

CREATE OR REPLACE PROCEDURE verificar_stock(
    p_producto_id IN NUMBER,
    p_cantidad_compra IN NUMBER
)
IS
    v_stock productos.stock%TYPE;
BEGIN
    SELECT stock 
    INTO v_stock
    FROM productos
    WHERE id_producto = p_producto_id;
    
    IF v_stock >= p_cantidad_compra THEN
        DBMS_OUTPUT.PUT_LINE('Existe suficiente stock: ');
        DBMS_OUTPUT.PUT_LINE(v_stock);
        DBMS_OUTPUT.PUT_LINE(' unidades disponibles.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe suficiente stock. Solo hay ');
        DBMS_OUTPUT.PUT_LINE(v_stock);
        DBMS_OUTPUT.PUT_LINE(' unidades disponibles.');
    END IF;

END verificar_stock;
/

ALTER USER INVENTARIO QUOTA UNLIMITED ON USERS;


INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
VALUES ('P001', 'Producto 1', 50, 10.00);

INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
VALUES ('P002', 'Producto 2', 5, 20.00);

INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
VALUES ('P003', 'Producto 3', 100, 5.50);

BEGIN
    verificar_stock(1, 30);
END;
