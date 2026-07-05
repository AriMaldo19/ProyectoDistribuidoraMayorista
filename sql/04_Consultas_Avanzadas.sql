/*
1.
Consulta:
ANALIZAR LA EVOLUCION MENSUAL DE VENTAS Y GANANCIAS ENTRE 2023 Y 2025.

Justificacion:
Permite detectar tendencias de crecimiento, estacionalidad y evaluar si el aumento
de facturacion se traduce en mayor rentabilidad.
*/

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


/*
2.
Consulta:
RANKING DE LOS 10 CLIENTES QUE MAS FACTURAN Y SU GANANCIA ASOCIADA.

Justificacion:
Permite identificar los clientes mas relevantes del negocio en terminos
de facturacion y rentabilidad.
*/

WITH RankingClientes AS (
    SELECT 
        c.ID_Cliente,
        c.Razon_Social,
        SUM(dv.Subtotal) AS Facturacion_Total,
        SUM(dv.Ganancia) AS Ganancia_Total,
        ROW_NUMBER() OVER (ORDER BY SUM(dv.Subtotal) DESC) AS Ranking
    FROM Clientes c
    JOIN Ventas v ON c.ID_Cliente = v.ID_Cliente
    JOIN Detalle_Ventas dv ON v.ID_Venta = dv.ID_Venta
    WHERE v.Estado_Venta = 'Confirmada'
    GROUP BY c.ID_Cliente, c.Razon_Social
)
SELECT *
FROM RankingClientes
WHERE Ranking <= 10
ORDER BY Ranking;


/*
3.
Consulta:
CALCULAR LA RENTABILIDAD PROMEDIO POR TIPO DE COMERCIO.

Justificacion:
Permite comparar el desempeno economico de cada segmento de clientes
y detectar cuales generan mayor margen.
*/

SELECT 
    c.Tipo_Comercio,
    SUM(dv.Subtotal) AS Facturacion_Total,
    SUM(dv.Ganancia) AS Ganancia_Total,
    ROUND(SUM(dv.Ganancia) * 100.0 / SUM(dv.Subtotal), 2) AS Margen_Porcentual
FROM Clientes c
JOIN Ventas v ON c.ID_Cliente = v.ID_Cliente
JOIN Detalle_Ventas dv ON v.ID_Venta = dv.ID_Venta
WHERE v.Estado_Venta = 'Confirmada'
GROUP BY c.Tipo_Comercio
ORDER BY Margen_Porcentual DESC;


/*
4.
Consulta:
COMPARAR PRODUCTOS MAS VENDIDOS VS PRODUCTOS MAS RENTABLES.

Justificacion:
Permite detectar diferencias entre rotacion y rentabilidad,
clave para decisiones de catalogo y promociones.
*/

SELECT 
    p.ID_Producto,
    p.Nombre_Producto,
    SUM(dv.Cantidad_Unidades) AS Unidades_Vendidas,
    SUM(dv.Ganancia) AS Ganancia_Total
FROM Productos p
JOIN Detalle_Ventas dv ON p.ID_Producto = dv.ID_Producto
JOIN Ventas v ON dv.ID_Venta = v.ID_Venta
WHERE v.Estado_Venta = 'Confirmada'
GROUP BY p.ID_Producto, p.Nombre_Producto
ORDER BY Unidades_Vendidas DESC;


/*
5.
Consulta:
ANALIZAR VENTAS MENSUALES POR CATEGORIA DE PRODUCTO.

Justificacion:
Permite detectar patrones estacionales y analizar desempeno historico por categoria.
*/

SELECT 
    cat.Nombre_Categoria,
    YEAR(v.Fecha_Venta) AS Anio,
    MONTH(v.Fecha_Venta) AS Mes,
    SUM(dv.Subtotal) AS Facturacion_Total,
    SUM(dv.Ganancia) AS Ganancia_Total
FROM Categorias cat
JOIN Productos p ON cat.ID_Categoria = p.ID_Categoria
JOIN Detalle_Ventas dv ON p.ID_Producto = dv.ID_Producto
JOIN Ventas v ON dv.ID_Venta = v.ID_Venta
WHERE v.Estado_Venta = 'Confirmada'
GROUP BY cat.Nombre_Categoria, YEAR(v.Fecha_Venta), MONTH(v.Fecha_Venta)
ORDER BY cat.Nombre_Categoria, Anio, Mes;


/*
6.
Consulta:
CLASIFICAR CLIENTES SEGUN FRECUENCIA DE COMPRA.

Justificacion:
Permite segmentar clientes en recurrentes, frecuentes u ocasionales
para estrategias de fidelizacion.
*/

WITH ComprasCliente AS (
    SELECT 
        ID_Cliente,
        COUNT(*) AS Cantidad_Compras
    FROM Ventas
    WHERE Estado_Venta = 'Confirmada'
    GROUP BY ID_Cliente
)
SELECT 
    ID_Cliente,
    Cantidad_Compras,
    CASE 
        WHEN Cantidad_Compras >= 20 THEN 'Recurrente'
        WHEN Cantidad_Compras BETWEEN 5 AND 19 THEN 'Frecuente'
        ELSE 'Ocasional'
    END AS Clasificacion
FROM ComprasCliente
ORDER BY Cantidad_Compras DESC;


