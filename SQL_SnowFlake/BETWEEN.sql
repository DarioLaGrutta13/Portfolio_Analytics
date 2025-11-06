--Muestre las ventas realizadas entre el 01 de DICIEMBRE de 2023 y el 11 de MARZO de 2024 (clave, fecha, total venta, cantidad vendida, precio unitario, costo unitario, almacen, ganancia y canal).

SELECT
*
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES
WHERE DATEKEY BETWEEN '2023-12-01' AND '2024-03-11';


/*Muestre los almacenes cuya cantidad de empleados varía entre 100 y 200 personas, donde el área de venta no supere los 500 m² y su estado evidencie que está activo (almacén, nombre, tipo, clave geográfica, estado, superficie, cantidad empleados).*/


SELECT
    sto.storemanager,
    sto.storename,
    sto.storetype,
    sto.geographykey,
    sto.status,
    sto.sellingareasize,
    sto.employeecount
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_STORE AS STO 
WHERE (employeecount BETWEEN 100 AND 200)
    AND 
    sellingareasize < 500
    AND
    status = 'Activado';

/*Muestre los productos de la tabla L1_DIM_PRODUCT que estuvieron disponibles para la venta el 01/05/2008 (clave, nombre, precio unitario, costo unitario, ganancia)*/


SELECT
productname,
productkey,
unitprice,
unitcost,
unitprice - unitcost AS Ganancia,
AVAILABLEFORSALEDATE,
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT
WHERE AVAILABLEFORSALEDATE = '01-05-2007';