/*Muestre los productos de la tabla L1_DIM_PRODUCT cuya color sea Blanco, Azul o Negro. Cuya ganancia sea superior al 100 y que hayan estado disponibles para la venta después del año 2006. (clave, etiqueta, nombre, color, ganancia y fecha a la venta)*/


SELECT 
        PRD.PRODUCTKEY,
        PRD.PRODUCTLABEL,
        PRD.PRODUCTNAME,
        PRD.COLORNAME,
        RIGHT(AVAILABLEFORSALEDATE,4) AS ANIO,
        PRD.AVAILABLEFORSALEDATE,
        PRD.UNITPRICE,
        PRD.UNITCOST,
        PRD.UNITPRICE - PRD.UNITCOST AS GANANCIA
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT AS PRD
WHERE 
        PRD.COLORNAME IN ('Blanco', 'Azul' , 'Negro')
        AND
        PRD.UNITPRICE - PRD.UNITCOST > PRD.UNITCOST*2
        AND 
        RIGHT(AVAILABLEFORSALEDATE,4) > '2006'
ORDER BY GANANCIA DESC;
        

/*Muestre los productos de la tabla L1_DIM_PRODUCT cuya clase sea "Normal" y su color sea Azul. O si el color es diferente a azul que la clase sea diferente a normal. (clave, etiqueta, nombre, color y clase)*/

SELECT
        PRD.PRODUCTLABEL,
        PRD.PRODUCTKEY,
        PRD.PRODUCTNAME,
        PRD.COLORNAME,
        PRD.CLASSNAME
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT AS PRD
WHERE   (COLORNAME = 'Azul' AND CLASSNAME = 'Normal') 
        OR
        (CLASSNAME <> 'Normal' AND COLORNAME <> 'Azul');
        
/*Muestre las ventas de la tabla L1_FACT_SALES cuya cantidad vendida sea igual o mayor a 20 o que el precio unitario sea menor a 15 pero que en ninguno de los casos sean del canal 1 o del canal 3 (fecha, total venta, cantidad vendida, precio unitario, canal)*/

SELECT
        SLS.DATEKEY,
        SLS.SALESAMOUNT,
        SLS.SALESQUANTITY,
        SLS.UNITCOST,
        SLS.CHANNELKEY
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES AS SLS 
WHERE (SALESQUANTITY >= 20
        OR
      UNITCOST < 15)
        AND
      (CHANNELKEY NOT IN (1,3));

/*    
Muestre las tiendas (tabla L1_DIM_STORE) que no estén activas para el código postal 97001 donde el tipo de Store sea diferente a "En línea" (clave, nombre, tipo, código postal y estado)*/


SELECT
    STOREKEY,
    STORENAME,
    STORETYPE,
    ZIPCODE,
    STATUS
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_STORE
WHERE   STATUS = 'Desactivado'
        AND
        ZIPCODE = 97001
        AND 
        STORETYPE <> 'En línea';

