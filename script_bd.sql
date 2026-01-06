CREATE SCHEMA ayoza;

CREATE TABLE ayoza.Cliente (
  id_cliente SERIAL PRIMARY KEY,
  tipo_identificacion VARCHAR(10) NOT NULL 
    CHECK (tipo_identificacion IN ('CEDULA','RUC','PASAPORTE')),
  identificacion VARCHAR(13) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  telefono VARCHAR(20),
  email VARCHAR(255) UNIQUE NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP,
  UNIQUE (tipo_identificacion, identificacion)
);

CREATE TABLE ayoza.Tipo_Vehiculo (
  id_tipo_vehiculo SERIAL PRIMARY KEY,
  nombre VARCHAR(100) UNIQUE NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP
);

CREATE TABLE ayoza.Vehiculo (
  id_vehiculo SERIAL PRIMARY KEY,
  marca VARCHAR(100) NOT NULL,
  modelo VARCHAR(100) NOT NULL,
  anio INT CHECK (anio >= 1990),
  precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
  id_tipo_vehiculo INT NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP,
  FOREIGN KEY (id_tipo_vehiculo) REFERENCES ayoza.Tipo_Vehiculo(id_tipo_vehiculo)
);

CREATE TABLE ayoza.Vendedor (
  id_vendedor SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20),
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP
);

CREATE TABLE ayoza.Factura (
  id_factura SERIAL PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_vendedor INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  estado VARCHAR(20) DEFAULT 'PENDIENTE'
    CHECK (estado IN ('PENDIENTE','PAGADA','ANULADA')),
  subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
  impuesto DECIMAL(10,2) DEFAULT 0 CHECK (impuesto >= 0),
  total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES ayoza.Cliente(id_cliente),
  FOREIGN KEY (id_vendedor) REFERENCES ayoza.Vendedor(id_vendedor)
);

CREATE TABLE ayoza.Detalle_Factura (
  id_detalle SERIAL PRIMARY KEY,
  id_factura INT NOT NULL,
  id_vehiculo INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
  subtotal_linea DECIMAL(10,2) NOT NULL CHECK (subtotal_linea >= 0),
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP,
  FOREIGN KEY (id_factura) REFERENCES ayoza.Factura(id_factura),
  FOREIGN KEY (id_vehiculo) REFERENCES ayoza.Vehiculo(id_vehiculo)
);
