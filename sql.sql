-- Crear la tabla personas
CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100),
    dni VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    fecha_nacimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla empresas
CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cif VARCHAR(20) UNIQUE,
    direccion VARCHAR(255),
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla para relacionar personas y empresas
CREATE TABLE personas_empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT,
    empresa_id INT,
    puesto VARCHAR(100), -- Ej. 'Gerente', 'Empleado', etc.
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (persona_id) REFERENCES personas(id),
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- Crear la tabla roles
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Crear la tabla usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol_id INT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (persona_id) REFERENCES personas(id),
    FOREIGN KEY (rol_id) REFERENCES roles(id)
);
-- Cambiar el nombre de la columna 'password' a 'password_hash'
ALTER TABLE usuarios
CHANGE COLUMN password password_hash VARCHAR(255) NOT NULL;

-- Añadir la columna para almacenar el token del usuario
ALTER TABLE usuarios
ADD COLUMN token VARCHAR(255);

INSERT INTO roles (nombre) VALUES ('Administrador');
INSERT INTO roles (nombre) VALUES ('Gerente');
INSERT INTO roles (nombre) VALUES ('Usuario');
INSERT INTO roles (nombre) VALUES ('Editor');
INSERT INTO roles (nombre) VALUES ('Soporte Técnico');
INSERT INTO roles (nombre) VALUES ('Auditor');
INSERT INTO roles (nombre) VALUES ('Cliente');


-- Inserciones PRC

DELIMITER //

CREATE PROCEDURE crear_persona (
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_dni VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_fecha_nacimiento DATE
)
BEGIN
    -- Verificar si el DNI o Email ya existen
    IF EXISTS (SELECT 1 FROM personas WHERE dni = p_dni) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El DNI ya existe.';
    ELSEIF EXISTS (SELECT 1 FROM personas WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El email ya existe.';
    ELSE
        -- Insertar el nuevo registro en la tabla personas
        INSERT INTO personas (nombre, apellidos, dni, email, telefono, direccion, fecha_nacimiento)
        VALUES (p_nombre, p_apellidos, p_dni, p_email, p_telefono, p_direccion, p_fecha_nacimiento);
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE crear_empresa (
    IN p_nombre VARCHAR(100),
    IN p_cif VARCHAR(20),
    IN p_direccion VARCHAR(255),
    IN p_telefono VARCHAR(15),
    IN p_email VARCHAR(100)
)
BEGIN
    -- Verificar si el CIF o Email ya existen
    IF EXISTS (SELECT 1 FROM empresas WHERE cif = p_cif) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El CIF ya existe.';
    ELSEIF EXISTS (SELECT 1 FROM empresas WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El email ya existe.';
    ELSE
        -- Insertar el nuevo registro en la tabla empresas
        INSERT INTO empresas (nombre, cif, direccion, telefono, email)
        VALUES (p_nombre, p_cif, p_direccion, p_telefono, p_email);
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE registrar_usuario (
    IN p_persona_id INT,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_rol_id INT
)
BEGIN
    DECLARE v_password_hash VARCHAR(255);
    DECLARE v_token VARCHAR(255);

    -- Generar hash para la contraseña usando SHA2 (ejemplo, para producción usa una librería especializada en tu aplicación)
    SET v_password_hash = SHA2(p_password, 256);
    
    -- Generar un token único (ejemplo básico, en producción usa un enfoque más seguro)
    SET v_token = UUID();
    
    -- Insertar el nuevo usuario
    INSERT INTO usuarios (persona_id, username, password_hash, rol_id, activo, token)
    VALUES (p_persona_id, p_username, v_password_hash, p_rol_id, TRUE, v_token);
END //

DELIMITER ;


--Para crear una Persona Usuario
DELIMITER //

CREATE PROCEDURE crear_persona_y_usuario (
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_dni VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_fecha_nacimiento DATE,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_rol_id INT
)
BEGIN
    DECLARE v_persona_id INT;
    DECLARE v_password_hash VARCHAR(255);
    DECLARE v_token VARCHAR(255);

    -- Validar si el nombre de usuario ya existe
    IF EXISTS (SELECT 1 FROM usuarios WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre de usuario ya existe.';
    END IF;

    -- Validar si el DNI o el correo electrónico ya existe
    IF EXISTS (SELECT 1 FROM personas WHERE dni = p_dni OR email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El DNI o el correo electrónico ya existe.';
    END IF;

    -- Generar hash para la contraseña usando SHA2
    SET v_password_hash = SHA2(p_password, 256);

    -- Generar un token único
    SET v_token = UUID();

    -- Insertar la nueva persona en la tabla personas
    INSERT INTO personas (nombre, apellidos, dni, email, telefono, direccion, fecha_nacimiento)
    VALUES (p_nombre, p_apellidos, p_dni, p_email, p_telefono, p_direccion, p_fecha_nacimiento);

    -- Obtener el ID de la persona recién creada
    SET v_persona_id = LAST_INSERT_ID();

    -- Insertar el nuevo usuario en la tabla usuarios
    INSERT INTO usuarios (persona_id, username, password_hash, rol_id, activo, token)
    VALUES (v_persona_id, p_username, v_password_hash, p_rol_id, TRUE, v_token);
END //

DELIMITER ;
-- Ejemplo 
CALL crear_persona_y_usuario(
    'Juan',                -- nombre
    'Pérez',               -- apellidos
    '12345678A',           -- dni
    'juan.perez@example.com', -- email
    '555-1234',           -- telefono
    'Calle Falsa 123',    -- direccion
    '1990-05-15',         -- fecha_nacimiento
    'juanperez',          -- username
    'contraseñaSegura',   -- password
    2                     -- rol_id
);

-- Para crear persona empresa y realacionarla
DELIMITER //

CREATE PROCEDURE crear_persona_y_empresa (
    -- Parámetros para la empresa
    IN p_empresa_nombre VARCHAR(100),
    IN p_empresa_cif VARCHAR(20),
    IN p_empresa_direccion VARCHAR(255),
    IN p_empresa_telefono VARCHAR(15),
    IN p_empresa_email VARCHAR(100),
    
    -- Parámetros para la persona
    IN p_persona_nombre VARCHAR(100),
    IN p_persona_apellidos VARCHAR(100),
    IN p_persona_dni VARCHAR(20),
    IN p_persona_email VARCHAR(100),
    IN p_persona_telefono VARCHAR(15),
    IN p_persona_direccion VARCHAR(255),
    IN p_persona_fecha_nacimiento DATE,
    
    -- Parámetros para la relación entre persona y empresa
    IN p_puesto VARCHAR(100),
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_persona_id INT;
    DECLARE v_empresa_id INT;

    -- Validar si el CIF o el correo electrónico de la empresa ya existe
    IF EXISTS (SELECT 1 FROM empresas WHERE cif = p_empresa_cif OR email = p_empresa_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El CIF o el correo electrónico de la empresa ya existe.';
    END IF;

    -- Validar si el DNI o el correo electrónico de la persona ya existe
    IF EXISTS (SELECT 1 FROM personas WHERE dni = p_persona_dni OR email = p_persona_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El DNI o el correo electrónico de la persona ya existe.';
    END IF;

    -- Insertar la nueva empresa en la tabla empresas
    INSERT INTO empresas (nombre, cif, direccion, telefono, email)
    VALUES (p_empresa_nombre, p_empresa_cif, p_empresa_direccion, p_empresa_telefono, p_empresa_email);

    -- Obtener el ID de la empresa recién creada
    SET v_empresa_id = LAST_INSERT_ID();

    -- Insertar la nueva persona en la tabla personas
    INSERT INTO personas (nombre, apellidos, dni, email, telefono, direccion, fecha_nacimiento)
    VALUES (p_persona_nombre, p_persona_apellidos, p_persona_dni, p_persona_email, p_persona_telefono, p_persona_direccion, p_persona_fecha_nacimiento);

    -- Obtener el ID de la persona recién creada
    SET v_persona_id = LAST_INSERT_ID();

    -- Insertar la relación entre la persona y la empresa en la tabla personas_empresas
    INSERT INTO personas_empresas (persona_id, empresa_id, puesto, fecha_inicio, fecha_fin)
    VALUES (v_persona_id, v_empresa_id, IFNULL(p_puesto, 'Persona de contacto'), CURRENT_DATE, p_fecha_fin);
END //
-- Ejemplo
CALL crear_persona_y_empresa(
    'Tech Solutions',              -- empresa_nombre
    'B12345678',                   -- empresa_cif
    'Av. Innovación 123',          -- empresa_direccion
    '555-9876',                    -- empresa_telefono
    'info@techsolutions.com',      -- empresa_email
    
    'Ana',                         -- persona_nombre
    'Gómez',                       -- persona_apellidos
    '98765432B',                   -- persona_dni
    'ana.gomez@example.com',       -- persona_email
    '555-4321',                    -- persona_telefono
    'Calle Creativa 456',          -- persona_direccion
    '1985-11-30',                  -- persona_fecha_nacimiento
    
    'Gerente',                     -- puesto (opcional)
    NULL                          -- fecha_fin (opcional)
);

DELIMITER ;
