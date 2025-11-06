/*Muestre las ventas de la tabla L1_FACT_SALES cuyo descuento fue superior a la ganancia de la venta (fecha, id_producto, descuento, ganancia)*/

SELECT
        SLS.DATEKEY,
        SLS.PRODUCTKEY,
        SLS.DISCOUNTAMOUNT,
        UNITCOST,
        UNITPRICE,
        SALESAMOUNT - TOTALCOST  AS GANANCIA
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES AS SLS
WHERE DISCOUNTAMOUNT > GANANCIA
ORDER BY DISCOUNTAMOUNT DESC;

/*Muestre los productos de la tabla L1_DIM_PRODUCT (clave, etiqueta, nombre, costo y precio de venta) donde la ganancia esté en un rango del 10% y el 20% sobre el precio de costo*/

SELECT
        PRD.PRODUCTKEY,
        PRD.PRODUCTLABEL,
        PRD.PRODUCTNAME,
        PRD.UNITCOST,
        PRD.UNITPRICE,
        UNITPRICE - UNITCOST   AS GANANCIA
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT AS PRD
WHERE (GANANCIA > UNITCOST*1.1) AND (GANANCIA < UNITCOST*1.2);

/*Analice las ventas del año 2023 de la tabla L1_FACT_SALES y a posterior calcule cuál sería la ganancia si aplicáramos un descuento 15% superior al que fue aplicado originalmente (Mostrar las columnas que considere importante para el análisis) (Bajar a csv los resultados para sumarizar y comparar).*/


SELECT 
    SALESAMOUNT,
    TOTALCOST,
    DISCOUNTAMOUNT,
    DISCOUNTAMOUNT*0.15 AS DESCUENTO15,
    SALESAMOUNT - TOTALCOST - DISCOUNTAMOUNT - DISCOUNTAMOUNT*0.15 AS GANANCIA_FINAL,
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES AS SLS
WHERE YEAR(DATEKEY) = '2023' 

