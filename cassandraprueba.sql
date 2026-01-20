
CREATE KEYSPACE sistema_seguros 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE sistema_seguros.factura (
    idfactura uuid PRIMARY KEY,
    nss text,
    dni text,
    dnipagador text,
    nombre text,
    apellido text,
    telefono text,
    precio decimal,
    porcentaje float,
    recursos text
);
CREATE TABLE sistema_seguros.pagador (
    dni text PRIMARY KEY,
    nombre text,
    apellido text,
    tarjeta text
);

CREATE TABLE sistema_seguros.seguro (
    idseguro uuid PRIMARY KEY,
    nss text,
    nombre text,
    correo text,
    telefono text,
    descripcion text
);

INSERT INTO sistema_seguros.pagador (dni, nombre, apellido, tarjeta) VALUES ('12345678A', 'Juan', 'Pérez', '4540-1234-5678');

INSERT INTO sistema_seguros.seguro (idseguro, nss, nombre, correo, telefono, descripcion) VALUES (uuid(), '12345678', 'paco', 'paco@gemail.com', '123456789', 'Seguro de salud');

INSERT INTO sistema_seguros.factura ( idfactura, nss, dni,dnipagador, nombre, apellido, precio, porcentaje ) 
VALUES (
uuid(), '1111111111', '75571087e', '77888999B', 'pablo', 'jimenez',
14000.50, 0.9 );
UPDATE sistema_seguros.factura
SET precio = 140.75, recursos = 'Actualización de cobertura'
WHERE idfactura = 567f4e7d9-3a28-4051-819f-2c1c94cfbf02;

DELETE FROM sistema_seguros.factura WHERE idfactura =
550e8400-e29b-41d4-a716-446655440000;

SELECT idfactura FROM sistema_seguros.factura WHERE nombre
= 'pablo' ALLOW FILTERING;

DELETE FROM
sistema_seguros.factura
WHERE idfactura = a3598816-f82e-4efb-b735-758ba9e94f32