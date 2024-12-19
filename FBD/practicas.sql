/*
CREATE TABLE ventas (
    codpro CONSTRAINT codpro_clave_externa_proveedor
    REFERENCES proveedor(codpro),
    codpie CONSTRAINT codpie_clave_externa_pieza
    REFERENCES pieza(codpie),
    codpj CONSTRAINT codpj_clave_externa_proyecto
    REFERENCES proyecto(codpj),
    cantidad NUMBER(4),
    fecha date,
    CONSTRAINT clave_primaria PRIMARY KEY (codpro,codpie,codpj));
*/




insert into proveedor values('S1', 'Jose Fernandez', '2', 'Madrid');
insert into proveedor values('S2', 'Manuel Vidal', '1', 'Londres');
insert into proveedor values('S3', 'Luisa Gomez', '3', 'Lisboa');
insert into proveedor values('S4', 'Maria Reyes', '5', 'Roma');
insert into proveedor values('S6', 'Jose Perez', '6', 'Bruselas');
insert into proveedor values('S7', 'Luisa Martin', '7', 'Atenas');



insert into pieza values('P1', 'Tuerca', 'Gris', '2', '5 Madrid');
insert into pieza values('P2', 'Tornillo', 'Rojo', '1', '25 Paris');
insert into pieza values('P3', 'Arandela', 'Blanco', '3', 'Londres');
insert into pieza values('P4', 'Clavo', 'Gris', '5', '5 Lisboa');
insert into pieza values('P5', 'Alcayata', 'Blanco', '1', ' Roma');


insert into proyecto values('J1', 'Proyecto 1', 'Londres');
insert into proyecto values('J2', 'Proyecto 2', 'Londres');
insert into proyecto values('J3', 'Proyecto 3', 'Paris');
insert into proyecto values('J4', 'Proyecto 4', 'Roma');



insert into ventas values('S1', 'P1', 'J1', '150', to_date('18/09/1997', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P1', 'J2', '100', to_date('06/05/1996', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P1', 'J3', '500', to_date('06/05/1996', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P2', 'J1', '200', to_date('22/07/1995', 'dd/mm/yyyy'));
insert into ventas values('S2', 'P2', 'J2', '15', to_date('23/11/2004', 'dd/mm/yyyy'));
insert into ventas values('S4', 'P2', 'J3', '1700', to_date('28/11/2000', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P3', 'J1', '800', to_date('22/07/1995', 'dd/mm/yyyy'));
insert into ventas values('S5', 'P3', 'J2', '30', to_date('01/04/2014', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P4', 'J1', '10', to_date('22/07/1995', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P4', 'J3', '250', to_date('09/03/1994', 'dd/mm/yyyy'));
insert into ventas values('S2', 'P5', 'J2', '300', to_date('23/11/2004', 'dd/mm/yyyy'));
insert into ventas values('S2', 'P2', 'J1', '4500', to_date('15/08/2004', 'dd/mm/yyyy'));
insert into ventas values('S3', 'P1', 'J1', '90', to_date('09/06/2004', 'dd/mm/yyyy'));
insert into ventas values('S3', 'P2', 'J1', '190', to_date('12/04/2002', 'dd/mm/yyyy'));
insert into ventas values('S3', 'P5', 'J3', '20', to_date('28/11/2000', 'dd/mm/yyyy'));
insert into ventas values('S4', 'P5', 'J1', '15', to_date('12/04/2002', 'dd/mm/yyyy'));
insert into ventas values('S4', 'P3', 'J1', '100', to_date('12/04/2002', 'dd/mm/yyyy'));
insert into ventas values('S4', 'P1', 'J3', '1500', to_date('26/01/2003', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P4', 'J4', '290', to_date('09/03/1994', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P2', 'J4', '175', to_date('09/03/1994', 'dd/mm/yyyy'));
insert into ventas values('S5', 'P1', 'J4', '400', to_date('01/04/2014', 'dd/mm/yyyy'));
insert into ventas values('S5', 'P3', 'J3', '400', to_date('01/04/2014', 'dd/mm/yyyy'));
insert into ventas values('S1', 'P5', 'J1', '340', to_date('06/02/2010', 'dd/mm/yyyy'));
insert into ventas values('S6', 'P1', 'J1', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S6', 'P1', 'J2', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S6', 'P1', 'J3', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S6', 'P1', 'J4', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S7', 'P1', 'J1', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S7', 'P1', 'J2', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S7', 'P1', 'J3', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
insert into ventas values('S7', 'P1', 'J4', '340', to_date('10/02/2006', 'dd/mm/yyyy'));
--Ejercicio 27 
SELECT nompie ,MAX(peso)
from pieza ;


--Ejercicio 30

SELECT v.codpro
FROM ventas v
GROUP BY v.codpro
HAVING COUNT(DISTINCT v.codpie) > 3;
--Ejercicio 35
SELECT p.nompro ,SUM(v.cantidad)
from ventas v , proveedor p
where v.codpro = p.codpro
GROUP BY p.nompro
HAVING SUM(cantidad) > 1000;


--Ejercicio 36 
SELECT p.nompie --,sum(v.cantidad)
FROM pieza p ,ventas v
where p.codpie = v.codpie 
group by p.nompie 
having sum(v.cantidad) = (select max(sum(cantidad)) 
                            from ventas
                            group by codpie);
 
/*
select p.nompie , sum(v.cantidad) 
from pieza p , ventas v 
where v.codpie = p.codpie
group by p.nompie;
*/
COMMIT;
