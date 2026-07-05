/*
================================================================================
INDICES Y ANALISIS DE PERFORMANCE
================================================================================

Objetivo:
Medir el impacto de un indice no agrupado sobre la consulta de evolucion
mensual de ventas y ganancias (JOIN Ventas + Detalle_Ventas + agregacion).

Metodologia (SQL Server Management Studio):
  1. Ejecutar PASO 1 -> revisar pestana Messages (IO/TIME) y plan de ejecucion
  2. Ejecutar PASO 2 -> crear el indice
  3. Ejecutar PASO 3 -> repetir la misma consulta y comparar resultados
  4. Capturar pantallas -> guardar en img/4.indices/

Resultados obtenidos en la prueba:
  | Metrica                          | Sin indice | Con indice |
  |----------------------------------|------------|------------|
  | Lecturas logicas (Detalle_Ventas)| 1.078      | 662        |
  | Tiempo de ejecucion              | 360 ms     | 302 ms     |
  | Plan de ejecucion                | Clustered Index Scan | Index Scan |

Capturas comparativas: img/4.indices/ (01-03 sin indice, 04-06 con indice)
Documentacion: docs/texto indice.txt
================================================================================
*/

USE DistribuidoraMayorista;
GO

-- =============================================================================
-- PASO 1: CONSULTA SIN INDICE
-- Si el indice ya existe de una corrida anterior, descomentar el DROP de abajo.
-- =============================================================================

-- DROP INDEX IF EXISTS IX_Detalle_Ventas_ID_Venta ON Detalle_Ventas;
-- GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT 
    YEAR(v.Fecha_Venta) AS Anio,
    MONTH(v.Fecha_Venta) AS Mes,
    SUM(dv.Subtotal) AS Facturacion_Total,
    SUM(dv.Ganancia) AS Ganancia_Total
FROM Ventas v
JOIN Detalle_Ventas dv ON v.ID_Venta = dv.ID_Venta
WHERE v.Estado_Venta = 'Confirmada'
  AND YEAR(v.Fecha_Venta) BETWEEN 2023 AND 2025
GROUP BY YEAR(v.Fecha_Venta), MONTH(v.Fecha_Venta)
ORDER BY Anio, Mes;
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- =============================================================================
-- PASO 2: CREAR INDICE SOBRE COLUMNA DE JOIN
-- =============================================================================

CREATE NONCLUSTERED INDEX IX_Detalle_Ventas_ID_Venta
ON Detalle_Ventas (ID_Venta);
GO

-- =============================================================================
-- PASO 3: MISMA CONSULTA CON INDICE
-- =============================================================================

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT 
    YEAR(v.Fecha_Venta) AS Anio,
    MONTH(v.Fecha_Venta) AS Mes,
    SUM(dv.Subtotal) AS Facturacion_Total,
    SUM(dv.Ganancia) AS Ganancia_Total
FROM Ventas v
JOIN Detalle_Ventas dv ON v.ID_Venta = dv.ID_Venta
WHERE v.Estado_Venta = 'Confirmada'
  AND YEAR(v.Fecha_Venta) BETWEEN 2023 AND 2025
GROUP BY YEAR(v.Fecha_Venta), MONTH(v.Fecha_Venta)
ORDER BY Anio, Mes;
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

/*
Conclusion:
El indice permite al motor resolver el JOIN sobre Detalle_Ventas sin recorrer
toda la tabla (Clustered Index Scan -> Index Scan), reduciendo lecturas logicas
y tiempo de ejecucion. Ver docs/texto indice.txt e img/4.indices/ para evidencia.
*/
