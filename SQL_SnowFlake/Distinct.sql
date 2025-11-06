/*Mostrar los valores diferentes para la columna cantidad vendida de la tabla factsales.*/

SELECT 
        DISTINCT sls.salesquantity
FROM jupi_digital.landing_zone.l1_fact_sales AS sls;

/*Mostrar los valores diferentes para la columna colores del producto y tamaño de la tabla 
dimproduct  ordenados por color y tamaño, para aquellos productos que tengan completa 
las columnas*/

SELECT
    DISTINCT
    prd.colorname,
    prd.size
FROM jupi_digital.landing_zone.l1_dim_product  AS prd;
ORDER BY colorname, size;

/*Mostrar los valores diferentes de continentes y ciudades de la tabla dimgeography, solo 
para los casos donde este completo el nombre de ciudad y la misma no empiece con una 
vocal.*/

SELECT DISTINCT
    geo.cityname,
    geo.continentname
FROM jupi_digital.landing_zone.l1_dim_geography as geo
WHERE cityname NOT LIKE  'A%' 
        AND cityname NOT LIKE  'E%'
        AND cityname NOT LIKE  'I%'
        AND cityname NOT LIKE  'O%'
        AND cityname NOT LIKE  'U%';
