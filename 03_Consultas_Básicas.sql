/*
1.
Consulta
CHEQUEANDO VENTAS POR PRODUCTOS Y PROMEDIO DE UNIDADES VENDIDAS

Justificación:
valida el objeto del negocio (distribuidora mayorista).
Si la mayoría de líneas tienen cantidades muy bajas, el comportamiento se parece más a consumo final que a mayorista.
*/
SELECT 
    AVG(CAST(Cantidad_Unidades AS FLOAT)) AS Promedio_Unidades_Por_Linea,
    MIN(Cantidad_Unidades) AS Minimo,
    MAX(Cantidad_Unidades) AS Maximo
FROM Detalle_Ventas;


/*
2.
Consulta
VERIFICANDO PORCENTAJE TOTAL DE VENTAS CONFIRMADAS

Justificación:
valida la lógica del negocio (mayoría confirmadas)
*/
SELECT 
    COUNT(*) AS Total_Ventas,
    SUM(CASE WHEN Estado_Venta = 'Confirmada' THEN 1 ELSE 0 END) AS Ventas_Confirmadas,
    CAST(SUM(CASE WHEN Estado_Venta = 'Confirmada' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Porcentaje_Confirmadas
FROM Ventas;


/*
3.
Consulta
VERIFICANDO MÉTODO DE PAGO MÁS USADO

Justificación
sirve para tener un análisis comercial más real
*/
SELECT 
    Forma_Pago,
    COUNT(*) AS Cantidad_Ventas
FROM Ventas
GROUP BY Forma_Pago
ORDER BY COUNT(*) DESC;



/*
4.
Consulta
VERIFICANDO CLIENTES CON UNA SOLA COMPRA

Justificación
permite ver clientes perdidos o con 1 sola compra
*/
SELECT 
    ID_Cliente,
    COUNT(*) AS Cantidad_Compras
FROM Ventas
WHERE Estado_Venta = 'Confirmada'
GROUP BY ID_Cliente
HAVING COUNT(*) =1
ORDER BY ID_Cliente;

/*
5.
Consulta
COMPARANDO TICKET PROMEDIO CON AÑOS ANTERIORES

Justificación
permite ver la simulación inflacionaria
*/
SELECT 
    YEAR(Fecha_Venta) AS Anio,
    COUNT(*) AS Cantidad_Ventas,
    AVG(Total_Venta) AS Ticket_Promedio
FROM Ventas
WHERE Estado_Venta = 'Confirmada'
GROUP BY YEAR(Fecha_Venta)
ORDER BY Anio;

/*
6.
Consulta
COMPARANDO VENTAS EN DISTINTAS ESTACIONES DEL AÑO

Justificación
permite ver la estacionalidad de las ventas
*/
SELECT
    CASE 
        WHEN MONTH(Fecha_Venta) IN (6,7,8) THEN 'Invierno'
        WHEN MONTH(Fecha_Venta) IN (12,1,2) THEN 'Verano'
        ELSE 'Otras_Estaciones'
    END AS Estacion,
    COUNT(*) AS Cantidad_Ventas,
    SUM(Total_Venta) AS Facturacion
FROM Ventas
WHERE Estado_Venta = 'Confirmada'
GROUP BY 
    CASE 
        WHEN MONTH(Fecha_Venta) IN (6,7,8) THEN 'Invierno'
        WHEN MONTH(Fecha_Venta) IN (12,1,2) THEN 'Verano'
        ELSE 'Otras_Estaciones'
    END
ORDER BY Facturacion DESC;


/*
7.
Consulta
COMPARANDO SALDO MENOR O IGUAL A CERO DEL MARGEN DE GANANCIAS UNITARIO

Justificación
permite detectar errores de precios
*/
SELECT 
    ID_Producto,
    Nombre_Producto,
    Precio_Lista,
    Costo,
    (Precio_Lista - Costo) AS Margen_Unitario
FROM Productos
WHERE Precio_Lista <= Costo
ORDER BY (Precio_Lista - Costo);


/*
8.
Consulta
COMPARANDO VARIACION DE VENTAS vs GANANCIAS

Justificación
permite ver que la ganacia no crece al mismo ritmo que la facturación
*/


SELECT
    YEAR(v.Fecha_Venta) AS Anio,
    SUM(dv.Subtotal) AS Facturacion_Total,
    SUM(dv.Ganancia) AS Ganancia_Total,
    CAST(SUM(dv.Ganancia) * 100.0 / SUM(dv.Subtotal) AS DECIMAL(10,2)) AS Margen_Porcentual
FROM Ventas v, Detalle_Ventas dv
WHERE v.ID_Venta = dv.ID_Venta
  AND v.Estado_Venta = 'Confirmada'
GROUP BY YEAR(v.Fecha_Venta)
ORDER BY Anio;

/*
9.
Consulta
ANALIZANDO DÍAS DEL MES CON MAYOR VOLUMEN DE VENTAS 

Justificación
Esto sirve para entender el comportamiento de compra y además es útil para planificar stock y logística.
*/

SELECT 
    DAY(Fecha_Venta) AS Dia_Del_Mes,
    COUNT(*) AS Cantidad_Ventas,
    SUM(Total_Venta) AS Total_Facturado
FROM Ventas
WHERE LOWER(LTRIM(RTRIM(Estado_Venta))) = 'confirmada'
GROUP BY DAY(Fecha_Venta)
ORDER BY Dia_Del_Mes;
/*
10.
Consulta
ANALIZANDO LIENTES ACTIVOS SIN DATOS DE CONTACTO

Justificación:
Permite ver si un cliente compra pero no tiene contacto, es una pérdida de oportunidad para fidelización, promociones y seguimiento.
*/
SELECT 
    COUNT(DISTINCT v.ID_Cliente) AS Clientes_Activos_Sin_Contacto
FROM Ventas v
LEFT JOIN Clientes_Contactos cc
    ON v.ID_Cliente = cc.ID_Cliente
WHERE LOWER(LTRIM(RTRIM(v.Estado_Venta))) = 'confirmada'
  AND cc.ID_Cliente IS NULL;
