//2. Muestre los productos (producto, nombre y clase) de la tabla L1_DIM_PRODUCT cuya columna CLASSNAME sea igual a Normal

//Tabla de Productos

SELECT
    PRD.PRODUCTDESCRIPTION AS "Descripcion_Producto",
    PRD.PRODUCTNAME,
    PRD.CLASSNAME
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT AS PRD
WHERE PRD.CLASSNAME = 'Normal';

/* '' -> se usa para adentro ingresar una descripcion de campo, mejor dicho el registro dentro
"" las comillas dobles son para ingresar dentro el nombre del campo y si lo defino asi, tengo
que llamarlo siempre con las comillas dobles*/

----------------------------------------------------

/*Muestre los datos de los canales mayores e iguales a 2 de la tabla L1_DIM_CHANNEL (clave y descripción)*/
SELECT
    CHN.CHANNELLABEL,
    CHN.CHANNELDESCRIPTION
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_CHANNEL AS CHN
WHERE CHN.CHANNEKEY >= 2;

/*Muestre los productos de la tabla L1_DIM_PRODUCT cuya columna WEIGHT sea superior a los 4 gramos (clave, etiqueta, nombre y peso)*/

SELECT
    PRD.PRODUCTKEY,
    PRD.PRODUCTNAME,
    PRD.WEIGHT,
    PRD.PRODUCTLABEL
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT AS PRD.
WHERE WEIGHT > 4;

/*Calcule el costo total y el precio total de las ventas del día 05 Abril de 2024 de la tabla L1_FACT_SALES utilizando las columnas de precio por cantidad (fecha, precio y costo)*/

SELECT
    SLS.DATEKEY,
    SLS.UNITCOST,
    SLS.TOTALCOST,
    //SLS.SALESQUANTITY,
    SUM(TOTALCOST) AS TOTALCOST,
    SUM(UNITCOST) AS PRECIOTOTAL
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES AS SLS
WHERE SLS.DATEKEY = '2024-03-05';


/*Calcule cual es la ganancia de las ventas sobre la consulta del punto anterior (fecha, precio, costo y ganancia)*/

SELECT
    SLS.DATEKEY,
    SLS.UNITPRICE,
    SLS.UNITCOST,
    UNITPRICE - UNITCOST AS GANANCIA
    
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES AS SLS
WHERE SLS.DATEKEY = '2024-03-05';

---------------------------------------------------------

//Muestre los registros del 5 al 10 de la tabla Fact Sales
// Luego de la Dim Product muestre los primeros 2 registros


SELECT 
    *
FROM JUPI_DIGITAL.LANDING_ZONE.L1_FACT_SALES
LIMIT 5 //lIMITO A 5 LOS REGISTROS
OFFSET 5; //SALTEO LOS PRIMEROS 5 REGISTROS Y MUESTRO LOS SIGUIENTES


SELECT
    *
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT
LIMIT 2;
-------------------------------------------------------------

