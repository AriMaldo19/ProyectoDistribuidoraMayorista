/*
1.
Consulta:
ANALIZAR LA EVOLUCIÓN MENSUAL DE VENTAS Y GANANCIAS ENTRE 2023 Y 2025.

Justificación:
Permite detectar tendencias de crecimiento, estacionalidad y evaluar si el aumento
de facturación se traduce en mayor rentabilidad.
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

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

