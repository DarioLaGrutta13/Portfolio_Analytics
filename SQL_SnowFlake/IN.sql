/*Muestre las ventas realizadas cuyas cantidades compradas sean 1, 5, 10 o 50 (clave, fecha, total de la venta, cantidad vendida)*/

SELECT 
    saleskey,
    datekey,
    salesamount,
    salesquantity
FROM jupi_digital.landing_zone.l1_fact_sales
WHERE salesquantity IN (1, 5, 10 , 50);

/*Muestre los productos cuyo color corresponda a un color primario (clave, etiqueta, nombre y color)*/

SELECT 
    productname
FROM jupi_digital.landing_zone.l1_dim_product
WHERE colorname IN ('Rojo', 'Amarillo', 'Azul');

/*Muestre las ventas de los almacenes 200 y 310, donde la cantidad vendida sea mayor a 20 y menor a 50 (clave, fecha, total de la venta, cantidad vendida y almacén)*/

SELECT
    storekey,
    storetype,
    storemanager,
    sellingareasize,
    lastremodeldate
FROM jupi_digital.landing_zone.L1_DIM_STORE
WHERE storemanager IN (200, 310) 
        AND
      (sellingareasize > 20 AND sellingareasize < 50);

/*Muestre los almacenes que están activos y cuya clave sea 301, 308, 310 (clave, nombre, tipo y estado)*/

SELECT
    storekey,
    storetype,
    storemanager,
    status
FROM jupi_digital.landing_zone.L1_DIM_STORE
WHERE status = 'Activado' AND 
        storemanager IN (215, 75, 56);

/*Muestre las ventas de las promociones 1 o 22 cuya ganancia sea mayor o igual a 100% pero que no correspondan al canal 2*/

SELECT
    promotionkey,
    channelkey,
    salesamount,
    unitcost,
    unitprice,
    unitprice - unitcost AS Ganancia
FROM jupi_digital.landing_zone.l1_fact_sales
WHERE promotionkey IN (1, 22) 
        AND 
        (
            ((unitprice - unitcost) >= unitcost*2)
            AND 
            channelkey <> 2);



