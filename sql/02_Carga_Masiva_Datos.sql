﻿/*
GENERACIÓN MASIVA DE DATOS - DISTRIBUIDORA MAYORISTA
Volumen: ~300,000 registros totales
Período: Enero 2023 - Diciembre 2025
Con todas las reglas de negocio aplicadas
*/

USE [DistribuidoraMayorista];
GO

-- =============================================
-- 1. LIMPIAR TODOS LOS DATOS
-- =============================================

-- Elimina todos los datos en orden inverso de dependencias (FK)
-- Primero Detalle_Ventas (más dependiente), luego Ventas, etc.

PRINT 'Limpiando datos existentes...';
DELETE FROM Detalle_Ventas;
DELETE FROM Ventas;
DELETE FROM Clientes_Direcciones;
DELETE FROM Clientes_Contactos;
DELETE FROM Clientes;
DELETE FROM Productos;
DELETE FROM Categorias;
PRINT 'Datos eliminados.';

-- Resetear Contadores.
-- DBCC CHECKIDENT resetea los contadores autoincrementales a 0
-- Esto permite empezar desde cero sin conflictos de IDs

DBCC CHECKIDENT ('Categorias', RESEED, 0);
DBCC CHECKIDENT ('Productos', RESEED, 0);
DBCC CHECKIDENT ('Clientes', RESEED, 0);
DBCC CHECKIDENT ('Clientes_Contactos', RESEED, 0);
DBCC CHECKIDENT ('Clientes_Direcciones', RESEED, 0);
DBCC CHECKIDENT ('Ventas', RESEED, 0);
DBCC CHECKIDENT ('Detalle_Ventas', RESEED, 0);
PRINT 'Contadores reseteados.';

-- =============================================
-- 2. POBLAR CATEGORIAS (10)
-- =============================================

-- Inserta las 10 categorías básicas de alimentos congelados
-- Nombre_Categoria debe ser único por diseño de tabla
-- Las categorías son realistas para distribuidora mayorista argentina

PRINT 'Insertando categorías...';
INSERT INTO Categorias (Nombre_Categoria) 
VALUES 
('Verduras'), ('Carnes'), ('Pescados'), ('Panificados'),
('Helados'), ('Pizzas'), ('Preparados'), ('Papas'), 
('Postres'), ('Bebidas');
PRINT '10 categorías insertadas.';

-- =============================================
-- 3. POBLAR PRODUCTOS (100 PRODUCTOS)
-- =============================================

-- ESTRUCTURA POR LOTES:
-- 1. Verduras (20 productos): Precios base para 2023, margen ~30%
-- 2. Carnes (20 productos): Mayores precios, margen ~35%
-- 3. Pescados (15 productos): Alta variación de precios, productos premium
-- 4. Panificados (10 productos): Productos de panadería congelada
-- 5. Helados (10 productos): Variedades típicas argentinas
-- 6. Pizzas/Preparados (15 productos): Productos de valor agregado
-- 7. Papas/Postres/Bebidas (10 productos): Complementos

-- CARACTERÍSTICAS:
-- Precio_Lista: Precio de venta al público (mayorista)
-- Costo: Calculado como porcentaje del precio (65%-75%)
-- Activo: 15% de productos inactivos (simula discontinuados)
-- Peso_Unitario_Kg: Valores realistas para cada tipo de producto

PRINT 'Insertando productos...';

-- Crear 100 productos
INSERT INTO Productos (ID_Categoria, Nombre_Producto, Peso_Unitario_Kg, Precio_Lista, Costo, Activo)
-- Verduras (20 productos)
SELECT 1, Nombre, Peso, Precio, Precio * 0.7, 
       CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 10 = 0 THEN 0 ELSE 1 END
FROM (VALUES
('Espinaca Congelada 1kg', 1.0, 1250),
('Brócoli Congelado 1kg', 1.0, 1480),
('Zanahoria Congelada 1kg', 1.0, 980),
('Arvejas Congeladas 500g', 0.5, 850),
('Mezcla Primavera 2.5kg', 2.5, 2850),
('Choclo Desgranado 1kg', 1.0, 1650),
('Papas Congeladas 2kg', 2.0, 2200),
('Coliflor Congelada 1kg', 1.0, 1350),
('Chauchas Congeladas 500g', 0.5, 950),
('Zapallo Congelado 1kg', 1.0, 1100),
('Cebolla Congelada 1kg', 1.0, 1200),
('Pimiento Congelado 500g', 0.5, 1400),
('Apio Congelado 500g', 0.5, 1300),
('Perejil Congelado 200g', 0.2, 800),
('Acelga Congelada 1kg', 1.0, 1150),
('Remolacha Congelada 1kg', 1.0, 1250),
('Hongos Congelados 500g', 0.5, 1800),
('Berro Congelado 300g', 0.3, 950),
('Rúcula Congelada 300g', 0.3, 1100),
('Repollo Congelado 1kg', 1.0, 1050)
) AS V(Nombre, Peso, Precio)

UNION ALL
-- Carnes (20 productos)
SELECT 2, Nombre, Peso, Precio, Precio * 0.65,
       CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 10 = 0 THEN 0 ELSE 1 END
FROM (VALUES
('Milanesa Ternera 1kg', 1.0, 4850),
('Hamburguesa Vacuna 500g', 0.5, 3250),
('Pollo Entero 2.5kg', 2.5, 5200),
('Nuggets de Pollo 1kg', 1.0, 3850),
('Matambre de Cerdo 1.5kg', 1.5, 6100),
('Asado 3kg', 3.0, 12500),
('Chorizo Parrillero 1kg', 1.0, 3200),
('Morcilla 1kg', 1.0, 2800),
('Chuletas de Cerdo 1kg', 1.0, 4500),
('Costillas de Cerdo 2kg', 2.0, 7500),
('Pechuga de Pollo 1kg', 1.0, 4200),
('Muslo de Pollo 1kg', 1.0, 3800),
('Alitas de Pollo 1kg', 1.0, 3500),
('Carne Picada 1kg', 1.0, 4000),
('Bife de Chorizo 1kg', 1.0, 6800),
('Lomo 1kg', 1.0, 7200),
('Vacio 1kg', 1.0, 6500),
('Cuadril 1kg', 1.0, 6200),
('Colita de Cuadril 1kg', 1.0, 6000),
('Roast Beef 2kg', 2.0, 13000)
) AS C(Nombre, Peso, Precio)

UNION ALL
-- Pescados (15 productos)
SELECT 3, Nombre, Peso, Precio, Precio * 0.68,
       CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 10 = 0 THEN 0 ELSE 1 END
FROM (VALUES
('Filet de Merluza 1kg', 1.0, 4750),
('Camarones 500g', 0.5, 6850),
('Salmón 2kg', 2.0, 12500),
('Langostinos 1kg', 1.0, 9200),
('Calamar Anillos 500g', 0.5, 4200),
('Atún 1kg', 1.0, 5800),
('Trucha 1kg', 1.0, 5200),
('Corvina 1kg', 1.0, 4800),
('Lenguado 1kg', 1.0, 5500),
('Sardinas 1kg', 1.0, 3500),
('Anchoas 500g', 0.5, 2800),
('Mejillones 1kg', 1.0, 3200),
('Almejas 500g', 0.5, 3800),
('Vieiras 500g', 0.5, 4500),
('Pulpo 1kg', 1.0, 6500)
) AS P(Nombre, Peso, Precio)

UNION ALL
-- Panificados (10 productos)
SELECT 4, Nombre, Peso, Precio, Precio * 0.72,
       CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 10 = 0 THEN 0 ELSE 1 END
FROM (VALUES
('Pan Hamburguesa 500g', 0.5, 1280),
('Panchos 300g', 0.3, 950),
('Empanadas Carne 1kg (10un)', 1.0, 3200),
('Medialunas Manteca 500g', 0.5, 1800),
('Facturas 1kg', 1.0, 2500),
('Pan Árabe 400g', 0.4, 1200),
('Prepizzas 600g', 0.6, 1500),
('Tostadas 300g', 0.3, 850),
('Pan Rallado 500g', 0.5, 750),
('Pan Lactal 500g', 0.5, 1350)
) AS Pan(Nombre, Peso, Precio)

UNION ALL
-- Helados (10 productos)
SELECT 5, Nombre, Peso, Precio, Precio * 0.75,
       CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 10 = 0 THEN 0 ELSE 1 END
FROM (VALUES
('Crema Americana 1lt', 1.0, 2850),
('Dulce de Leche Granizado 1lt', 1.0, 2950),
('Chocolate Suizo 1lt', 1.0, 3100),
('Frutta 500ml', 0.5, 1750),
('Vainilla 1lt', 1.0, 2700),
('Menta Granizada 1lt', 1.0, 2900),
('Tramontana 1lt', 1.0, 3000),
('Sambayón 1lt', 1.0, 2800),
('Granizado 1lt', 1.0, 2750),
('Frutilla a la Crema 1lt', 1.0, 2850)
) AS H(Nombre, Peso, Precio)

UNION ALL
-- Pizzas y Preparados (15 productos)
SELECT 
    CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) <= 7 THEN 6 ELSE 7 END,
    Nombre, Peso, Precio, Precio * 0.68,
    CASE WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 10 = 0 THEN 0 ELSE 1 END
FROM (VALUES
('Pizza Mozzarella 800g', 0.8, 2250),
('Pizza Especial 1kg', 1.0, 2850),
('Pizza Napolitana 900g', 0.9, 2450),
('Pizza Calabresa 1.1kg', 1.1, 3150),
('Pizza 4 Quesos 950g', 0.95, 2950),
('Pizza Jamón y Morrones 850g', 0.85, 2650),
('Pizza Fugazzeta 950g', 0.95, 2750),
('Lasagna Carne 2kg', 2.0, 4850),
('Canelones Ricotta 1.5kg', 1.5, 4150),
('Tarta Jamón/Queso 1.8kg', 1.8, 3850),
('Croquetas Pollo 500g', 0.5, 1850),
('Empanadas Horneadas 2kg', 2.0, 5200),
('Tarta de Verduras 1.5kg', 1.5, 3650),
('Milanesas de Soja 1kg', 1.0, 3200),
('Hamburguesas de Lentejas 500g', 0.5, 1850)
) AS PP(Nombre, Peso, Precio)

UNION ALL
-- Papas, Postres y Bebidas (10 productos)
SELECT 
    CASE 
        WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) <= 3 THEN 8
        WHEN ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) <= 6 THEN 9
        ELSE 10
    END,
    Nombre, Peso, Precio, Precio * 0.7,
    1
FROM (VALUES
('Papas Fritas Corte Francés 1kg', 1.0, 1650),
('Papas Noisette 1kg', 1.0, 1850),
('Papas Bastón 1kg', 1.0, 1750),
('Tarta de Manzana 1.5kg', 1.5, 2850),
('Volcán de Chocolate 800g', 0.8, 3100),
('Tiramisú 1kg', 1.0, 3800),
('Jugo de Naranja 1lt', 1.0, 1580),
('Jugo de Manzana 1lt', 1.0, 1450),
('Jugo Multifruta 1lt', 1.0, 1650),
('Limonada 1lt', 1.0, 1350)
) AS Final(Nombre, Peso, Precio);

PRINT '100 productos insertados (15% inactivos).';

-- =============================================
-- 4. POBLAR CLIENTES (500 CLIENTES)
-- =============================================

-- DISTRIBUCIÓN POR TIPO:
-- 20% Supermercados (100 clientes)
-- 20% Restaurantes (100 clientes)  
-- 25% Kioscos (125 clientes)
-- 10% Rotiserías (50 clientes)
-- 25% Almacenes (125 clientes)

-- CARACTERÍSTICAS:
-- Razon_Social: Formato "Tipo + número secuencial"
-- CUIL: Formato válido argentino (20-xxxxxxxx-9)
-- Fecha_Alta: Escalonada desde 2020 (algunos clientes antiguos)
-- Activo: 15% inactivos (simula bajas)

PRINT 'Insertando clientes...';

INSERT INTO Clientes (Razon_Social, Cuil, Tipo_Comercio, Fecha_Alta, Activo)
SELECT 
    CASE 
        WHEN num <= 100 THEN 'Supermercado '      -- 20%
        WHEN num <= 200 THEN 'Restaurante '       -- 20%
        WHEN num <= 325 THEN 'Kiosco '            -- 25%
        WHEN num <= 375 THEN 'Rotiseria '         -- 10%
        ELSE 'Almacen '                           -- 25%
    END + RIGHT('0000' + CAST(num AS VARCHAR(4)), 4),
    '20' + RIGHT('00000000' + CAST(30000000 + num AS VARCHAR(8)), 8) + '9',
    CASE 
        WHEN num <= 100 THEN 'Supermercado'
        WHEN num <= 200 THEN 'Restaurante'
        WHEN num <= 325 THEN 'Kiosco'
        WHEN num <= 375 THEN 'Rotiseria'
        ELSE 'Almacen'
    END,
    -- Fechas de alta escalonadas desde 2020 hasta 2023
    DATEADD(DAY, num * 2, '2020-01-01'),
    -- 15% inactivos
    CASE WHEN num % 100 < 15 THEN 0 ELSE 1 END
FROM (SELECT TOP 500 ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS num 
      FROM sys.objects o1, sys.objects o2) nums;

PRINT '500 clientes insertados (15% inactivos).';

-- =============================================
-- 5. POBLAR CONTACTOS (1-2 POR CLIENTE)
-- =============================================

-- ESTRATEGIA:
-- 1. Todos los clientes tienen al menos 1 contacto principal
-- 2. 80% de clientes tienen un segundo contacto
-- 3. Nombres y apellidos comunes argentinos
-- 4. DNI generado secuencialmente (válido 8 dígitos)
-- 5. Email con formato estándar
-- 6. Teléfono con formato 11-xxxx-xxxx (CABA/GBA)

-- FECHAS:
-- Fecha_Desde: 10 días después del alta del cliente
-- Fecha_Hasta: Solo para clientes inactivos (6 meses después)

PRINT 'Insertando contactos...';

INSERT INTO Clientes_Contactos (ID_Cliente, Nombre, Apellido, DNI, Email, Telefono, Fecha_Desde, Fecha_Hasta)
SELECT 
    c.ID_Cliente,
    CASE (c.ID_Cliente % 8)
        WHEN 0 THEN 'Juan' WHEN 1 THEN 'María' WHEN 2 THEN 'Carlos'
        WHEN 3 THEN 'Ana' WHEN 4 THEN 'Roberto' WHEN 5 THEN 'Lucía'
        WHEN 6 THEN 'Diego' ELSE 'Carolina'
    END AS Nombre,
    CASE (c.ID_Cliente % 8)
        WHEN 0 THEN 'Gómez' WHEN 1 THEN 'Rodríguez' WHEN 2 THEN 'Fernández'
        WHEN 3 THEN 'López' WHEN 4 THEN 'Martínez' WHEN 5 THEN 'García'
        WHEN 6 THEN 'Pérez' ELSE 'Sánchez'
    END AS Apellido,
    RIGHT('00000000' + CAST(35000000 + c.ID_Cliente AS VARCHAR(8)), 8) AS DNI,
    'contacto' + CAST(c.ID_Cliente AS VARCHAR) + '@empresa.com' AS Email,
    '11-' + RIGHT('0000' + CAST(5000 + c.ID_Cliente % 5000 AS VARCHAR(4)), 4) + '-1234' AS Telefono,
    DATEADD(DAY, 10, c.Fecha_Alta) AS Fecha_Desde, -- 10 días después del alta
    CASE WHEN c.Activo = 0 THEN DATEADD(MONTH, 6, DATEADD(DAY, 10, c.Fecha_Alta)) ELSE NULL END AS Fecha_Hasta
FROM Clientes c

UNION ALL

-- Segundo contacto para el 80% de clientes
SELECT 
    c.ID_Cliente,
    CASE ((c.ID_Cliente + 1) % 8)
        WHEN 0 THEN 'Laura' WHEN 1 THEN 'Martín' WHEN 2 THEN 'Sofía'
        WHEN 3 THEN 'Andrés' WHEN 4 THEN 'Gabriela' WHEN 5 THEN 'Pablo'
        WHEN 6 THEN 'Florencia' ELSE 'José'
    END,
    CASE ((c.ID_Cliente + 1) % 8)
        WHEN 0 THEN 'Díaz' WHEN 1 THEN 'Romero' WHEN 2 THEN 'Acosta'
        WHEN 3 THEN 'Blanco' WHEN 4 THEN 'Molina' WHEN 5 THEN 'Suárez'
        WHEN 6 THEN 'Castillo' ELSE 'Rojas'
    END,
    RIGHT('00000000' + CAST(36000000 + c.ID_Cliente AS VARCHAR(8)), 8),
    'contacto2_' + CAST(c.ID_Cliente AS VARCHAR) + '@empresa.com',
    '11-' + RIGHT('0000' + CAST(6000 + c.ID_Cliente % 4000 AS VARCHAR(4)), 4) + '-5678',
    DATEADD(MONTH, 3, DATEADD(DAY, 10, c.Fecha_Alta)), -- 3 meses después del primer contacto
    CASE WHEN c.Activo = 0 THEN DATEADD(MONTH, 9, DATEADD(DAY, 10, c.Fecha_Alta)) ELSE NULL END
FROM Clientes c
WHERE c.ID_Cliente % 100 < 80; -- 80% con segundo contacto

PRINT 'Contactos insertados (~900 contactos).';

-- =============================================
-- 6. POBLAR DIRECCIONES (1-2 POR CLIENTE)
-- =============================================

-- ESTRATEGIA:
-- 1. Dirección principal en calles céntricas de Buenos Aires
-- 2. 70% de clientes tienen dirección secundaria en GBA
-- 3. Ciudades y provincias reales de Argentina
-- 4. Códigos postales válidos

-- DATOS GEOGRÁFICOS:
-- Calles: Avenidas principales de CABA
-- Ciudades: Mix entre CABA y principales ciudades
-- Provincias: Mayoría Buenos Aires, algunas otras

PRINT 'Insertando direcciones...';

INSERT INTO Clientes_Direcciones (ID_Cliente, Calle, Numero, Ciudad, Provincia, Codigo_Postal, Fecha_Desde, Fecha_Hasta)
SELECT 
    c.ID_Cliente,
    CASE (c.ID_Cliente % 12)
        WHEN 0 THEN 'Av. Corrientes' WHEN 1 THEN 'Av. Santa Fe'
        WHEN 2 THEN 'Av. Rivadavia' WHEN 3 THEN 'Calle Florida'
        WHEN 4 THEN 'Av. Cabildo' WHEN 5 THEN 'Av. Directorio'
        WHEN 6 THEN 'Av. Independencia' WHEN 7 THEN 'Av. San Martín'
        WHEN 8 THEN 'Av. Belgrano' WHEN 9 THEN 'Av. Pueyrredón'
        WHEN 10 THEN 'Av. Callao' ELSE 'Av. Medrano'
    END AS Calle,
    CAST(100 + c.ID_Cliente % 9000 AS VARCHAR(10)) AS Numero,
    CASE (c.ID_Cliente % 8)
        WHEN 0 THEN 'CABA' WHEN 1 THEN 'La Plata' WHEN 2 THEN 'Mar del Plata'
        WHEN 3 THEN 'Rosario' WHEN 4 THEN 'Córdoba' WHEN 5 THEN 'Mendoza'
        WHEN 6 THEN 'Salta' ELSE 'Tucumán'
    END AS Ciudad,
    CASE (c.ID_Cliente % 8)
        WHEN 0 THEN 'Buenos Aires' WHEN 1 THEN 'CABA' WHEN 2 THEN 'Santa Fe'
        WHEN 3 THEN 'Córdoba' WHEN 4 THEN 'Mendoza' WHEN 5 THEN 'Salta'
        WHEN 6 THEN 'Entre Ríos' ELSE 'Tucumán'
    END AS Provincia,
    RIGHT('0000' + CAST(1000 + c.ID_Cliente % 9000 AS VARCHAR(4)), 4) AS Codigo_Postal,
    DATEADD(DAY, 5, c.Fecha_Alta) AS Fecha_Desde, -- 5 días después del alta
    CASE WHEN c.Activo = 0 THEN DATEADD(MONTH, 6, DATEADD(DAY, 5, c.Fecha_Alta)) ELSE NULL END AS Fecha_Hasta
FROM Clientes c

UNION ALL

-- Segunda dirección para el 70% de clientes
SELECT 
    c.ID_Cliente,
    CASE ((c.ID_Cliente + 3) % 12)
        WHEN 0 THEN 'Av. Libertador' WHEN 1 THEN 'Av. Jujuy'
        WHEN 2 THEN 'Av. Entre Ríos' WHEN 3 THEN 'Calle Perú'
        WHEN 4 THEN 'Av. Scalabrini Ortiz' WHEN 5 THEN 'Av. Álvarez Thomas'
        WHEN 6 THEN 'Av. Dorrego' WHEN 7 THEN 'Av. Federico Lacroze'
        WHEN 8 THEN 'Av. Triunvirato' WHEN 9 THEN 'Av. Monroe'
        WHEN 10 THEN 'Av. Congreso' ELSE 'Av. Boedo'
    END,
    CAST(200 + c.ID_Cliente % 8000 AS VARCHAR(10)),
    CASE ((c.ID_Cliente + 2) % 8)
        WHEN 0 THEN 'Quilmes' WHEN 1 THEN 'Lomas de Zamora' WHEN 2 THEN 'San Isidro'
        WHEN 3 THEN 'Vicente López' WHEN 4 THEN 'San Miguel' WHEN 5 THEN 'Pilar'
        WHEN 6 THEN 'Tigre' ELSE 'Morón'
    END,
    'Buenos Aires',
    RIGHT('0000' + CAST(2000 + c.ID_Cliente % 8000 AS VARCHAR(4)), 4),
    DATEADD(MONTH, 6, DATEADD(DAY, 5, c.Fecha_Alta)), -- 6 meses después de la primera
    CASE WHEN c.Activo = 0 THEN DATEADD(YEAR, 1, DATEADD(DAY, 5, c.Fecha_Alta)) ELSE NULL END
FROM Clientes c
WHERE c.ID_Cliente % 100 < 70; -- 70% con segunda dirección

PRINT 'Direcciones insertadas (~850 direcciones).';

-- =============================================
-- 7. POBLAR VENTAS (50,000 VENTAS) - CON ESTACIONALIDAD
-- =============================================

-- ESTRATEGIA DE GENERACIÓN:
-- 1. 50,000 ventas distribuidas en 1095 días (2023-2025)
-- 2. Promedio: ~46 ventas/día (ajustado por estacionalidad)

-- ESTACIONALIDAD IMPLEMENTADA:
-- UPDATE ajusta fechas: -30 a +60 días para invierno/verano
-- Esto concentra ventas en invierno (jun-sep) y dispersa en verano (ene-feb)

-- FORMAS DE PAGO:
-- 20% Efectivo (2 de cada 10)
-- 20% Transferencia (2 de cada 10)  
-- 20% Tarjeta Débito (2 de cada 10)
-- 40% Tarjeta Crédito (4 de cada 10)
-- Distribución realista para Argentina

-- ESTADOS:
-- 95% Confirmadas (47,500 ventas)
-- 5% Canceladas (2,500 ventas)

PRINT 'Insertando ventas masivas con estacionalidad...';

-- Crear tabla temporal para ventas
CREATE TABLE #VentasTemp (
    ID_Venta INT IDENTITY(1,1),
    ID_Cliente INT,
    Fecha_Venta DATE,
    Forma_Pago VARCHAR(20),
    Estado_Venta VARCHAR(20)
);

-- Insertar 50,000 ventas con distribución temporal
DECLARE @fecha_base DATE = '2023-01-01';
DECLARE @dias_totales INT = 1095; -- 3 años (2023-2025)
DECLARE @ventas_por_dia_base INT = 46; -- 50,000 / 1095 ≈ 46

INSERT INTO #VentasTemp (ID_Cliente, Fecha_Venta, Forma_Pago, Estado_Venta)
SELECT TOP 50000
    cli.ID_Cliente,
    -- Distribuir ventas con estacionalidad
    DATEADD(DAY, 
        CAST((ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) * 1.0 / 50000 * 1095) AS INT),
        '2023-01-01') AS Fecha_Venta,
    -- Formas de pago con distribución realista
    CASE (ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) % 100)
        WHEN 0 THEN 'Efectivo'
        WHEN 1 THEN 'Efectivo'
        WHEN 2 THEN 'Transferencia'
        WHEN 3 THEN 'Transferencia'
        WHEN 4 THEN 'Tarjeta Debito'
        WHEN 5 THEN 'Tarjeta Debito'
        WHEN 6 THEN 'Tarjeta Credito'
        WHEN 7 THEN 'Tarjeta Credito'
        WHEN 8 THEN 'Tarjeta Credito'
        ELSE 'Tarjeta Credito'
    END,
    -- 95% confirmadas, 5% canceladas
    CASE WHEN RAND(CHECKSUM(NEWID())) < 0.95 THEN 'Confirmada' ELSE 'Cancelada' END
FROM Clientes cli
CROSS JOIN (SELECT TOP 100 1 AS n FROM sys.objects) multiplicador
WHERE cli.Activo = 1
ORDER BY NEWID();

-- Ajustar estacionalidad: más ventas en invierno
UPDATE #VentasTemp 
SET Fecha_Venta = DATEADD(DAY, 
    CASE 
        WHEN MONTH(Fecha_Venta) IN (6,7,8,9) THEN -30 + CAST(RAND(CHECKSUM(NEWID())) * 60 AS INT) -- Concentrar en invierno
        WHEN MONTH(Fecha_Venta) IN (1,2) THEN 30 + CAST(RAND(CHECKSUM(NEWID())) * 60 AS INT) -- Dispersar en verano
        ELSE 0
    END,
    Fecha_Venta)
WHERE Fecha_Venta BETWEEN '2023-01-01' AND '2025-12-31';

-- Asegurar que las fechas estén dentro del período
UPDATE #VentasTemp 
SET Fecha_Venta = 
    CASE 
        WHEN Fecha_Venta < '2023-01-01' THEN '2023-03-15'
        WHEN Fecha_Venta > '2025-12-31' THEN '2025-10-15'
        ELSE Fecha_Venta
    END;

-- Insertar en tabla Ventas
INSERT INTO Ventas (ID_Cliente, Fecha_Venta, Forma_Pago, Estado_Venta, Total_Venta)
SELECT ID_Cliente, Fecha_Venta, Forma_Pago, Estado_Venta, 0
FROM #VentasTemp;

DROP TABLE #VentasTemp;
PRINT '50,000 ventas insertadas (95% confirmadas, 5% canceladas).';

-- =============================================
-- 8. POBLAR DETALLE_VENTAS MASIVO (~250,000 REGISTROS)
-- =============================================

-- PARTE CRÍTICA: COMPORTAMIENTO POR TIPO DE CLIENTE

-- CANTIDAD DE UNIDADES:
-- Supermercado: 10-50 unidades (compra por cajas)
-- Restaurante: 5-20 unidades (stock semanal)
-- Kiosco: 1-5 unidades (compra minorista)
-- Rotisería: 8-30 unidades (volumen medio)
-- Almacén: 3-15 unidades (intermedio)

-- PRODUCTOS POR VENTA:
-- Supermercado: 5-10 productos diferentes
-- Restaurante: 3-6 productos diferentes (especializados)
-- Otros: 1-5 productos diferentes

-- FILTROS POR TIPO DE CLIENTE (REGLA CLAVE):
-- Restaurantes: Solo Carnes(2), Pescados(3), Preparados(7)
-- Kioscos: Solo Panificados(4), Helados(5)  
-- Rotiserías: Solo Carnes(2), Preparados(7)
-- Supermercados/Almacenes: Cualquier producto

-- INFLACIÓN APLICADA:
-- 2023: ×1.0 (base)
-- 2024: ×2.114 (+211.4% - inflación real 2023)
-- 2025: ×2.114×1.40 (+140% sobre 2024 - proyección)

-- DESCUENTOS:
-- 20% de los items tienen descuento (0-15%)
-- Simula negociaciones con clientes grandes

PRINT 'Insertando detalles de ventas masivos...';

-- Crear tabla temporal para detalles
CREATE TABLE #DetalleTemp (
    ID_Venta INT,
    ID_Producto INT,
    Cantidad_Unidades INT,
    Precio_Unitario DECIMAL(10,2)
);

-- Insertar ~250,000 detalles (promedio 5 productos por venta)
INSERT INTO #DetalleTemp (ID_Venta, ID_Producto, Cantidad_Unidades)
SELECT TOP 250000
    v.ID_Venta,
    p.ID_Producto,
    -- CANTIDAD SEGÚN TIPO DE CLIENTE (REGLA IMPORTANTE)
    CASE c.Tipo_Comercio
        WHEN 'Supermercado' THEN 10 + (ABS(CHECKSUM(NEWID())) % 41) -- 10-50 unidades
        WHEN 'Restaurante' THEN 5 + (ABS(CHECKSUM(NEWID())) % 16)   -- 5-20 unidades
        WHEN 'Rotiseria' THEN 8 + (ABS(CHECKSUM(NEWID())) % 23)     -- 8-30 unidades
        WHEN 'Almacen' THEN 3 + (ABS(CHECKSUM(NEWID())) % 13)       -- 3-15 unidades
        ELSE 1 + (ABS(CHECKSUM(NEWID())) % 5)                       -- 1-5 unidades (Kioscos)
    END
FROM Ventas v
INNER JOIN Clientes c ON v.ID_Cliente = c.ID_Cliente
CROSS APPLY (
    -- SELECCIONAR PRODUCTOS SEGÚN TIPO DE CLIENTE (REGLA IMPORTANTE)
    SELECT TOP (CASE 
        WHEN c.Tipo_Comercio = 'Supermercado' THEN 5 + (ABS(CHECKSUM(NEWID())) % 6)  -- 5-10 productos
        WHEN c.Tipo_Comercio = 'Restaurante' THEN 3 + (ABS(CHECKSUM(NEWID())) % 4)   -- 3-6 productos
        ELSE 1 + (ABS(CHECKSUM(NEWID())) % 5)                                         -- 1-5 productos
    END)
    prod.ID_Producto,
    prod.Precio_Lista,
    prod.Costo,
    prod.ID_Categoria
    FROM Productos prod
    WHERE prod.Activo = 1
    -- FILTROS POR TIPO DE CLIENTE
    AND (
        -- Restaurantes: prefieren carnes, pescados y preparados
        (c.Tipo_Comercio = 'Restaurante' AND prod.ID_Categoria IN (2, 3, 7))
        OR
        -- Kioscos: prefieren helados y panificados
        (c.Tipo_Comercio = 'Kiosco' AND prod.ID_Categoria IN (4, 5))
        OR
        -- Rotiserias: prefieren carnes y preparados
        (c.Tipo_Comercio = 'Rotiseria' AND prod.ID_Categoria IN (2, 7))
        OR
        -- Supermercados y Almacenes: cualquier producto
        (c.Tipo_Comercio IN ('Supermercado', 'Almacen'))
    )
    ORDER BY NEWID()
) p
WHERE v.Estado_Venta = 'Confirmada'
ORDER BY NEWID();

-- APLICAR INFLACIÓN POR AÑO (REGLA IMPORTANTE)
UPDATE dt
SET Precio_Unitario = ROUND(p.Precio_Lista * 
    CASE 
        WHEN YEAR(v.Fecha_Venta) = 2023 THEN 1.0                          -- Año base
        WHEN YEAR(v.Fecha_Venta) = 2024 THEN 2.114                        -- +211.4% (inflación 2023)
        ELSE 2.114 * 1.40                                                 -- * 1.40 (inflación 2024 proyectada)
    END * 
    -- Descuentos aleatorios (0-15% en 20% de los casos)
    (1 - CASE WHEN dt.ID_Venta % 100 < 20 
         THEN CAST(dt.ID_Venta % 16 AS DECIMAL(4,2)) / 100 
         ELSE 0 END), 
    2)
FROM #DetalleTemp dt
INNER JOIN Productos p ON dt.ID_Producto = p.ID_Producto
INNER JOIN Ventas v ON dt.ID_Venta = v.ID_Venta;

-- Insertar en tabla Detalle_Ventas con cálculos
INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_Unidades, Precio_Unitario, Subtotal, Ganancia)
SELECT 
    dt.ID_Venta,
    dt.ID_Producto,
    dt.Cantidad_Unidades,
    dt.Precio_Unitario,
    dt.Cantidad_Unidades * dt.Precio_Unitario AS Subtotal,
    dt.Cantidad_Unidades * (dt.Precio_Unitario - p.Costo) AS Ganancia
FROM #DetalleTemp dt
INNER JOIN Productos p ON dt.ID_Producto = p.ID_Producto;

DROP TABLE #DetalleTemp;

-- Actualizar totales de ventas confirmadas
UPDATE v
SET Total_Venta = COALESCE((
    SELECT SUM(Subtotal) 
    FROM Detalle_Ventas dv 
    WHERE dv.ID_Venta = v.ID_Venta
    GROUP BY dv.ID_Venta
), 0)
FROM Ventas v
WHERE v.Estado_Venta = 'Confirmada';

-- Para ventas canceladas, total = 0
UPDATE Ventas SET Total_Venta = 0 WHERE Estado_Venta = 'Cancelada';

PRINT 'Detalles de ventas insertados (~250,000 registros).';

-- =============================================
-- 9. REPORTE FINAL Y VALIDACIONES
-- =============================================

-- VALIDACIONES IMPLEMENTADAS:
-- 1. Período: Verifica que esté entre 2023-01-01 y 2025-12-31
-- 2. Comportamiento: Valida rangos de unidades por tipo de cliente
-- 3. Inflación: Verifica factores aplicados por año
-- 4. Estacionalidad: Muestra distribución mensual

-- ESTADÍSTICAS GENERADAS:
-- Totales por tabla
-- Distribución por tipo de comercio
-- Evolución anual con inflación
-- Estacionalidad mensual

PRINT '';
PRINT '========================================';
PRINT 'GENERACIÓN MASIVA COMPLETADA';
PRINT '========================================';
PRINT '';

-- Resumen de volúmenes
SELECT 'TABLA' AS [Tabla], 
       COUNT(*) AS [Registros],
       CASE 
           WHEN Tabla = 'Categorias' THEN '10 categorías de alimentos'
           WHEN Tabla = 'Productos' THEN '100 productos (15% inactivos)'
           WHEN Tabla = 'Clientes' THEN '500 clientes (15% inactivos)'
           WHEN Tabla = 'Clientes_Contactos' THEN '~900 contactos (1-2 por cliente)'
           WHEN Tabla = 'Clientes_Direcciones' THEN '~850 direcciones (1-2 por cliente)'
           WHEN Tabla = 'Ventas' THEN '50,000 ventas 2023-2025 (95% confirmadas)'
           WHEN Tabla = 'Detalle_Ventas' THEN '~250,000 items vendidos'
       END AS [Descripción]
FROM (
    SELECT 'Categorias' AS Tabla FROM Categorias
    UNION ALL SELECT 'Productos' FROM Productos
    UNION ALL SELECT 'Clientes' FROM Clientes
    UNION ALL SELECT 'Clientes_Contactos' FROM Clientes_Contactos
    UNION ALL SELECT 'Clientes_Direcciones' FROM Clientes_Direcciones
    UNION ALL SELECT 'Ventas' FROM Ventas
    UNION ALL SELECT 'Detalle_Ventas' FROM Detalle_Ventas
) AS TodasTablas
GROUP BY Tabla
ORDER BY 
    CASE Tabla
        WHEN 'Categorias' THEN 1
        WHEN 'Productos' THEN 2
        WHEN 'Clientes' THEN 3
        WHEN 'Clientes_Contactos' THEN 4
        WHEN 'Clientes_Direcciones' THEN 5
        WHEN 'Ventas' THEN 6
        WHEN 'Detalle_Ventas' THEN 7
    END;

PRINT '';
PRINT '=== VALIDACIÓN DE REGLAS DE NEGOCIO ===';

-- 1. Verificar período de análisis
PRINT '1. Período de análisis:';
SELECT 
    MIN(Fecha_Venta) AS [Primera Venta],
    MAX(Fecha_Venta) AS [Última Venta],
    DATEDIFF(DAY, MIN(Fecha_Venta), MAX(Fecha_Venta)) AS [Días cubiertos],
    CASE 
        WHEN MIN(Fecha_Venta) >= '2023-01-01' AND MAX(Fecha_Venta) <= '2025-12-31'
        THEN '✅ Correcto: Enero 2023 - Diciembre 2025'
        ELSE '❌ Error: Fuera del período'
    END AS Validación
FROM Ventas;

-- 2. Verificar comportamientos por tipo de cliente
PRINT '';
PRINT '2. Comportamiento por Tipo de Cliente:';
WITH ResumenClientes AS (
    SELECT 
        c.Tipo_Comercio,
        COUNT(DISTINCT v.ID_Venta) AS Ventas,
        AVG(dv.Cantidad_Unidades) AS [Promedio Unidades/Venta],
        MIN(dv.Cantidad_Unidades) AS [Mínimo Unidades],
        MAX(dv.Cantidad_Unidades) AS [Máximo Unidades]
    FROM Ventas v
    INNER JOIN Clientes c ON v.ID_Cliente = c.ID_Cliente
    INNER JOIN Detalle_Ventas dv ON v.ID_Venta = dv.ID_Venta
    WHERE v.Estado_Venta = 'Confirmada'
    GROUP BY c.Tipo_Comercio
)
SELECT 
    Tipo_Comercio,
    Ventas,
    FORMAT([Promedio Unidades/Venta], 'N1') AS [Prom. Unid],
    [Mínimo Unidades],
    [Máximo Unidades],
    CASE 
        WHEN Tipo_Comercio = 'Supermercado' AND [Mínimo Unidades] >= 10 AND [Máximo Unidades] <= 50 THEN '✅ OK: 10-50 unidades'
        WHEN Tipo_Comercio = 'Restaurante' AND [Mínimo Unidades] >= 5 AND [Máximo Unidades] <= 20 THEN '✅ OK: 5-20 unidades'
        WHEN Tipo_Comercio = 'Kiosco' AND [Mínimo Unidades] >= 1 AND [Máximo Unidades] <= 5 THEN '✅ OK: 1-5 unidades'
        WHEN Tipo_Comercio = 'Rotiseria' AND [Mínimo Unidades] >= 8 AND [Máximo Unidades] <= 30 THEN '✅ OK: 8-30 unidades'
        WHEN Tipo_Comercio = 'Almacen' AND [Mínimo Unidades] >= 3 AND [Máximo Unidades] <= 15 THEN '✅ OK: 3-15 unidades'
        ELSE '⚠️ Revisar'
    END AS [Validación Comportamiento]
FROM ResumenClientes
ORDER BY Ventas DESC;

-- 3. Verificar inflación aplicada
PRINT '';
PRINT '3. Inflación aplicada por año:';
WITH PreciosPorAnio AS (
    SELECT 
        YEAR(v.Fecha_Venta) AS Anio,
        AVG(dv.Precio_Unitario / p.Precio_Lista) AS Factor_Inflacion
    FROM Ventas v
    INNER JOIN Detalle_Ventas dv ON v.ID_Venta = dv.ID_Venta
    INNER JOIN Productos p ON dv.ID_Producto = p.ID_Producto
    WHERE v.Estado_Venta = 'Confirmada'
    GROUP BY YEAR(v.Fecha_Venta)
)
SELECT 
    Anio,
    FORMAT(Factor_Inflacion, 'N3') AS [Factor Inflación],
    FORMAT((Factor_Inflacion - 1) * 100, 'N1') + '%' AS [Inflación Aplicada],
    CASE Anio
        WHEN 2023 THEN '✅ Base (0%)'
        WHEN 2024 THEN CASE WHEN Factor_Inflacion BETWEEN 2.0 AND 3.0 THEN '✅ +211.4% real' ELSE '⚠️ Revisar' END
        WHEN 2025 THEN CASE WHEN Factor_Inflacion BETWEEN 2.8 AND 4.0 THEN '✅ +140% sobre 2024' ELSE '⚠️ Revisar' END
    END AS Validación
FROM PreciosPorAnio
ORDER BY Anio;

-- 4. Verificar estacionalidad
PRINT '';
PRINT '4. Estacionalidad (Ventas por Mes):';
WITH VentasMensuales AS (
    SELECT 
        MONTH(Fecha_Venta) AS Mes,
        DATENAME(MONTH, Fecha_Venta) AS Nombre_Mes,
        COUNT(*) AS Ventas,
        AVG(COUNT(*)) OVER() AS Promedio_Mensual
    FROM Ventas
    WHERE Estado_Venta = 'Confirmada'
    GROUP BY MONTH(Fecha_Venta), DATENAME(MONTH, Fecha_Venta)
)
SELECT 
    Nombre_Mes,
    Ventas,
    FORMAT(Ventas * 100.0 / NULLIF(Promedio_Mensual, 0), 'N0') + '%' AS [Vs Promedio],
    CASE 
        WHEN Mes IN (6,7,8,9) AND Ventas > Promedio_Mensual * 1.1 THEN '✅ ALTA (Invierno)'
        WHEN Mes IN (1,2) AND Ventas < Promedio_Mensual * 0.9 THEN '✅ BAJA (Verano)'
        WHEN Mes = 12 AND Ventas > Promedio_Mensual * 1.05 THEN '✅ ALTA (Navidad)'
        ELSE '⚖️ NORMAL'
    END AS Temporada
FROM VentasMensuales
ORDER BY Mes;

PRINT '';
PRINT '=== GENERACIÓN COMPLETADA EXITOSAMENTE ===';
PRINT 'Total registros generados: ~300,000';
PRINT 'Período cubierto: Enero 2023 - Diciembre 2025';
PRINT 'Datos listos para análisis comerciales y pruebas de rendimiento.';

SELECT * FROM [dbo].[Clientes];
SELECT * FROM [dbo].[Clientes_Contactos];
SELECT * FROM [dbo].[Clientes_Direcciones];
SELECT * FROM [dbo].[Detalle_Ventas];
SELECT * FROM [dbo].[Productos];
SELECT * FROM [dbo].[Ventas];