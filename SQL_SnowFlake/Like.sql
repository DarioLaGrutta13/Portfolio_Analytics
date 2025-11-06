/*Muestre los productos de la tabla L1_DIM_PRODUCT que contengan en el nombre del producto la palabra Reproductor y que estén disponibles para la venta (clave, etiqueta, nombre y estado).*/

SELECT 
        prd.productkey,
        prd.productlabel,
        prd.productname,
        prd.status
FROM jupi_digital.landing_zone.l1_dim_product AS prd 
WHERE productname LIKE '%Reproductor%' AND status = 'Activad';

/*Muestre los productos de la tabla L1_DIM_PRODUCT cuya código de producto (ProductLabel) comience con 01010 donde el color comience con A o E. (clave, etiqueta, nombre y color).*/

SELECT
    productkey,
    productlabel,
    productname,
    colorname
FROM jupi_digital.landing_zone.l1_dim_product 
WHERE productlabel LIKE '01010%' AND (colorname LIKE 'A%' OR colorname LIKE 'E%'); 

/*Muestre los almacenes de la tabla L1_DIM_STORE cuya clave geográfica comience con 9 termine en 5 y su longitud no exceda los tres caracteres (clave, nombre, tipo, clave geográfica y estado)*/

SELECT 
    storekey,
    geographykey,
    storename,
    storetype,
    status
FROM jupi_digital.landing_zone.l1_dim_store
WHERE geographykey LIKE '9_5'; 

/*Muestre los almacenes de la tabla L1_DIM_STORE que correspondan a la dirección que se encuentre en Citycenter para cualquiera de sus direcciones (clave, nombre, tipo y direcciones)*/

SELECT
    storekey,
    storename,
    storetype,
    addressline1,
    addressline2
FROM jupi_digital.landing_zone.l1_dim_store
WHERE addressline1 LIKE '%Citycenter%' OR addressline2 LIKE '%Citycenter%';

/*Muestre los productos L1_DIM_PRODUCT cuya color comience con la letra P o con la A (clave, etiqueta, nombre y color)*/


SELECT 
    productkey,
    productlabel,
    productname,
    colorname
FROM jupi_digital.landing_zone.l1_dim_product
WHERE colorname LIKE 'P%' OR colorname LIKE 'A%';