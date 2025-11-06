-- Ejercicio SELECT
SELECT * 
FROM jupi_digital.information_schema.tables
LIMIT 10

SELECT * 
FROM jupi_digital.information_schema.databases
LIMIT 10

SELECT *
FROM jupi_digital.information_schema.columns col
LIMIT 10


SELECT col.table_name, col.column_name, col.data_type
FROM jupi_digital.information_schema.columns col
WHERE col.table_name IN ('L1_FACT_SALES','L1_DIM_STORE','L1_DIM_PRODUCT');

SELECT *
FROM information_schema.referential_constraints rc
WHERE jupi_digital.information_schema.constraint_schema = 'spanish'
AND rc.table_name IN ('L1_FACT_SALES','L1_DIM_STORE','L1_DIM_PRODUCT');

use database jupi_digital;
use schema LANDING_ZONE;

-- Ejercicio LIMIT

SELECT *
FROM jupi_digital.LANDING_ZONE.l1_fact_sales
LIMIT 10
OFFSET 5

SELECT *
FROM jupi_digital.LANDING_ZONE.l1_dim_product
LIMIT 2
OFFSET 1;

-- EJERCICIO WHERE ---
/*Muestre los datos del canal 1 de la tabla dimchannel*/
SELECT dc."ChannelKey", dc."ChannelName", dc."ChannelDescription"
FROM jupi_digital.LANDING_ZONE.l1_dim_channel dc
WHERE dc."ChannelKey" = 1;

/*Muestre los productos de la tabla dimproduct cuya columna classname sea igual a Economía*/
SELECT dp."ProductKey", dp."ProductName", dp."ClassName"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE dp."ClassName" = 'Normal';

/*Muestre los productos de la tabla dimproducto cuya columna weight sea superior a los 8 gramos*/
SELECT dp."ProductKey", dp."ProductName", dp."Weight"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE dp."Weight" > 8;

/*Muestre los productos de la tabla dimproducto cuya columna weight sea superior a los 4 gramos */
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."Weight", 
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE     (dp."Weight" > 4 AND dp."WeightUnitMeasureID" LIKE 'gramos%') OR (dp."Weight" > 0.004 AND dp."WeightUnitMeasureID" LIKE 'kilogramos%');

/*Muestre las ventas del día 02/01/2007 de la tabla factsales*/
SELECT fs."DateKey", fs."SalesAmount", fs."SalesQuantity"
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE fs."DateKey" LIKE '2007-01-02' 

SELECT * 
FROM jupi_digital.LANDING_ZONE.l1_dim_date
LIMIT 10


-- EJERCICIO OPERADORES DE COMPARACION --

/* Muestre los datos de los canales mayores e iguales a 4 de la tabla dimchannel*/
SELECT dc."ChannelKey", dc."ChannelName", dc.*
FROM jupi_digital.LANDING_ZONE.l1_dim_channel dc
WHERE dc."ChannelKey" >= 4;


/*Muestre los productos de la tabla dimproduct cuya columna classname sea diferente al valor Norma*/
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."ClassName"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE dp."ClassName" != 'Normal';

/*Calcule el costo total y el precio total de las ventas del día 02/01/2007 de la tabla factsales
Utilizar cantidad por precio*/
SELECT fs."DateKey", 
(fs."SalesQuantity" * fs."UnitPrice") precio_total, 
(fs."SalesQuantity" * fs."UnitCost") costo_total
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE fs."DateKey" LIKE '2007-01-02' 

/*Calcule cual es la ganancia de las ventas sobre la consulta del punto anterior*/
SELECT 
    fs."DateKey",
    (fs."SalesQuantity" * fs."UnitPrice") precio_total,
    (fs."SalesQuantity" * fs."UnitCost") costo_total,
    (fs."SalesQuantity" * fs."UnitPrice") - (fs."SalesQuantity" * fs."UnitCost") ganancia
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE fs."DateKey" LIKE '2007-01-02' 

/*Muestre las ventas realizadas entre el 01/01/2008 y el 01/07/2008*/
SELECT 
    fs."DateKey",
    fs."SalesAmount",
    fs."TotalCost",
    fs."DiscountAmount",
    fs."ProductKey"
FROM l1_fact_sales fs
WHERE fs."DiscountAmount" > fs."SalesAmount" - fs."TotalCost";

/* Muestre los productos de la tabla dim_producto (clave, etiqueta, nombre, costo y precio de venta) donde la ganancia esté en un rango del 10% y el 20% */
SELECT
    dp."ProductKey",
    dp."ProductLabel",
    dp."ProductName",
    dp."UnitPrice",
    dp."UnitCost"
FROM
    l1_dim_product dp
WHERE (dp."UnitPrice" - dp."UnitCost") >= dp."UnitCost" * 1.10 AND
      (dp."UnitPrice" - dp."UnitCost") <= dp."UnitCost" * 1.20;

	  
/* Analice las ventas del año 2007 actuales y a posterior calcule cuál sería la ganancia si aplicaramos un descuento 15% superior al que fue aplicado originalmente  (Mostrar las columnas que considere importante para el análisis) (Bajar a excel los resultados para sumarizar y comparar) */

SELECT 
    fs."DateKey",
    fs."SalesAmount",
    fs."TotalCost",
    fs."DiscountAmount",
    fs."ProductKey",
    fs."SalesAmount" - fs."TotalCost" - fs."DiscountAmount"  ganancia_sin_15,
    fs."SalesAmount" - fs."TotalCost" - (fs."DiscountAmount" * 1.15)  ganancia_con_15
FROM l1_fact_sales fs
WHERE fs."DateKey" LIKE '%2007%';

        
-- EJERCICIO OPERADORES LOGICOS --
/*Muestre los productos de la tabla dimproducto cuya color sea Blanco, Azul o Negro. Cuya ganancia sea superior al 100 y que hayan estado disponibles para la venta despues desde el año 2008 */

SELECT  dp."ProductKey", 
        dp."ProductLabel", 
        dp."ProductName", 				
        dp."ColorName", 
        (dp."UnitPrice" - dp."UnitCost") / dp."UnitCost" * 100 ganancia,
        TO_DATE(dp."AvailableForSaleDate", 'DD-MM-YYYY') AS fecha_disponible_venta
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE (dp."ColorName" = 'Blanco' OR
	  dp."ColorName" = 'Azul' OR
      dp."ColorName" = 'Negro') AND
      dp."UnitPrice" - dp."UnitCost" / dp."UnitCost" > 1
AND TO_DATE(dp."AvailableForSaleDate", 'DD-MM-YYYY') > '2008-01-01';

/*Muestre los productos de la tabla dimproducto cuya clase sea “Normal” y su color sea Azul. O si el color es diferente a azul que la clase sea diferente a normal*/
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."ColorName", dp."ClassName"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE (dp."ColorName" = 'Azul' AND
	  dp."ClassName" = 'Normal') OR
      (dp."ColorName" != 'Azul' AND
	  dp."ClassName" != 'Normal');

/*Muestre las ventas de la tabla factsales cuya cantidad vendida sea igual o mayor a 20
 o que el precio unitario sea menor a 15 pero que en ninguno de los casossean del canal 1 o del canal 3*/
SELECT fs."DateKey", fs."SalesAmount", fs."SalesQuantity", fs."UnitPrice", fs."channelKey"
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE (fs."SalesQuantity" >= 20 OR
	  fs."UnitPrice" < 15) AND
      fs."channelKey" != 1 AND
      fs."channelKey" != 3;
 
/*Muestre las tiendas que no estén activas para el código postal 97001 donde el tipo de Store sea diferente a "Tienda"*/
SELECT ds."StoreKey", ds."StoreName",  ds."StoreType", ds."ZipCode", ds."Status", ds.*
FROM jupi_digital.LANDING_ZONE.l1_dim_store ds
WHERE ds."ZipCode" = 97001
AND ds."Status" != 'Activado'
AND ds."StoreType" != 'Tienda';


-- EJERCICIO LIKE --
/*Muestre los productos de la tabla dimproducto que contengan en el nombre del producto la palabra Reproductor y que esten disponibles para la venta*/
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."Status"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE dp."ProductName" LIKE '%Reproductor%'
AND dp."Status" LIKE 'A%';

/*Muestre los productos de la tabla dimproducto cuya código de producto (ProductLabel) comience con 01010 donde el color comience con A o E*/
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."ColorName"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE (dp."ProductLabel" LIKE '01010%') AND
       dp."ColorName" LIKE 'A%' OR
       dp."ColorName" LIKE 'E%';

/*Muestre los almacenes de la tabla dimstore cuya clave geográfica comience con 9 termine en 5 
y su longitud no exceda los tres caracteres*/

SELECT ds."StoreKey", ds."StoreName",  ds."StoreType", ds."GeographyKey", ds."Status"
FROM jupi_digital.LANDING_ZONE.l1_dim_store ds
WHERE ds."GeographyKey" LIKE '9_5';

/*Muestre los almacenes de la tabla dimstore que correspondan a la dirección que se encuentre en Citycenter para cualquiera de sus direcciones*/
SELECT ds."StoreKey", ds."StoreName",  ds."StoreType", ds."AddressLine1", ds."AddressLine2"
FROM jupi_digital.LANDING_ZONE.l1_dim_store ds
WHERE ds."AddressLine1" LIKE '%Citycenter%' OR
	  ds."AddressLine2" LIKE '%Citycenter%';

/*Muestre los productos cuya color comience con la letra P o con la letra R y termine con la letra A*/
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."ColorName"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE dp."ColorName" LIKE 'P%a' OR dp."ColorName" LIKE 'R%a';

-- EJERCICIO IN --
/*Muestre las ventas realizadas cuyas cantidades compradas sean 1, 5, 10 o 50*/
SELECT fs."SalesKey", fs."DateKey", fs."SalesAmount", fs."SalesQuantity"
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE fs."SalesQuantity" IN (1, 5, 10, 50);

/* Muestre los productos cuyo color corresponde a un color primario*/
SELECT dp."ProductKey", dp."ProductLabel", dp."ProductName", dp."ColorName"
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE dp."ColorName" IN ('Rojo','Azul', 'Amarillo');

/*Muestre las ventas de los almacenes 200 y 310, donde la cantidad vendida sea mayor a 20 y menor a 50*/
SELECT fs."SalesKey", fs."DateKey", fs."SalesAmount", fs."SalesQuantity", fs."StoreKey"
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE  fs."SalesQuantity" > 20 AND fs."SalesQuantity" < 50 AND
fs."StoreKey" IN (200,310);


/*Muestre los almacenes que estan activos y cuya clave sea 301, 308, 310*/
SELECT ds."StoreKey", ds."StoreName",  ds."StoreType", ds."Status"
FROM jupi_digital.LANDING_ZONE.l1_dim_store ds
WHERE ds."Status" LIKE 'A%'
AND ds."StoreKey" IN (301, 308, 310);

/*Muestre las ventas de las promociones 1 o 22 cuya ganancia sea mayor o igual a 100 porciento pero que no correspondan al canal 2
*/
SELECT 
    fs."SalesKey",
    fs."DateKey",
    fs."SalesAmount",
    fs."SalesQuantity",
    fs."UnitPrice", 
    fs."UnitCost",
    fs."StoreKey",
    ((fs."UnitPrice" - fs."UnitCost") / fs."UnitCost") * 100 ganancia,
    fs."channelKey"
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE
    (fs."PromotionKey" IN (1 , 22)
        OR (fs."UnitPrice" - fs."UnitCost") / fs."UnitCost" >= 1)
        AND fs."channelKey" != 2;
        
-- EJERCICIO BETWEEN--
/*Muestre las ventas realizadas entre el 01/01/2008 y el 01/07/2008*/
SELECT 
    fs."SalesKey",
    fs."DateKey",
    fs."SalesAmount",
    fs."SalesQuantity",
    fs."UnitPrice", 
    fs."UnitCost",
    fs."StoreKey",
    (fs."UnitPrice" - fs."UnitCost") / fs."UnitCost" ganancia,
    fs."channelKey"
FROM jupi_digital.LANDING_ZONE.l1_fact_sales fs
WHERE fs."DateKey" BETWEEN '2008-01-01' AND '2008-07-01';

/*Muestre los almacenes cuya cantidad de empleados varia entre 100 y 200 personas, 
donde el área de venta no supere los 500 m2  y su estado evidencie que esta activo.*/
SELECT ds."StoreKey", ds."StoreName",  ds."StoreType", ds."GeographyKey", ds."Status", ds."SellingAreaSize", ds."EmployeeCount"
FROM jupi_digital.LANDING_ZONE.l1_dim_store ds
WHERE ds."Status" = 'Activado'
AND ds."EmployeeCount" BETWEEN 100 AND 200
AND ds."SellingAreaSize" <= 500;


/* Muestre los productos de la tabla dimproduct que estuvieron disponibles para la venta el 01/05/2008 */
SELECT dp."ProductKey", dp."ProductName", dp."UnitPrice", dp."UnitCost",  (dp."UnitPrice"-dp."UnitCost")/dp."UnitCost" ganancia
FROM jupi_digital.LANDING_ZONE.l1_dim_product dp
WHERE '2008-05-01' BETWEEN TO_TIMESTAMP(dp."AvailableForSaleDate", 'MM/DD/YYYY HH:MI:SS AM') 
AND COALESCE(TO_TIMESTAMP(dp."StopSaleDate", 'MM/DD/YYYY HH:MI:SS AM'),'2023-07-01');


-- EJERCICIO IS NULL / IS NOT NULL / LEN --


/*Verifique los registros de la tabla dimstore para que cuando existe una fecha de cierre del store exista tambien la razon de cierre o a la inversa, mostrar (store, nombre, tipo, fecha cierre, razon)*/
SELECT ds."StoreKey", ds."StoreName", ds."StoreType", ds."CloseReason", ds."CloseDate"
FROM l1_dim_store ds
WHERE (ds."CloseReason" IS NOT NULL AND ds."CloseDate" IS NULL) OR
(ds."CloseReason" IS NULL AND ds."CloseDate" IS NOT NULL);

      
/*Muestre los productos que no tengan información en las columnas ImageURL o ProductURL, 
donde el precio de venta esté en el rango de los 100 a 200 y el stock del producto sea medio o bajo.
Listar (producto, nombre, precio unitario, precio costo, ganancia, imageurl, producturl, tipo de stock)*/
SELECT 
    dp."ProductKey",
    dp."ProductName",
    dp."UnitPrice",
    dp."UnitCost",
    (dp."UnitPrice" - dp."UnitCost") / dp."UnitCost" ganancia,
    dp."ImageURL",
    dp."ProductURL",
    dp."StockTypeName"
FROM
    l1_dim_product dp
WHERE
    (dp."ImageURL" IS NULL
        OR dp."ProductURL" IS NULL)
        AND dp."UnitPrice" BETWEEN 100 AND 200
        AND dp."StockTypeName" IN ('Medio' , 'Bajo');


-- EJERCICIOS CASE --
/*Clusterizar los valores de costo unitario en tres rango 0 a 10 – Bajo Costo > 10 a 300 Accesible, > 300 a 9999 Caro*/
SELECT fs."ProductKey", 
	   CASE WHEN fs."UnitCost" >= 0 AND fs."UnitCost" <= 10 THEN 'Bajo Costo'
		    WHEN fs."UnitCost" > 10 AND fs."UnitCost" <= 300 THEN 'Accesible'
            WHEN fs."UnitCost" > 300 and fs."UnitCost" <= 9999 THEN 'Caro' END rango_costo,
	  fs."UnitCost"
FROM l1_fact_sales fs;

-- SE PUEDE USAR DIMPRODUCT
SELECT dp."ProductKey", 
       dp."ProductName", 
	   CASE WHEN dp."UnitCost" >= 0 AND dp."UnitCost" <= 10 THEN 'Bajo Costo'
		    WHEN dp."UnitCost" > 10 AND dp."UnitCost" <= 300 THEN 'Accesible'
            WHEN dp."UnitCost" > 300 and dp."UnitCost" <= 9999 THEN 'Caro' END rango_costo,
	  dp."UnitCost"
FROM l1_dim_product dp;


/*Sobre la tabla dim_customer, segmentar los clientes por años de nacimiento de la siguiente manera
Del 40 al 49 colocar “Los 40s”
Del 50 al 59 colocar “Los 50s”
y así sucesivamente
Si existen registros con años menores a 40 solo colocar “Otros”
*/

SELECT YEAR(dc."BirthDate") "Año",
       CASE WHEN YEAR(dc."BirthDate") BETWEEN 1940 AND 1949 THEN 'Los del 40s'
            WHEN YEAR(dc."BirthDate") BETWEEN 1950 AND 1959 THEN 'Los del 50s'
            WHEN YEAR(dc."BirthDate") BETWEEN 1960 AND 1969 THEN 'Los del 60s'
            WHEN YEAR(dc."BirthDate") BETWEEN 1970 AND 1979 THEN 'Los del 70s'
            WHEN YEAR(dc."BirthDate") BETWEEN 1980 AND 1989 THEN 'Los del 80s'
            WHEN YEAR(dc."BirthDate") BETWEEN 1990 AND 1999 THEN 'Los del 90s'
       ELSE 'Otros' END Decadas
FROM l1_dim_customer dc;

      
-- EJERCICIO OPERADORES LOGICOS --
/* Muestre las ventas que tengan costo unitario o precio unitario mayor a 500, donde la cantidad vendida esté en el rango de 5 a 10, pero no correspondan a los almacenes 143, 166 y 199. Listar fecha, total venta, cantidad vendida, precio unitario, costo unitario, almacen, porcentjae ganancia, canal*/
SELECT 
    fs."SalesKey",
    fs."DateKey",
    fs."SalesAmount",
    fs."SalesQuantity",
    fs."UnitPrice",
    fs."UnitCost",
    fs."StoreKey",
    ((fs."UnitPrice" - fs."UnitCost") / fs."UnitCost") * 100 porc_ganancia,
    fs."channelKey"
FROM
    l1_fact_sales fs
WHERE
    (fs."UnitCost" > 500 OR fs."UnitPrice" > 500)
        AND fs."SalesQuantity" BETWEEN 5 AND 10
        AND fs."StoreKey" NOT IN (143 , 166, 199);



/* Muestre los productos manufacturados en Contoso, Ltd o Wide World Importers, y que el tipo de clase sea Deluxe. Donde los colores de los productos no sean rosa o amarillo y que tenga datos en la columna Weight. Listar producto, nombre, precio unitario, costo, porcentaje ganancia, fabricante, clase, color, peso */

SELECT dp."ProductKey",
    dp."ProductName",
    dp."UnitPrice",
    dp."UnitCost",
    ((dp."UnitPrice" - dp."UnitCost") / dp."UnitCost") * 100 Porc_Ganancia,
    dp."Manufacturer",
    dp."ClassName",
    dp."ColorName",
    dp."Weight"
FROM l1_dim_product dp
WHERE dp."Manufacturer" IN ('Contoso, Ltd','Wide World Importers')
AND dp."ClassName" = 'Deluxe'
AND dp."ColorName" NOT IN ('Rosa','Amarillo')
AND dp."Weight" IS NOT NULL;

-- EJERCICIO ORDER BY  --

/*Muestre los productos de la tabla dimproducto que contengan en el nombre del producto la palabra Reproductor y que ya estén disponibles para la venta. Ordenados por el nombre del producto y el color. Listar producto, nombre, color, precio unitario, costo*/
SELECT 
    dp."ProductKey",
    dp."ProductName",
    dp."ColorName",
    dp."UnitPrice",
    dp."UnitCost",
    dp."AvailableForSaleDate"
FROM
    l1_dim_product dp
WHERE dp."ProductName" like '%Reproductor%'
AND TO_TIMESTAMP(dp."AvailableForSaleDate", 'MM/DD/YYYY HH:MI:SS AM') <= CURRENT_DATE()
ORDER BY dp."ProductName", dp."ColorName";

/*Muestre los productos fabricados en Contoso, Ltd o Wide World Importers, y 
que el tipo de clase sea Deluxe. Donde los colores de los productos no sean rosa o amarillo 
y que tenga datos en la columna Weight ordenados por código de prodcuto de forma descendente. Listar producto, nombre, precio unitario, costo, fabricante, clase, color y peso*/

SELECT dp."ProductKey",
    dp."ProductName",
    dp."UnitPrice",
    dp."UnitCost",
    dp."Manufacturer",
    dp."ClassName",
    dp."ColorName",
    dp."Weight"
FROM l1_dim_product dp
WHERE dp."Manufacturer" IN ('Contoso, Ltd','Wide World Importers')
AND dp."ClassName" = 'Deluxe'
AND dp."ColorName" NOT IN ('Rosa','Amarillo')
AND dp."Weight" IS NOT NULL
ORDER BY dp."ProductKey" DESC;

/*Muestre las ventas realizadas entre el 01/01/2008 y el 01/07/2008. Si el canal es igual a 1 no puede ser un almacen cuyo codigo sea par, por el contrario, si el canal es distinto de un el codigo de almacen tiene que ser par. Ordene por canal, almacen en forma ascendente 
y por monto de la venta en forma descendente. Listar fecha, total venta, cantidad vendida, almacen, canal*/
SELECT 
    fs."DateKey",
    fs."SalesAmount",
    fs."SalesQuantity",
    fs."StoreKey",
    fs."channelKey"
FROM
    l1_fact_sales fs
WHERE fs."DateKey" BETWEEN '2008-01-01' AND '2008-07-01' AND
(fs."channelKey" = 1 AND MOD(fs."StoreKey",2) = 0) OR (fs."channelKey" != 1 AND MOD(fs."StoreKey",2) != 0)
ORDER BY fs."channelKey" ASC, fs."StoreKey" ASC, fs."SalesAmount" DESC;

/*Muestre las ventas de los almacenes 200 y 310, donde la cantidad vendida sea mayor a 20 y menor a 50, 
 Ordene los registros por cantidad vendida en forma descendente y por fecha de venta en forma ascendente. Listar fecha, total venta, cantidad vendida, almacen y canal
*/
SELECT 
    fs."DateKey",
    fs."SalesAmount",
    fs."SalesQuantity",
    fs."StoreKey",
    fs."channelKey"
FROM
    l1_fact_sales fs
WHERE fs."SalesQuantity" BETWEEN 21 AND 49
        AND fs."StoreKey" IN (200,310)
ORDER BY fs."SalesQuantity" DESC, fs."DateKey" ASC;


-- EJERCICIOS FUNCIONES DE AGRUPAMIENTO --
/*Calcular la cantidad de registros de ventas que tengan costo unitario o precio unitario mayor a 500, 
donde la cantidad vendida este en el rango de 5 a 10, pero no correspondan a los almacenes 143, 166 y 199.*/
SELECT 
    COUNT(1) cantidad
FROM
    l1_fact_sales fs
WHERE
    (fs."UnitCost" > 500 OR fs."UnitPrice" > 500)
        AND fs."SalesQuantity" BETWEEN 5 AND 10
        AND fs."StoreKey" NOT IN (143 , 166, 199);

/*Calcular la cantidad de registros de la tabla dimproduct cuyo precio tiene una ganancia que va desde el 50% al 100% 
y que el producto no sea manufacturado por Wide World Importers*/
SELECT COUNT(1) cantidad
FROM l1_dim_product dp
WHERE dp."Manufacturer" != 'Wide World Importers' 
AND  (dp."UnitPrice"-dp."UnitCost")/dp."UnitCost" BETWEEN 0.5 AND 1; 

 /*Calcular la cantidad de ventas realizadas en los almacenes 307 y 199 que hayan tenido una ganancia superior al 100%.
*/
SELECT COUNT(1) cantidad
FROM  l1_fact_sales fs
WHERE (fs."UnitPrice" - fs."UnitCost") / fs."UnitCost" >= 1 AND fs."StoreKey" IN (199,307);

/*Calcular la cantidad y el total de ventas que tengan costo unitario o precio unitario mayor a 500, donde 
la cantidad vendida este en el rango de 5 a 10, pero no correspondan a los almacenes 143, 166 y 199.*/
SELECT 
    COUNT(1) cantidad,
    SUM(fs."SalesAmount") total_ventas
FROM
    l1_fact_sales fs
WHERE
    (fs."UnitCost" > 500 OR fs."UnitPrice" > 500)
        AND fs."SalesQuantity" BETWEEN 5 AND 10
        AND fs."StoreKey" NOT IN (143 , 166, 199);

/*Calcular la cantidad de registros y la suma de los precios de venta de la tabla dimproduct de 
aquellos productos cuyo precio tiene una ganancia que va desde el 50% al 100% 
y que el producto no sea manufacturado por Wide World Importers*/

SELECT COUNT(1) cantidad,
SUM(dp."UnitPrice") suma_precios
FROM l1_dim_product dp
WHERE dp."Manufacturer" != 'Wide World Importers' 
AND  (dp."UnitPrice"-dp."UnitCost")/dp."UnitCost" BETWEEN 0.5 AND 1; 


/* Calcular la cantidad y el total de ventas realizadas en los almacenes 307 y 199 que hayan tenido una ganancia superior al 100% para el año 2009
*/
SELECT COUNT(1) cantidad,
	   SUM(fs."SalesAmount") total_ventas
FROM  l1_fact_sales fs
WHERE (fs."UnitPrice" - fs."UnitCost") / fs."UnitCost" >= 1 AND fs."StoreKey" IN (199,307)
AND fs."DateKey" BETWEEN '2009-01-01' AND '2009-12-31';


/* Calcular el costo y precio mínimo y máximo de los productos quesu tipo de clase sea Normal */
SELECT MIN(dp."UnitPrice") precio_min, MAX(dp."UnitPrice") precio_max, MIN(dp."UnitCost") costo_min, MAX(dp."UnitCost") costo_max
FROM l1_dim_product dp
WHERE dp."ClassName" = 'Normal';

/*Calcular el importe mínimo y máximo de las ventas de los almacenes que están en el rango 200 a 300 
y que no correspondan al año 2010
 */
 SELECT MIN(fs."SalesAmount") minima_venta, MAX(fs."SalesAmount") maxima_venta
 FROM l1_fact_sales fs
 WHERE fs."StoreKey" BETWEEN 200 AND 300
 AND fs."DateKey" NOT LIKE '2010%';
 
 /*Calcular el promedio de unidades vendidas en el año 2008*/
 SELECT AVG(fs."SalesQuantity") unidades_vend_prom
 FROM l1_fact_sales fs
 WHERE fs."DateKey" LIKE '2008%';
 
/*Calcular la ganancia promedio sobre el total de las ventas realizadas en los primeros de 
los semestres de los años 2007,2008 y 2009*/
SELECT AVG(fs."SalesAmount"-(fs."SalesQuantity"*fs."UnitCost")) ganancia_prom
FROM l1_fact_sales fs
WHERE fs."DateKey" BETWEEN '2007-01-01' AND '2007-06-30' OR
	  fs."DateKey" BETWEEN '2008-01-01' AND '2008-06-30' OR
      fs."DateKey" BETWEEN '2009-01-01' AND '2009-06-30';
      
      
/*Calcular el promedio de ventas histórico de la compañía*/
SELECT AVG(fs."SalesAmount") venta_prom
FROM l1_fact_sales fs; 

-- EJERCICIO GROUP BY --
/*Calcular el promedio de unidades vendidas por año*/
SELECT EXTRACT(year FROM fs.datekey) año, AVG(fs.salesquantity) cant_prom
FROM factsales fs
GROUP BY EXTRACT(year FROM fs.datekey);

/*Calcular la ganancia promedio de las ventas realizadas por store y por año*/
SELECT EXTRACT(year FROM fs.datekey) año, fs.StoreKey, avg(fs.SalesAmount-(fs.SalesQuantity*fs.UnitCost)) ganancia_prom
FROM spanish.factsales fs
GROUP BY año,fs.StoreKey;

USE spanish;

/*Calcular el año con menor venta en la compañía*/
SELECT EXTRACT(year FROM fs.datekey) año, SUM(fs.salesamount) tot_venta
FROM factsales fs
GROUP BY año
ORDER BY tot_venta ASC
LIMIT 1;

/*Calcular el top five de los store con mayor cantidad de ventas*/
SELECT fs.StoreKey, COUNT(1) cant_ventas
FROM spanish.factsales fs
GROUP BY fs.StoreKey
ORDER BY cant_ventas DESC
LIMIT 5;


/*Calcular el top five de los store con menor ganancia*/
SELECT fs.StoreKey, sum(fs.SalesAmount-fs.TotalCost) ganancia
FROM spanish.factsales fs
GROUP BY fs.StoreKey
ORDER BY ganancia 
LIMIT 5;

/*Calcular el promedio de ventas del año 2009 de los tres stores con mayor venta en ese mismo año. Para los productos cuyp código sea menor a 50*/
SELECT fs.StoreKey, AVG(fs.SalesAmount) prom_venta, SUM(fs.SalesAmount) total_ventas
FROM spanish.factsales fs
WHERE EXTRACT(YEAR FROM fs.datekey) = 2009 AND fs.productkey < 50
GROUP BY fs.StoreKey
ORDER BY total_ventas DESC
LIMIT 3;

--  EJERCICIO 17 --
/*Calcular la cantidad de unidades vendidas por año, por store, solo si el mismo supera el 10,000 de unidades. 
Donde el channel key sea igual a 1*/
SELECT EXTRACT(YEAR FROM fs.datekey) año, fs.StoreKey, SUM(fs.SalesQuantity) cant_vendida
FROM spanish.factsales fs
WHERE fs.channelKey = 1
GROUP BY EXTRACT(YEAR FROM fs.datekey), fs.StoreKey
HAVING SUM(fs.SalesQuantity) > 10000;

/*Calcular la ganancia promedio de las ventas realizadas por store y por año para aquellos store en el rango de 200 a 300 
y cuya ganancia promedio supera los 2000*/
SELECT fs.StoreKey, EXTRACT(YEAR FROM fs.datekey) año,  AVG(fs.SalesAmount - (fs.SalesQuantity*fs.UnitCost)) ganancia_prom
FROM spanish.factsales fs
WHERE fs.StoreKey BETWEEN 200 AND 300
GROUP BY fs.StoreKey, EXTRACT(YEAR FROM fs.datekey)
HAVING AVG(fs.SalesAmount - (fs.SalesQuantity*fs.UnitCost)) > 2000;


/*Calcular la menor venta de cada store por año en la compañía, solo para aquellos registros cuyo mínimo de venta se encuentre entre 0 y 10
Ordenar cada una de las consultas por año y store en caso de corresponder*/
SELECT fs.StoreKey, EXTRACT(YEAR FROM fs.datekey) año,  MIN(fs.SalesAmount) menor_venta
FROM spanish.factsales fs
GROUP BY fs.StoreKey, EXTRACT(YEAR FROM fs.datekey)
HAVING  MIN(fs.SalesAmount) BETWEEN 0 AND 10
ORDER BY fs.StoreKey, año;

-- EJERCICIOS 18 --
/*Clusterizar los valores de costo unitario en tres rango 0 a 10 – Bajo Costo > 10 a 300 Accesible, > 300 a 9999 Caro*/
SELECT fs.productkey, 
	   CASE WHEN fs.UnitCost >= 0 AND fs.UnitCost <= 10 THEN 'Bajo Costo'
		    WHEN fs.UnitCost > 10 AND fs.UnitCost <= 300 THEN 'Accesible'
            WHEN fs.UnitCost > 300 and fs.UnitCost <= 9999 THEN 'Caro' END rango_costo,
	  fs.UnitCost
FROM spanish.factsales fs;

-- SE PUEDE USAR DIMPRODUCT
SELECT dp.productkey, 
	   dp.ProductName,
	   CASE WHEN dp.UnitCost >= 0 AND fs.UnitCost <= 10 THEN 'Bajo Costo'
		    WHEN fs.UnitCost > 10 AND fs.UnitCost <= 300 THEN 'Accesible'
            WHEN fs.UnitCost > 300 and fs.UnitCost <= 9999 THEN 'Caro' END rango_costo,
	  fs.UnitCost
FROM spanish.dimproduct fs;


/*Si tuviera que establecer cuatro rangos uniformes para hacer la categorización de un producto por su precio como lo haría.
.*/

select
		min(dp.UnitPrice) as Minimo, 
	   (avg(dp.UnitPrice) - min(dp.UnitPrice))/2 rang_int_1,
       avg(dp.UnitPrice) as Promedio,
       (max(dp.UnitPrice)-avg(dp.UnitPrice))/2 rang_int_2,
       max(dp.UnitPrice)as Maximo
       from spanish.dimproduct dp;
       
select 
       CASE WHEN dp.UnitPrice < (avg(dp.UnitPrice) - min(dp.UnitPrice))/2 then 'rango1'
       WHEN dp.UnitPrice < avg(dp.UnitPrice) then 'rango 2'
       WHEN dp.UnitPrice <  (max(dp.UnitPrice)-avg(dp.UnitPrice))/2 then 'rango 3'
       else 'rango 4' end distribucion/*,
       count(1) cant*/
from spanish.dimproduct dp
group by CASE WHEN dp.UnitPrice < (avg(dp.UnitPrice) - min(dp.UnitPrice))/2 then 'rango1'
       WHEN dp.UnitPrice < avg(dp.UnitPrice) then 'rango 2'
       WHEN dp.UnitPrice <  (max(dp.UnitPrice)-avg(dp.UnitPrice))/2 then 'rango 3'
       else 'rango 4' end;

/*Sobre la tabla dimaccounts, segmentar la columna accountname de la siguiente manera:
	- Los valores que comiencen con los caracteres ‘ING’ corresponden a ingresos
	- Los valores que comiencen con los caracteres ‘GAS’ corresponden a gastos
	- Los valores que comiencen con los caracteres ‘COS’ o ‘PER’ corresponden a pérdidas
	- Los valores que comiencen con otros caracteres corresponden a otros gastos
*/

SELECT da.AccountName, da.ValueType,
	   CASE WHEN da.AccountName LIKE 'Ing%' THEN 'Ingresos'
		    WHEN da.AccountName LIKE 'Gas%' THEN 'Gastos'
            WHEN da.AccountName LIKE 'Cos%' OR da.AccountName LIKE 'Per%' THEN 'Pérdidas'
            ELSE 'Otros gastos' END segmentacion
FROM spanish.dimaccount da;

-- EJERCICIO 19 -- 
/*Mostrar los valores diferentes para la columna cantidad vendida de la tabla factsales.*/
SELECT DISTINCT fs.SalesQuantity
FROM spanish.factsales fs;

/* Mostrar los valores diferentes para la columna colores del producto y tamaño de la tabla dimproduct ordenados por color y tamaño para aquellos productos que tengan completa las columnas*/
SELECT DISTINCT dp.ColorName, dp.Size
FROM spanish.dimproduct dp
WHERE  dp.ColorName IS NOT NULL AND dp.size IS NOT NULL
ORDER BY dp.ColorName, dp.size;

/* Mostrar los valores diferentes de continentes y ciudades de la tabla dimgeography,
 solo para los casos donde este completo el nombre de la ciudad y la misma no empiece con una vocal. 
 */
 SELECT DISTINCT
    dg.ContinentName, dg.CityName
FROM
    spanish.dimgeography dg
WHERE
    dg.CityName IS NOT NULL AND 
    dg.CityName != 'NULL' -- ERROR EN LA BASE ESTA CARGADA LA PALABRA NULL NO ES QUE EL CAMPO SEA NULL
        AND (dg.CityName NOT LIKE 'A%'
        AND dg.CityName NOT LIKE 'E%'
        AND dg.CityName NOT LIKE 'I%'
        AND dg.CityName NOT LIKE 'O%'
        AND dg.CityName NOT LIKE 'U%');


-- EJERCICIO 21 --
/* Mostrar cantidad vendida, el importe de venta de la tabla fact sales junto con la descripción, clase y etiqueta del producto.*/
SELECT fs.SalesQuantity, fs.SalesAmount, fs.ProductKey, dp.ProductName, dp.ClassName, dp.ProductLabel
FROM spanish.factsales fs
INNER JOIN spanish.dimproduct dp ON dp.ProductKey = fs.ProductKey;

/*Mostrar nombre de store, la descripción del producto junto con la cantidad de productos vendidos para los años 2008 y 2009.*/
SELECT ds.StoreDescription, dp.ProductDescription, fs.SalesQuantity
FROM spanish.factsales fs
INNER JOIN spanish.dimproduct dp ON dp.ProductKey = fs.ProductKey
INNER JOIN spanish.dimstore ds ON ds.StoreKey = fs.StoreKey
WHERE fs.DateKey LIKE '2008%' OR fs.DateKey LIKE '2009%';

/* Mostrar el promedio de cantidad vendida y el promedio de importe de ventas por continente, nombre de store. Con agrupación*/
SELECT dg.ContinentName, ds.StoreName, AVG(fs.salesquantity) cant_vendida_prom, AVG(fs.salesamount) importe_venta_prom
FROM factsales fs
LEFT JOIN dimstore ds ON ds.StoreKey = fs.StoreKey
LEFT JOIN dimgeography dg ON dg.GeographyKey = ds.GeographyKey
GROUP BY dg.ContinentName, ds.StoreName; 

/*Mostrar la cantidad y el total de ventas por continente y ciudad. Con agrupación*/
SELECT dg.ContinentName, dg.cityname, COUNT(1) cant_ventas, SUM(fs.salesamount) total_ventas
FROM factsales fs
LEFT JOIN dimstore ds ON ds.StoreKey = fs.StoreKey
LEFT JOIN dimgeography dg ON dg.GeographyKey = ds.GeographyKey
GROUP BY dg.ContinentName, dg.cityname; 

/*Mostrar nombre del store junto con el porcentaje de clientes que compran menos de 3 artículos 
por vez de la tabla factsales. Con agrupación*/
SELECT 
    dm.storename,
    COUNT(1) cant_ventas,
    SUM(CASE
        WHEN fs.salesquantity < 3 THEN 1
        ELSE 0
    END) cant_clt_men_3,
    (SUM(CASE
        WHEN fs.salesquantity < 3 THEN 1
        ELSE 0
    END) / COUNT(1))*100 porc_clt_menos_3
FROM
    factsales fs
        INNER JOIN
    dimstore dm ON dm.storekey = fs.storekey
GROUP BY dm.storename;

use spanish;
/*Mostrar por descripción de producto el top ten de los productos vendidos. Con agrupación */
SELECT dp.productdescription, sum(fs.salesquantity) cant_prod 
FROM factsales fs
JOIN dimproduct dp ON (dp.productkey = fs.productkey)
GROUP BY dp.productdescription
ORDER BY cant_prod DESC
LIMIT 10;

/* Mostrar por nombre de store el top five de almacenes que tienen mayor cantidad de ventas. Con agrupación
 */ 
SELECT ds.StoreName, count(1) cant_ventas
FROM factsales fs
INNER JOIN dimstore ds ON ds.StoreKey = fs.StoreKey
GROUP BY ds.StoreName
ORDER BY cant_ventas DESC
LIMIT 5;

-- EJERCICIO 22 --

/*Mostrar ventas globales (total de ventas) por nombre de continente, nombre de ciudad 
y nombre de store por más que no hayan tenido ventas. Si la consulta tarda en ejecutarse mostrar continente Asia*/
SELECT dg.ContinentName, dg.CityName, ds.StoreName, SUM(fs.SalesAmount) total_ventas
FROM spanish.dimgeography dg
LEFT JOIN spanish.dimstore ds ON dg.GeographyKey = ds.GeographyKey 
LEFT JOIN spanish.factsales fs ON ds.StoreKey = fs.StoreKey
WHERE dg.ContinentName = 'Asia'
GROUP BY dg.ContinentName, dg.CityName, ds.StoreName;


USE spanish;
/*Mostrar por código y nombre de promoción la cantidad de ventas realizadas en las cuales se aplica dicha promoción,
 si no existieren aplicaciones mostrar igual  */
SELECT dp.PromotionKey, dp.PromotionDescription, COUNT(1) cant_vta_con_promo
FROM spanish.dimpromotion dp
LEFT JOIN factsales fs  ON dp.promotionkey = fs.promotionkey
GROUP BY  dp.PromotionKey, dp.PromotionDescription;
 
-- EJERCICIOS 23 --
/* Mostrar nombre, apellido y cantidad de productos comprados con descuento de los consumidores en los stores  
Tienda en línea en Norteamérica de Contoso y  Tienda en línea en Asia de Contoso. Si el cliente no tiene compras mostrar igual, 
utilizar la tabla factonlinesales*/
SELECT 
    dc.FirstName, dc.LastName, COUNT(1) cant_comprada
FROM
    spanish.factonlinesales fos
        RIGHT JOIN
    spanish.dimstore ds ON (ds.storekey = fos.StoreKey)
        AND ds.StoreName IN ('Almacén nº 1 en Seattle de Contoso' , 'Almacén en Kennewick de Contoso')
        RIGHT JOIN
    spanish.dimcustomer dc ON (fos.customerkey = dc.CustomerKey)
GROUP BY dc.FirstName , dc.LastName;

/* Mostrar ventas globales por nombre de continente, nombre de ciudad y nombre de store por más que no hayan tenido ventas. */
SELECT dg.ContinentName, dg.CityName, ds.StoreName, fs.SalesQuantity, SUM(fs.SalesAmount) total_ventas
FROM spanish.dimgeography dg
LEFT JOIN spanish.dimstore ds ON dg.GeographyKey = ds.GeographyKey 
LEFT JOIN spanish.factsales fs ON ds.StoreKey = fs.StoreKey
WHERE dg.ContinentName = 'Asia'
GROUP BY dg.ContinentName, dg.CityName, ds.StoreName;

/* Mostrar por nombre de continente y nombre de promoción la cantidad de ventas y el total de ventas realizadas. Si una promoción no tiene ventas mostrar igual.   
 */
SELECT dp.PromotionKey, dp.PromotionDescription, COUNT(1) cant_vta_con_promo, SUM(fs.salesamount) total_ventas
FROM factsales fs
RIGHT JOIN spanish.dimpromotion dp  ON dp.promotionkey = fs.promotionkey
GROUP BY  dp.PromotionKey, dp.PromotionDescription;

-- EJERCICIOS 25 --
/* Mostrar nombre, apellido y cantidad de productos comprados con descuento de los consumidores de los stores  
Almacén nº 1 en Seattle de Contoso y  Almacén en Kennewick de Contoso, resuelva esta condición con la cláusula where */
SELECT 
    dc.FirstName, dc.LastName, COUNT(1) cant_comprada
FROM
    spanish.dimcustomer dc
        LEFT JOIN
    spanish.factonlinesales fos ON (fos.customerkey = dc.CustomerKey)
        LEFT JOIN
    spanish.dimstore ds ON (ds.storekey = fos.StoreKey)
WHERE
    (fos.DiscountAmount != 0
        OR fos.DiscountAmount IS NULL)
        AND (ds.StoreName IS NULL
        OR ds.StoreName IN  ('Tienda en línea en Asia de Contoso', 'Tienda en línea en Norteamérica de Contoso'))
GROUP BY dc.FirstName , dc.LastName;

/*Mostrar ventas globales por nombre de continente, nombre de ciudad y nombre de store por más que no hayan tenido ventas,
 en caso de tener ventas la transacción debió involucrar más de dos productos, 
 */
 SELECT dg.ContinentName, dg.CityName, ds.StoreName, COUNT(fs.SalesKey) cant_vendida
FROM dimgeography dg
LEFT JOIN dimstore ds ON dg.GeographyKey = ds.GeographyKey
LEFT JOIN factsales fs ON ds.StoreKey = fs.StoreKey 
WHERE fs.SalesQuantity > 2  OR fs.SalesQuantity IS NULL
GROUP BY dg.ContinentName, dg.CityName, ds.StoreName;

-- EJERCICIOS 26 --
/* Mostrar la cantidad de ventas y el total de ventas por año y mes de las tablas factsalesonlines y factsales. 
Agregar una columna que para el caso de que las ventas provengan de la primera tabla muestre ONLINE para la segunda OFFLINE */
SELECT EXTRACT(year FROM fs.datekey) año, EXTRACT(month FROM fs.datekey) mes, COUNT(1) cant_ventas, SUM(salesamount) total_ventas, 'OFFLINE' tipo
FROM factsales fs
GROUP BY EXTRACT(year FROM fs.datekey), EXTRACT(month FROM fs.datekey)
UNION
SELECT EXTRACT(year FROM fos.datekey) año, EXTRACT(month FROM fos.datekey) mes, COUNT(1) cant_ventas, SUM(salesamount) total_ventas, 'ONLINE'
FROM factonlinesales fos
GROUP BY EXTRACT(year FROM fos.datekey), EXTRACT(month FROM fos.datekey);
 
/* Calcular la ganancia promedio de las ventas realizadas en cada uno de los cuatrimestres de los años 2007,2008 y 2009
 para las tablas factsales y factsalesonline. Agregar una columna tipo dependiendo de la tabla idem al punto anterior*/
USE SPANISH;
SELECT EXTRACT(year FROM fs.datekey) año, ccuatrimestre, AVG((fs.SalesAmount-(fs.SalesQuantity*fs.UnitCost))) venta_promedio, 'OFFLINE' tipo
FROM factsales fs
WHERE EXTRACT(year FROM fs.datekey) IN (2007,2008,2009)
GROUP BY EXTRACT(year FROM fs.datekey), EXTRACT(quarter FROM fs.datekey)
UNION
SELECT EXTRACT(year FROM fos.datekey) año, EXTRACT(quarter FROM fos.datekey) año, AVG((fOs.SalesAmount-(fOs.SalesQuantity*fOs.UnitCost))) venta_promedio, 'ONLINE' tipo
FROM factonlinesales fos
WHERE EXTRACT(year FROM fos.datekey) IN (2007,2008,2009)
GROUP BY EXTRACT(year FROM fos.datekey), EXTRACT(quarter FROM fos.datekey);
 
-- EJERCICIO 29 --
/* Seleccionar el código y nombre de los productos de aquellos cuyo nombre de producto contenga 
los siguientes string a  Rep, Radio, Rel, LÁPIZ. Estén escritos en minúsculas, mayúsculas o inticap */
SELECT 
    DP.ProductKey, UPPER(DP.ProductName)
FROM
    spanish.dimproduct DP
WHERE
    UPPER(DP.ProductName) LIKE UPPER('%Rep%')
        OR UPPER(DP.ProductName) LIKE UPPER('%Radio%')
        OR UPPER(DP.ProductName) LIKE UPPER('%Rel%')
        OR UPPER(DP.ProductName) LIKE UPPER('%LÁPIZ%');

/*Mostrar la clave, el nombre, el apellido y el mail de los clientes en mínusculas para aquellos apellidos que comiencen con la letra 
F, Z, S y D.
*/
SELECT 
    DC.CustomerKey,
    DC.FirstName,
    DC.LastName,
    LOWER(DC.EmailAddress) email
FROM
    spanish.dimcustomer DC
WHERE
    LOWER(DC.LastName) LIKE LOWER('F%')
        OR LOWER(DC.LastName) LIKE LOWER('Z%')
        OR LOWER(DC.LastName) LIKE LOWER('S%')
        OR LOWER(DC.LastName) LIKE LOWER('D%');
 
/* Concatenar el apellido y el nombre de los clientes con el siguiente formato APELLIDO EN MAYUSCULA, NOMBRE EN MINUSCULA (separado por coma). Agregar una columna con la longitud de la nueva columna generada.
 */
 SELECT 
    DC.CustomerKey, 
    CONCAT( UPPER(DC.LastName), ',', LOWER(DC.FirstName) ) apellido_nombre, 
    LOWER(DC.FirstName),
    UPPER(DC.LastName),
    LOWER(DC.EmailAddress) email,
    LENGTH(CONCAT( UPPER(DC.LastName), ',', LOWER(DC.FirstName) ))
FROM
    spanish.dimcustomer DC;


-- EJERCICIO 30
/* Consultar los diferentes colores que pueden tener los productos. 
Luego sobre la misma query agregar una columna que rellene con espacios a la derecha al nombre del color hasta completar 
los 15 caracteres, y otra columna que complete con espacios a la izquierda.*/
SELECT 
	RPAD(dp.ColorName,15,' ') as espacios_der_15_total,
    LPAD(dp.ColorName,15,' ') as espacios_izq_15_total
FROM
	spanish.dimproduct as dp
GROUP BY
	dp.ColorName;


/* Luego utilizar sobre esa query las funciones trim, ltrim y rtrim. Comprobar su utilización. 
*/
SELECT 
	TRIM(RPAD(dp.ColorName,15,' ')) as espacios_der_15_total,
    LTRIM(LPAD(dp.ColorName,15,' ')) as espacios_izq_15_total
FROM
	spanish.dimproduct as dp
GROUP BY
	dp.ColorName;
    
-- EJERCICIOS 31 --
/* Seleccionar los productos que contengan en su nombre la cadena MP3 y reemplazarlo por MP4.*/
SELECT dp.ProductKey, dp.ProductName, REPLACE(dp.productName,'MP3','MP4') ProductNameNew
FROM spanish.dimproduct dp
WHERE UPPER(dp.ProductName) LIKE UPPER('%MP3%');

/*Seleccionar todos los clientes cuyo nombre comience con una vocal. Utilizar SUBSTR*/
SELECT 
    DC.FirstName
FROM
    spanish.dimcustomer DC
WHERE
    SUBSTR(DC.FirstName, 1, 1) IN ('A' , 'E', 'I', 'O', 'U');
    
SELECT dc.BirthDate, cast(dc.BirthDate as char)-- DATE_PARSE(cr.fecha_nacimiento,'%Y-%m-%d')    
FROM spanish.dimcustomer dc;
    
/*Mostrar la clave, el nombre, el apellido y el mail de los clientes en minúsculas 
para aquellos apellidos que comiencen con la letra F, Z, S y D.
*/
SELECT 
    DC.CustomerKey,
    LOWER(DC.FirstName) Nombre,
    LOWER(DC.LastName) Apellido
FROM
    spanish.dimcustomer DC
WHERE
    substr(LOWER(DC.LastName),1,1) in ('z','s','d','f');
    
    -- EJERCICIOS 32 --
/* Seleccionar todos los clientes cuyo año de nacimiento sea 1964 y en caso de no tener título colocar la leyenda ‘SIN TITULO’.*/
SELECT 
    DC.CUSTOMERKEY,
    DC.FIRSTNAME,
    DC.LASTNAME,
    DC.BIRTHDATE,
    EXTRACT(YEAR FROM DC.BIRTHDATE) AÑO_NAC,
    coalesce(DC.TITLE,'SIN TITULO') TITULO
FROM
    SPANISH.DIMCUSTOMER DC
WHERE
    EXTRACT(YEAR FROM DC.BIRTHDATE) = 1964;

/* Calcular la edad de los empleados de la compañía.*/
SELECT 
    DE.BirthDate,
    DE.LastName,
    DE.FirstName,
    EXTRACT(YEAR FROM SYSDATE()) - EXTRACT(YEAR FROM de.birthdate) EDAD
   -- datediff()
    
FROM
    spanish.dimemployee DE;

/* Contabilizar la cantidad y el total de ventas por año y mes, agrupar por estos ítems. Utilizar extract*/
SELECT 
    EXTRACT(YEAR FROM FS.DATEKEY) AÑO,
    EXTRACT(MONTH FROM FS.DATEKEY) MES,
    SUM(FS.SALESAMOUNT) TOTAL_VTAS_AÑO_MES,
    COUNT(1)
FROM
    SPANISH.FACTSALES FS
GROUP BY AÑO , MES;

-- EJERCICIO 33 --
/* Mostrar para cada store los siguientes datos de la última venta realizada la data a consultar es la siguiente: fecha de venta, 
producto vendido, cantidad vendida, monto de la venta. */
SELECT fs.StoreKey, ds.StoreName, fs.DateKey, fs.ProductKey, dp.ProductName, fs.SalesQuantity, fs.SalesAmount
FROM spanish.factsales fs
LEFT JOIN spanish.dimproduct dp ON dp.ProductKey = fs.ProductKey
LEFT JOIN spanish.dimstore ds ON ds.StoreKey = fs.StoreKey
WHERE fs.SalesKey = (SELECT MAX(fs1.SalesKey)
			        FROM spanish.factsales fs1
                    WHERE fs1.StoreKey = fs.StoreKey);
                    
/* Mostrar fecha de venta, código de producto, nombre de producto, store, nombre del store, cantidad vendida e importe total 
de la primera venta de cada producto*/

SELECT fs.DateKey, fs.ProductKey, dp.ProductName, fs.StoreKey, ds.StoreName, fs.SalesQuantity, fs.SalesAmount
FROM spanish.factsales fs
INNER JOIN spanish.dimproduct dp ON dp.ProductKey = fs.ProductKey
LEFT JOIN spanish.dimstore ds ON ds.StoreKey = fs.StoreKey
WHERE fs.salesKey = (SELECT MIN(fs1.salesKey)
			        FROM spanish.factsales fs1
                    WHERE fs1.ProductKey = dp.ProductKey);
                    
/* Devolver los datos del producto nombre, label, código y descripción cuya cantidad vendida sea igual 
a la máxima cantidad vendida del canal 1 */
SELECT dp.ProductName, dp.ProductLabel, dp.ProductKey, dp.ProductDescription
FROM dimproduct dp
INNER JOIN factsales fs ON (fs.ProductKey = dp.ProductKey)
WHERE fs.SalesQuantity = (SELECT MAX(fs1.salesquantity)
FROM factsales fs1
WHERE fs1.channelKey = 1);

/* Devolver las promociones con código, nombre, descripción y porcentaje de descuento que se hayan aplicado en ventas en línea (factonlinesales) pero no en venta presencial (factsales)
*/
SELECT 
    dp.PromotionKey,
    dp.PromotionName,
    dp.PromotionDescription,
    (fos.DiscountAmount / fos.SalesAmount) * 100 porc_dto,
    fos.DateKey,
    fos.SalesAmount
FROM
    dimpromotion dp
        INNER JOIN
    factonlinesales fos ON (fos.promotionkey = dp.PromotionKey)
WHERE
    NOT EXISTS( SELECT 
            1
        FROM
            factsales fs
        WHERE
            fs.PromotionKey = dp.PromotionKey
		AND EXTRACT(YEAR FROM fs.datekey) = 2009)
GROUP BY dp.PromotionKey,
    dp.PromotionName,
    dp.PromotionDescription,
    fos.DiscountAmount,
    fos.DateKey,
    fos.SalesAmount;
    
    use spanish;

SELECT DISTINCT fos.promotionkey
FROM factonlinesales fos
EXCEPT 
SELECT DISTINCT fs.promotionkey
FROM factsales fs;
    
 -- EJERCICIO 34
 /* Devolver los productos (nombre, label, código y descripción ) con sus cantidades y montos vendidos 
 para el año 2007, 2008 y 2009. Usar la cláusula WITH*/
 
 WITH 
  prod_2007 AS
  (SELECT fs.productkey, COUNT(1) cant_ventas, SUM(fs.salesamount) total_ventas
  FROM factsales fs
   WHERE EXTRACT(YEAR FROM fs.datekey) = 2007
   GROUP BY fs.productkey),
   prod_2008 AS
  (SELECT fs.productkey, COUNT(1) cant_ventas, SUM(fs.salesamount) total_ventas
  FROM factsales fs
   WHERE EXTRACT(YEAR FROM fs.datekey) = 2008
   GROUP BY fs.productkey),
   prod_2009 AS
  (SELECT fs.productkey, COUNT(1) cant_ventas, SUM(fs.salesamount) total_ventas
  FROM factsales fs
   WHERE EXTRACT(YEAR FROM fs.datekey) = 2009
   GROUP BY fs.productkey)
SELECT dp.productname, dp.productlabel, dp.productkey, dp.productdescription, 2007 ,  prod_2007.cant_ventas, prod_2007.total_ventas, 
2008, prod_2008.cant_ventas, prod_2008.total_ventas, 2009, prod_2009.cant_ventas, prod_2009.total_ventas
FROM dimproduct dp
LEFT JOIN prod_2007 ON (dp.productkey = prod_2007.productkey)
LEFT JOIN prod_2008 ON (dp.productkey = prod_2008.productkey)
LEFT JOIN prod_2009 ON (dp.productkey = prod_2009.productkey);
 
 
/*Obtener los valores mínimo, máximo y promedio del precio unitario (unitprice), establecer 4 rangos uniformes, 
crear categorización para dichos. 
*/

WITH rangos AS
(select min(dp.UnitPrice) as Minimo, 
	   (avg(dp.UnitPrice) - min(dp.UnitPrice))/2 rang_int_1,
       avg(dp.UnitPrice) as Promedio,
       (max(dp.UnitPrice)-avg(dp.UnitPrice))/2 rang_int_2,
       max(dp.UnitPrice)as Maximo
   from spanish.dimproduct dp)
select dp.productkey,
	   dp.ProductName,
	   dp.UnitPrice,
 case when dp.UnitPrice between rg.minimo and rg.rang_int_1 then 'rango1'
	  when dp.UnitPrice between rg.rang_int_1 and rg.promedio then 'rango2'
      when dp.UnitPrice between rg.promedio and rg.rang_int_2 then 'rango3'
      when dp.UnitPrice between rg.rang_int_2 and maximo then 'rango4' end rangos
 from spanish.dimproduct dp
 left join rangos rg ON dp.UnitPrice between rg.minimo and rg.rang_int_1 or
					    dp.UnitPrice between rg.rang_int_1 and rg.promedio or
                        dp.UnitPrice between rg.promedio and rg.rang_int_2 or
                        dp.UnitPrice between rg.rang_int_2 and maximo;
    
    
  with   rango  as
(select min(dp.UnitPrice) min,
	(( max(dp.UnitPrice)-min(dp.UnitPrice))/4) topePrimerCuarto,
    (( max(dp.UnitPrice)-min(dp.UnitPrice))/4)*2 topeSegundoCuarto,
     (( max(dp.UnitPrice)-min(dp.UnitPrice))/4)*3 topeTercerCuarto,
       max(dp.UnitPrice) max
from dimproduct dp)
select case when dp.unitprice between rango.min and rango.topePrimerCuarto then 'Rango1'
            when dp.unitprice between rango.topePrimerCuarto and rango.topeSegundoCuarto then 'Rango2'
            when dp.unitprice between rango.topeSegundoCuarto and rango.topeTercerCuarto then 'Rango3'
            when dp.unitprice between rango.topeTercerCuarto and rango.max then 'Rango4'
            else 'Error'
            end rangoPrecio, dp.UnitPrice, dp.ProductKey, dp.ProductName, rango.*
from dimproduct dp
left join rango on (dp.unitprice between rango.min and rango.max);

-- Ejercicio de prueba para poner un selec en el selec
select dp.UnitPrice, dp.ProductKey, dp.ProductName,
(select avg(fs.UnitPrice) from factsales fs where year(fs.datekey) = 2007) AVG2007,
(select avg(fs.UnitPrice) from factsales fs where year(fs.datekey) = 2008) AVG2008,
(select avg(fs.UnitPrice) from factsales fs where year(fs.datekey) = 2009) AVG2009
from dimproduct dp;

------------------------------

select 
    dp."ProductName",
    split("ProductName",' '),
   array_to_string(split("ProductName",' '),'') as nombre
   
from l1_dim_product as dp;