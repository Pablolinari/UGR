
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
