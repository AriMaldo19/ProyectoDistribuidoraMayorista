--------------------- CREAR BASE DE DATOS --------------------- 

-- Creación de la Base de Datos llamada "DistribuidoraMayorista".
CREATE DATABASE DistribuidoraMayorista;

-- Posicionamiento sobre la base de datos creada recientemente.
USE DistribuidoraMayorista;

--------------------- CREAR TABLAS --------------------- 

-- Tabla Categorías
CREATE TABLE Categorias (
ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
Nombre_Categoria VARCHAR(50) UNIQUE
);

-- Tabla Productos 
CREATE TABLE Productos (
ID_Producto INT IDENTITY(1,1) PRIMARY KEY,
Nombre_Producto VARCHAR(100) UNIQUE,
ID_Categoria INT, 
Peso_Unitario_Kg DECIMAL(5,2) 
	CONSTRAINT CHK_PesoUnitario CHECK (Peso_Unitario_Kg > 0),
Precio_Lista DECIMAL(10,2) 
	CONSTRAINT CHK_Precio_Lista CHECK (Precio_Lista > 0),
Costo DECIMAL(10,2) 
	CONSTRAINT CHk_Costo CHECK (Costo > 0),
Activo BIT 
	CONSTRAINT CHK_Activo CHECK (Activo IN (0,1)),
CONSTRAINT FK_Categoria FOREIGN KEY(ID_Categoria) REFERENCES Categorias(ID_Categoria)
);

-- Tabla Clientes
CREATE TABLE Clientes (
ID_Cliente INT IDENTITY(1,1) PRIMARY KEY,
Razon_Social VARCHAR(100) UNIQUE,
Cuil VARCHAR(11) UNIQUE, 
	CONSTRAINT CHK_Cuil CHECK (LEN(Cuil) = 11),
Tipo_Comercio VARCHAR(20) 
	CONSTRAINT CHK_TipoComercio CHECK (Tipo_Comercio IN ('Kiosco', 'Almacen', 'Supermercado', 'Restaurante', 'Rotiseria')),
Fecha_Alta DATE NOT NULL, 
Activo BIT 
	CONSTRAINT CHK_Activo_Cliente CHECK (Activo IN (0,1))
);

-- Tabla Clientes_Contactos
CREATE TABLE Clientes_Contactos (
ID_Contacto INT IDENTITY(1,1) PRIMARY KEY,
ID_Cliente INT,
Nombre VARCHAR(50) NOT NULL, 
Apellido VARCHAR(50) NOT NULL, 
DNI VARCHAR(8) UNIQUE, 
	CONSTRAINT CHK_DNI CHECK (LEN(DNI) = 8),
Email VARCHAR(100) UNIQUE,
Telefono VARCHAR(20), 
Fecha_Desde DATE NOT NULL, 
Fecha_Hasta DATE NULL,
CONSTRAINT CHK_FechaHasta_Contacto 
        CHECK (Fecha_Hasta IS NULL OR Fecha_Hasta >= Fecha_Desde),
    CONSTRAINT FK_Clientes_Contactos 
        FOREIGN KEY(ID_Cliente) REFERENCES Clientes(ID_Cliente)
);

-- Tabla Clientes_Direcciones 
CREATE TABLE Clientes_Direcciones (
ID_Direccion INT IDENTITY(1,1) PRIMARY KEY, 
ID_Cliente INT,
Calle VARCHAR(100) NOT NULL, 
Numero VARCHAR(10) NOT NULL, 
Ciudad VARCHAR(50) NOT NULL, 
Provincia VARCHAR(50) NOT NULL, 
Codigo_Postal VARCHAR(10),
Fecha_Desde DATE NOT NULL, 
Fecha_Hasta DATE NULL, 
CONSTRAINT CHK_FechaHasta_Direccion 
        CHECK (Fecha_Hasta IS NULL OR Fecha_Hasta >= Fecha_Desde),
CONSTRAINT FK_Clientes_Direcciones 
        FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente)
);
-- 

-- Tabla Ventas
CREATE TABLE Ventas (
ID_Venta INT IDENTITY(1,1) PRIMARY KEY, 
ID_Cliente INT, 
Fecha_Venta DATE NOT NULL, 
Forma_Pago VARCHAR(20) 
	CONSTRAINT CHK_Forma_Pago CHECK (Forma_Pago IN ('Efectivo','Tarjeta Debito', 'Tarjeta Credito', 'Transferencia')),
Total_Venta DECIMAL(12,2) NOT NULL, 
Estado_Venta VARCHAR(20) 
	CONSTRAINT CHK_Estado_Venta CHECK (Estado_Venta IN ('Confirmada', 'Cancelada')),
CONSTRAINT FK_Ventas_Clientes FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente)
);

-- Tabla Detalle_Ventas
CREATE TABLE Detalle_Ventas (
ID_Detalle INT IDENTITY(1,1) PRIMARY KEY,
ID_Venta INT,
ID_Producto INT,
Cantidad_Unidades INT 
	CONSTRAINT CHK_Cantidad_Unidades CHECK (Cantidad_Unidades > 0),
Precio_Unitario DECIMAL(10,2) 
	CONSTRAINT CHK_Precio_Unitario CHECK(Precio_Unitario > 0),
Subtotal DECIMAL(12,2),
Ganancia DECIMAL(12,2),
CONSTRAINT FK_Detalle_Ventas_Ventas FOREIGN KEY (ID_Venta) REFERENCES Ventas(ID_Venta),
CONSTRAINT FK_Detalle_Ventas_Productos FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);






