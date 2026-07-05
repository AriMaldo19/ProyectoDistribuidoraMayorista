/*
1.
Consulta 
ANALIZAR UNIDADES TOTALES POR VENTA.

Justificación:
Permite evaluar si el volumen promedio de cada operación es consistente
con un modelo de ventas mayoristas y no minoristas.
*/

SELECT
    AVG(Unidades_Por_Venta) AS Promedio_Unidades_Por_Venta,
    MIN(Unidades_Por_Venta) AS Minimo,
    MAX(Unidades_Por_Venta) AS Maximo
FROM (
    SELECT 
        ID_Venta,
        SUM(Cantidad_Unidades) AS Unidades_Por_Venta
    FROM Detalle_Ventas
    GROUP BY ID_Venta
) ventas_agrupadas;

/*
2.
Consulta:
ANALIZAR ESTADO DE VENTAS POR AÑO (CONFIRMADAS VS CANCELADAS).

Justificación:
Permite evaluar la calidad del proceso comercial a lo largo del tiempo,
comparando la proporción de ventas confirmadas y canceladas por año.
Se incorpora la cantidad de días con actividad comercial para contextualizar
los años incompletos del período analizado.
*/

SELECT 
    YEAR(Fecha_Venta) AS Anio,
    COUNT(*) AS Total_Ventas,
    COUNT(DISTINCT CAST(Fecha_Venta AS DATE)) AS Dias_Con_Ventas,
    -- cantidad de días considerados por año
    SUM(
        CASE 
            WHEN LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada' 
            THEN 1 ELSE 0 
        END
    ) AS Ventas_Confirmadas,
    SUM(
        CASE 
            WHEN LOWER(LTRIM(RTRIM(Estado_Venta))) = 'cancelada' 
            THEN 1 ELSE 0 
        END
    ) AS Ventas_Canceladas,
    CAST(
        SUM(
            CASE 
                WHEN LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada' 
                THEN 1 ELSE 0 
            END
        ) * 100.0 / COUNT(*) 
        AS DECIMAL(10,2)
    ) AS Porcentaje_Confirmadas
FROM Ventas
GROUP BY YEAR(Fecha_Venta)
ORDER BY Anio;

/*
3.
Consulta:
ANALIZAR MÉTODO DE PAGO MÁS UTILIZADO POR AÑO (VENTAS CONFIRMADAS).

Justificación:
Permite analizar la evolución del uso de los distintos medios de pago
a lo largo del tiempo, considerando únicamente ventas efectivamente realizadas
y su impacto en la facturación total.
*/

SELECT 
    YEAR(Fecha_Venta) AS Anio,
    Forma_Pago,
    COUNT(*) AS Cantidad_Ventas,
    SUM(Total_Venta) AS Facturacion_Total
FROM Ventas
WHERE LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada'
-- se consideran solo ventas confirmadas
GROUP BY 
    YEAR(Fecha_Venta),
    Forma_Pago
ORDER BY 
    Anio,
    Facturacion_Total DESC;

/*
4.
Consulta:
ANALIZAR CLIENTES SEGÚN ANTIGÜEDAD EN EL NEGOCIO (RANGOS DETALLADOS).

Justificación:
Permite segmentar la base de clientes según su antigüedad,
mejorando la interpretación del ciclo de vida del cliente.
*/

SELECT
    Antiguedad_Cliente,
    COUNT(DISTINCT ID_Cliente) AS Cantidad_Clientes
FROM (
    SELECT
        ID_Cliente,
        CASE
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 0 AND 2 THEN '0 a 2 años'
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 3 AND 5 THEN '3 a 5 años'
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 6 AND 8 THEN '6 a 8 años'
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 9 AND 11 THEN '9 a 11 años'
            ELSE '12 años o más'
        END AS Antiguedad_Cliente,
        CASE
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 0 AND 2 THEN 1
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 3 AND 5 THEN 2
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 6 AND 8 THEN 3
            WHEN DATEDIFF(YEAR, Fecha_Desde, GETDATE()) BETWEEN 9 AND 11 THEN 4
            ELSE 5
        END AS Orden
    FROM Clientes_Direcciones
    WHERE Fecha_Desde IS NOT NULL
    
    UNION ALL -- Agregamos los rangos faltantes con NULL
    
    SELECT NULL, '0 a 2 años', 1
    UNION ALL SELECT NULL, '3 a 5 años', 2
    UNION ALL SELECT NULL, '6 a 8 años', 3
    UNION ALL SELECT NULL, '9 a 11 años', 4
    UNION ALL SELECT NULL, '12 años o más', 5
) todos_rangos
GROUP BY Antiguedad_Cliente, Orden
ORDER BY Orden;

/*
5.
Consulta:
COMPARAR EL TICKET PROMEDIO POR AÑO.

Justificación:
Permite evaluar la evolución de las ventas promedio a lo largo del tiempo
y detectar efectos de inflación o cambios en el comportamiento de compra.
*/

SELECT 
    YEAR(Fecha_Venta) AS Anio,
    COUNT(*) AS Cantidad_Ventas,
    AVG(Total_Venta) AS Ticket_Promedio
FROM Ventas
WHERE LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada'
GROUP BY YEAR(Fecha_Venta)
ORDER BY Anio;

/*
6.
Consulta:
ANALIZAR VENTAS SEGÚN ESTACIÓN DEL AÑO (HEMISFERIO SUR).

Justificación:
Permite detectar patrones estacionales en la demanda,
optimizando decisiones de stock y planificación comercial
según la época del año en Argentina.
*/

SELECT
    CASE
        WHEN MONTH(Fecha_Venta) IN (12, 1, 2) THEN 'Verano'
        WHEN MONTH(Fecha_Venta) IN (3, 4, 5) THEN 'Otoño'
        WHEN MONTH(Fecha_Venta) IN (6, 7, 8) THEN 'Invierno'
        WHEN MONTH(Fecha_Venta) IN (9, 10, 11) THEN 'Primavera'
    END AS Estacion,
    COUNT(*) AS Cantidad_Ventas,
    SUM(Total_Venta) AS Facturacion
FROM Ventas
WHERE LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada'
GROUP BY
    CASE
        WHEN MONTH(Fecha_Venta) IN (12, 1, 2) THEN 'Verano'
        WHEN MONTH(Fecha_Venta) IN (3, 4, 5) THEN 'Otoño'
        WHEN MONTH(Fecha_Venta) IN (6, 7, 8) THEN 'Invierno'
        WHEN MONTH(Fecha_Venta) IN (9, 10, 11) THEN 'Primavera'
    END
ORDER BY Facturacion DESC;

/*
7.
Consulta:
ANALIZAR DÍAS DEL MES CON MAYOR VOLUMEN DE VENTAS.

Justificación:
Permite identificar los días de mayor actividad comercial,
información útil para planificación de stock y logística.
*/

SELECT 
    DAY(Fecha_Venta) AS Dia_Del_Mes,
    COUNT(*) AS Cantidad_Ventas,
    SUM(Total_Venta) AS Total_Facturado
FROM Ventas
WHERE LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada'
GROUP BY DAY(Fecha_Venta)
ORDER BY Cantidad_Ventas DESC;


