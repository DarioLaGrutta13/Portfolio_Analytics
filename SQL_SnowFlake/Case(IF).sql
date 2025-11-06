/*Categorizar los valores de costo unitario de la tabla dimproduct en tres rangos 0 a 10 – 
Bajo Costo, >10 a 300 Accesible, >300 a 9999 Caro*/

SELECT
    unitcost,
    CASE
        WHEN 
            0 < unitcost <=  10 THEN 'BAJO COSTO'
            WHEN 
            11 < unitcost <=  300 THEN 'ACCESIBLE'
                WHEN 
                301 < unitcost <=  9999 THEN 'CARO'
    END AS Categoria_costo    
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT;


/*Sobre la tabla dimcustomer, segmentar los clientes por años de nacimiento de la siguiente 
manera
 ○ Del 40 al 49 colocar “Los 40s”
 ○ Del 50 al 59 colocar “Los 50s”
 ○ y así sucesivamente
 ○ Si existen registros con años menores a 40 solo colocar “Otros*/


 SELECT 
TO_DATE(BIRTHDATE, 'DD-MM-YYYY') AS CUMPLEANIOS,
YEAR(CUMPLEANIOS) AS ANIO,
(YEAR(CURRENT_DATE()) - YEAR(TO_DATE(BIRTHDATE, 'DD-MM-YYYY'))) AS EDAD,
CASE 
WHEN (2025 - EDAD) < 40 THEN 'Otros'
    WHEN 40 <= (2025 - EDAD) <= 49 THEN 'Los 40s'
        WHEN 50 <= (2025 - EDAD) <= 59 THEN 'Los 50s'
            WHEN 60 <= (2025 - EDAD) <= 69 THEN 'Los 60s'
                WHEN 70 <= (2025 - EDAD) <= 79 THEN 'Los 70s'
                    WHEN 80 <= (2025 - EDAD) <= 89 THEN 'Los 80s'
                        ELSE 'MAYORES'
                            END Clasificaciones
 FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_CUSTOMER AS cst


/* Ejercicios 15.-
1.  Calcular la cantidad y el total de ventas que tengan costo unitario o precio unitario mayor a 500, donde la cantidad vendida esté en el rango de 5 a 10, pero no correspondan a los almacenes 143, 166 y 199.*/





SELECT 
*
FROM JUPI_DIGITAL.LANDING_ZONE.L1_DIM_PRODUCT;