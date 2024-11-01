-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-10-2024 a las 23:56:20
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `fact1`
--
CREATE DATABASE IF NOT EXISTS `fact1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `fact1`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `CambiarContrasena`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CambiarContrasena` (IN `p_persona_id` INT, IN `p_contrasena_antigua` VARCHAR(255), IN `p_nueva_contrasena` VARCHAR(255))   BEGIN
    DECLARE v_password_hash VARCHAR(255);
    DECLARE v_token VARCHAR(255);

    -- Obtener el hash de la contraseña actual
    SELECT password_hash INTO v_password_hash
    FROM usuarios
    WHERE persona_id = p_persona_id;

    -- Verificar si la contraseña antigua coincide
    IF v_password_hash = SHA2(p_contrasena_antigua, 256) THEN
        -- Generar un nuevo token
        SET v_token = UUID();

        -- Actualizar la contraseña con el nuevo hash y el token
        UPDATE usuarios
        SET password_hash = SHA2(p_nueva_contrasena, 256), token = v_token
        WHERE persona_id = p_persona_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La contraseña antigua no es correcta.';
    END IF;
END$$

DROP PROCEDURE IF EXISTS `crear_empresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_empresa` (IN `p_nombre` VARCHAR(100), IN `p_cif` VARCHAR(20), IN `p_direccion` VARCHAR(255), IN `p_telefono` VARCHAR(15), IN `p_email` VARCHAR(100))   BEGIN
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
END$$

DROP PROCEDURE IF EXISTS `crear_persona`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_persona` (IN `p_nombre` VARCHAR(100), IN `p_apellidos` VARCHAR(100), IN `p_dni` VARCHAR(20), IN `p_email` VARCHAR(100), IN `p_telefono` VARCHAR(15), IN `p_direccion` VARCHAR(255), IN `p_fecha_nacimiento` DATE, IN `p_pais` VARCHAR(50), IN `p_provincia` VARCHAR(50), IN `p_localidad` VARCHAR(50), IN `p_cp` VARCHAR(10))   BEGIN
    -- Verificar si el DNI o Email ya existen
    IF EXISTS (SELECT 1 FROM personas WHERE dni = p_dni) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El DNI ya existe.';
    ELSEIF EXISTS (SELECT 1 FROM personas WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El email ya existe.';
    ELSE
        -- Insertar el nuevo registro en la tabla personas
        INSERT INTO personas (nombre, apellidos, dni, email, telefono, direccion, fecha_nacimiento,pais,provincia,localidad,cp)
        VALUES (p_nombre, p_apellidos, p_dni, p_email, p_telefono, p_direccion, p_fecha_nacimiento,p_pais,p_provincia,p_localidad,p_cp);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `crear_persona_y_empresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_persona_y_empresa` (IN `p_empresa_nombre` VARCHAR(100), IN `p_empresa_cif` VARCHAR(20), IN `p_empresa_direccion` VARCHAR(255), IN `p_empresa_telefono` VARCHAR(15), IN `p_empresa_email` VARCHAR(100), IN `p_persona_nombre` VARCHAR(100), IN `p_persona_apellidos` VARCHAR(100), IN `p_persona_dni` VARCHAR(20), IN `p_persona_email` VARCHAR(100), IN `p_persona_telefono` VARCHAR(15), IN `p_persona_direccion` VARCHAR(255), IN `p_persona_fecha_nacimiento` DATE, IN `p_puesto` VARCHAR(100), IN `p_fecha_fin` DATE, IN `p_pais` VARCHAR(50), IN `p_provincia` VARCHAR(50), IN `p_localidad` VARCHAR(50), IN `p_cp` VARCHAR(6))   BEGIN
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
    INSERT INTO personas (nombre, apellidos, dni, email, telefono, direccion, fecha_nacimiento,pais,provincia,localidad,cp)
    VALUES (p_nombre, p_apellidos, p_dni, p_email, p_telefono, p_direccion, p_fecha_nacimiento,p_pais,p_provincia,p_localidad,p_cp);
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
END$$

DROP PROCEDURE IF EXISTS `crear_persona_y_usuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_persona_y_usuario` (IN `p_nombre` VARCHAR(100), IN `p_apellidos` VARCHAR(100), IN `p_dni` VARCHAR(20), IN `p_email` VARCHAR(100), IN `p_telefono` VARCHAR(15), IN `p_direccion` VARCHAR(255), IN `p_fecha_nacimiento` DATE, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_rol_id` INT, IN `p_pais` VARCHAR(50), IN `p_provincia` VARCHAR(50), IN `p_localidad` VARCHAR(50), IN `p_cp` VARCHAR(6))   BEGIN
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
    INSERT INTO personas (nombre, apellidos, dni, email, telefono, direccion, fecha_nacimiento,pais,provincia,localidad,cp)
    VALUES (p_nombre, p_apellidos, p_dni, p_email, p_telefono, p_direccion, p_fecha_nacimiento,p_pais,p_provincia,p_localidad,p_cp);

    -- Obtener el ID de la persona recién creada
    SET v_persona_id = LAST_INSERT_ID();

    -- Insertar el nuevo usuario en la tabla usuarios
    INSERT INTO usuarios (persona_id, username, password_hash, rol_id, activo, token)
    VALUES (v_persona_id, p_username, v_password_hash, p_rol_id, TRUE, v_token);
END$$

DROP PROCEDURE IF EXISTS `EditarPersona`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EditarPersona` (IN `p_id` INT, IN `p_nombre` VARCHAR(100), IN `p_apellidos` VARCHAR(100), IN `p_dni` VARCHAR(20), IN `p_email` VARCHAR(100), IN `p_telefono` VARCHAR(15), IN `p_direccion` VARCHAR(255), IN `p_pais` VARCHAR(30), IN `p_localidad` VARCHAR(30), IN `p_cp` VARCHAR(5), IN `p_provincia` VARCHAR(30), IN `p_fecha_nacimiento` DATE)   BEGIN
    UPDATE personas
    SET 
        nombre = p_nombre,
        apellidos = p_apellidos,
        dni = p_dni,
        email = p_email,
        telefono = p_telefono,
        direccion = p_direccion,
        Pais = p_pais,
        Localidad = p_localidad,
        CP = p_cp,
        provincia = p_provincia,
        fecha_nacimiento = p_fecha_nacimiento
    WHERE id = p_id;
END$$

DROP PROCEDURE IF EXISTS `iniciar_sesion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciar_sesion` (IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), OUT `p_username_result` VARCHAR(50), OUT `p_rol_id` INT, OUT `p_persona_id` INT, OUT `p_perfil` VARCHAR(255))   BEGIN
    -- Seleccionar las columnas disponibles
    SELECT username, rol_id , persona_id, perfil
    INTO p_username_result, p_rol_id, p_persona_id, p_perfil
    FROM usuarios
    WHERE username = p_username
    AND password_hash = SHA2(p_password, 256); -- Ajusta el método de hash si es necesario
END$$

DROP PROCEDURE IF EXISTS `insertarUsuarioEmpresa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarUsuarioEmpresa` (IN `p_empresa_id` INT)   BEGIN
    DECLARE v_usuario_id INT;
    DECLARE v_fecha_inicio DATE;
    DECLARE v_fecha_fin DATE;

    -- 1. Obtener el usuario_id más reciente de la tabla usuarios
    SELECT id INTO v_usuario_id
    FROM usuarios
    ORDER BY id DESC
    LIMIT 1;

    -- 2. Definir la fecha de inicio como la fecha actual
    SET v_fecha_inicio = CURDATE();

    -- 3. Definir la fecha de fin como un año después de la fecha de inicio
    SET v_fecha_fin = DATE_ADD(v_fecha_inicio, INTERVAL 1 YEAR);

    -- 4. Insertar el nuevo registro en la tabla usuario_empresas
    INSERT INTO usuario_empresas (usuario_id, empresa_id, fecha_inicio, fecha_fin)
    VALUES (v_usuario_id, p_empresa_id, v_fecha_inicio, v_fecha_fin);
END$$

DROP PROCEDURE IF EXISTS `insertar_usuario_empresaID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_usuario_empresaID` (IN `p_empresa_id` INT)   BEGIN
    -- Insertar datos en la tabla 'usuario_empresas'
    INSERT INTO usuario_empresas (usuario_id, empresa_id, fecha_inicio, fecha_fin)
    VALUES (
        (SELECT id FROM usuarios ORDER BY id DESC LIMIT 1), -- Obtener el último usuario_id
        p_empresa_id, -- Recibe el id de la empresa como parámetro
        CURDATE(), -- fecha_inicio (Hoy)
        DATE_ADD(CURDATE(), INTERVAL 1 YEAR) -- fecha_fin (Un año después)
    );
END$$

DROP PROCEDURE IF EXISTS `registrar_usuario_old`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_usuario_old` (IN `p_persona_id` INT, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_rol_id` INT)   BEGIN
    DECLARE v_password_hash VARCHAR(255);
    DECLARE v_token VARCHAR(255);

    -- Generar hash para la contraseña usando SHA2 (ejemplo, para producción usa una librería especializada en tu aplicación)
    SET v_password_hash = SHA2(p_password, 256);
    
    -- Generar un token único (ejemplo básico, en producción usa un enfoque más seguro)
    SET v_token = UUID();
    
    -- Insertar el nuevo usuario
    INSERT INTO usuarios (persona_id, username, password_hash, rol_id, activo, token)
    VALUES (p_persona_id, p_username, v_password_hash, p_rol_id, TRUE, v_token);
END$$

DROP PROCEDURE IF EXISTS `subirFoto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `subirFoto` (IN `p_persona_id` INT, IN `p_foto` VARCHAR(255))   BEGIN
    -- Verificar si el persona_id coincide con el id de la tabla
    IF EXISTS (SELECT 1 FROM usuarios WHERE  persona_id = p_persona_id) THEN
        -- Actualizar el perfil con la nueva foto
        UPDATE usuarios
        SET perfil = p_foto
        WHERE persona_id = p_persona_id;
    ELSE
        -- Si no coincide, se puede lanzar un mensaje de error (opcional)
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El persona_id no coincide con ningún id en la tabla usuarios.';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacenes`
--

DROP TABLE IF EXISTS `almacenes`;
CREATE TABLE `almacenes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `ubicacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

DROP TABLE IF EXISTS `articulos`;
CREATE TABLE `articulos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_familia` int(11) DEFAULT NULL,
  `id_empresa` int(11) NOT NULL,
  `precio_base` decimal(10,2) NOT NULL,
  `iva` decimal(5,2) NOT NULL,
  `stock_minimo` int(11) DEFAULT 0,
  `stock_actual` int(11) DEFAULT 0,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `articulos`
--

INSERT INTO `articulos` (`id`, `nombre`, `descripcion`, `id_familia`, `id_empresa`, `precio_base`, `iva`, `stock_minimo`, `stock_actual`, `estado`) VALUES
(1, 'Pala de mano', 'Pala pequeña ideal para trasplantar plantas', 1, 1, 5.99, 21.00, 10, 50, 'activo'),
(2, 'Rastrillo', 'Herramienta para remover el suelo', 1, 1, 7.50, 21.00, 5, 30, 'activo'),
(3, 'Tijeras de podar', 'Tijeras para cortar ramas pequeñas', 1, 1, 12.99, 21.00, 5, 20, 'activo'),
(4, 'Azada', 'Herramienta para arar y remover tierra', 1, 1, 15.00, 21.00, 3, 15, 'activo'),
(5, 'Machete', 'Herramienta para cortar maleza', 1, 1, 10.50, 21.00, 2, 25, 'activo'),
(6, 'Guantes de jardinería', 'Guantes protectores para trabajos de jardinería', 1, 1, 3.99, 21.00, 20, 100, 'activo'),
(7, 'Cuchillo de injertos', 'Herramienta específica para injertar plantas', 1, 1, 9.99, 21.00, 2, 10, 'activo'),
(8, 'Horca de mano', 'Herramienta para descompactar el suelo', 1, 1, 6.99, 21.00, 5, 30, 'activo'),
(9, 'Serrucho', 'Sierra pequeña para cortar ramas', 1, 1, 11.50, 21.00, 3, 18, 'activo'),
(10, 'Cepillo de limpieza', 'Cepillo para limpiar herramientas y macetas', 1, 1, 4.50, 21.00, 10, 60, 'activo'),
(11, 'Rosa', 'Planta ornamental de flores fragantes', 2, 1, 3.99, 21.00, 5, 40, 'activo'),
(12, 'Cactus', 'Planta suculenta resistente al calor', 2, 1, 2.50, 21.00, 10, 70, 'activo'),
(13, 'Lavanda', 'Planta aromática con propiedades relajantes', 2, 1, 4.99, 21.00, 5, 30, 'activo'),
(14, 'Helecho', 'Planta decorativa ideal para zonas de sombra', 2, 1, 5.99, 21.00, 4, 25, 'activo'),
(15, 'Bonsái', 'Árbol en miniatura de crecimiento controlado', 2, 1, 20.00, 21.00, 1, 10, 'activo'),
(16, 'Aloe Vera', 'Planta medicinal con propiedades curativas', 2, 1, 6.50, 21.00, 5, 35, 'activo'),
(17, 'Hortensia', 'Planta ornamental con flores grandes y coloridas', 2, 1, 7.99, 21.00, 3, 20, 'activo'),
(18, 'Palmera', 'Planta de exterior resistente al calor', 2, 1, 15.00, 21.00, 2, 12, 'activo'),
(19, 'Orquídea', 'Planta de interior con flores delicadas', 2, 1, 10.99, 21.00, 2, 15, 'activo'),
(20, 'Geranio', 'Planta con flores de colores brillantes', 2, 1, 3.50, 21.00, 6, 50, 'activo'),
(21, 'Tierra para macetas', 'Sustrato universal para todo tipo de plantas', 3, 1, 7.99, 21.00, 10, 80, 'activo'),
(22, 'Abono orgánico', 'Fertilizante natural para enriquecer el suelo', 3, 1, 12.50, 21.00, 5, 40, 'activo'),
(23, 'Compost', 'Material orgánico descompuesto para mejorar el suelo', 3, 1, 5.99, 21.00, 8, 50, 'activo'),
(24, 'Sustrato para cactus', 'Sustrato especial para plantas suculentas', 3, 1, 6.50, 21.00, 4, 30, 'activo'),
(25, 'Fertilizante para rosales', 'Fertilizante específico para mejorar el crecimiento de rosas', 3, 1, 9.99, 21.00, 3, 25, 'activo'),
(26, 'Humus de lombriz', 'Fertilizante natural y orgánico rico en nutrientes', 3, 1, 8.50, 21.00, 6, 45, 'activo'),
(27, 'Tierra volcánica', 'Sustrato de origen volcánico para mejorar la aireación del suelo', 3, 1, 7.00, 21.00, 3, 20, 'activo'),
(28, 'Fertilizante líquido', 'Fertilizante de rápida absorción para plantas de interior', 3, 1, 11.50, 21.00, 4, 35, 'activo'),
(29, 'Tierra ácida', 'Sustrato especial para plantas acidófilas', 3, 1, 6.99, 21.00, 3, 30, 'activo'),
(30, 'Fertilizante granulado', 'Fertilizante de liberación lenta para todo tipo de plantas', 3, 1, 9.50, 21.00, 5, 40, 'activo'),
(31, 'Aspersor automático', 'Aspersor de riego programable', 4, 1, 25.99, 21.00, 3, 15, 'activo'),
(32, 'Manguera de jardín', 'Manguera de 20 metros para riego manual', 4, 1, 18.50, 21.00, 5, 40, 'activo'),
(33, 'Programador de riego', 'Dispositivo para programar el riego automáticamente', 4, 1, 35.00, 21.00, 2, 10, 'activo'),
(34, 'Kit de riego por goteo', 'Sistema completo de riego por goteo para jardín', 4, 1, 40.00, 21.00, 3, 12, 'activo'),
(35, 'Conector de mangueras', 'Conector rápido para unir mangueras de riego', 4, 1, 3.99, 21.00, 10, 100, 'activo'),
(36, 'Pistola de riego', 'Accesorio para controlar la presión del agua en el riego', 4, 1, 9.99, 21.00, 5, 50, 'activo'),
(37, 'Regadera', 'Recipiente manual para regar plantas', 4, 1, 12.50, 21.00, 6, 35, 'activo'),
(38, 'Filtro de riego', 'Filtro para evitar obstrucciones en el sistema de riego', 4, 1, 6.99, 21.00, 4, 30, 'activo'),
(39, 'Soporte de manguera', 'Soporte de pared para colgar mangueras de riego', 4, 1, 7.99, 21.00, 5, 40, 'activo'),
(40, 'Tubo de riego subterráneo', 'Tubo flexible para sistemas de riego enterrados', 4, 1, 50.00, 21.00, 2, 8, 'activo'),
(41, 'Estatua de jardín', 'Estatua decorativa para exteriores', 5, 1, 45.00, 21.00, 1, 5, 'activo'),
(42, 'Farol solar', 'Farol decorativo con iluminación solar', 5, 1, 20.99, 21.00, 3, 20, 'activo'),
(43, 'Macetero de piedra', 'Macetero grande de piedra para plantas', 5, 1, 35.00, 21.00, 2, 10, 'activo'),
(44, 'Fuente de agua', 'Fuente decorativa para jardín con sistema de recirculación de agua', 5, 1, 80.00, 21.00, 1, 3, 'activo'),
(45, 'Enanito de jardín', 'Figura decorativa clásica de jardín', 5, 1, 12.50, 21.00, 5, 25, 'activo'),
(46, 'Caminos de piedra', 'Set de piedras decorativas para caminos en el jardín', 5, 1, 25.00, 21.00, 4, 15, 'activo'),
(47, 'Pérgola de madera', 'Estructura de madera para proporcionar sombra', 5, 1, 150.00, 21.00, 1, 2, 'activo'),
(48, 'Luz LED para exteriores', 'Luz LED de bajo consumo para decorar el jardín', 5, 1, 18.50, 21.00, 3, 20, 'activo'),
(49, 'Banco de jardín', 'Banco de madera para sentarse en el jardín', 5, 1, 60.00, 21.00, 1, 5, 'activo'),
(50, 'Jardineras colgantes', 'Jardineras decorativas para colgar en exteriores', 5, 1, 30.00, 21.00, 2, 12, 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos_servicios`
--

DROP TABLE IF EXISTS `articulos_servicios`;
CREATE TABLE `articulos_servicios` (
  `id_item` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cierres_contables`
--

DROP TABLE IF EXISTS `cierres_contables`;
CREATE TABLE `cierres_contables` (
  `id_cierre` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `saldo_final` decimal(10,2) NOT NULL,
  `fecha_cierre` datetime NOT NULL,
  `notas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

DROP TABLE IF EXISTS `compras`;
CREATE TABLE `compras` (
  `id` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `fecha_compra` date NOT NULL,
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_compras`
--

DROP TABLE IF EXISTS `detalle_compras`;
CREATE TABLE `detalle_compras` (
  `id` int(11) NOT NULL,
  `id_compra` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

DROP TABLE IF EXISTS `empresas`;
CREATE TABLE `empresas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cif` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `Pais` varchar(30) NOT NULL,
  `Localidad` varchar(30) NOT NULL,
  `CP` varchar(5) NOT NULL,
  `provincia` varchar(30) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas_id`
--

DROP TABLE IF EXISTS `empresas_id`;
CREATE TABLE `empresas_id` (
  `id_empresa` int(11) NOT NULL,
  `nombre_empresa` varchar(255) NOT NULL,
  `NOMBRE_FISCAL` varchar(85) NOT NULL,
  `direccion_empresa` varchar(255) DEFAULT NULL,
  `telefono_empresa` varchar(20) DEFAULT NULL,
  `email_empresa` varchar(100) DEFAULT NULL,
  `nif` varchar(20) NOT NULL,
  `Pais` varchar(50) NOT NULL,
  `Localidad` varchar(50) NOT NULL,
  `CP` varchar(10) NOT NULL,
  `Provincia` varchar(50) NOT NULL,
  `logo_empresa` varchar(255) DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empresas_id`
--

INSERT INTO `empresas_id` (`id_empresa`, `nombre_empresa`, `NOMBRE_FISCAL`, `direccion_empresa`, `telefono_empresa`, `email_empresa`, `nif`, `Pais`, `Localidad`, `CP`, `Provincia`, `logo_empresa`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 'Gus-Fact.SL', 'GUS-FACT', 'C\\ Fra Antonio Llinas Nº19', '672835671', 'info@gus-fact.com', 'b4512135', 'España', 'Andratx', '07150', 'Islas Baleares', 'uploads/emp1.png\r\n', '2023-01-01', '2025-12-31'),
(2, 'Prueba', 'prueba s.l.', 'calle falsa 5', '987654321', 'prueba@test.com', '45612385K', 'España', 'Paguera', '07010', 'baleares', 'uploads/emp1.png', '2024-09-01', '2025-02-02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `faclin`
--

DROP TABLE IF EXISTS `faclin`;
CREATE TABLE `faclin` (
  `id_cliente` int(11) DEFAULT NULL,
  `id_Serie` int(11) DEFAULT NULL,
  `id_empresas` int(11) DEFAULT NULL,
  `Id_articulos` int(11) DEFAULT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `nombreArt_Serv` varchar(255) DEFAULT NULL,
  `descripcionArt_Serv` text DEFAULT NULL,
  `precioUnit` decimal(10,2) DEFAULT NULL,
  `unidades` int(11) DEFAULT NULL,
  `descuento_por` decimal(5,2) DEFAULT NULL,
  `descuento` decimal(10,2) DEFAULT NULL,
  `IVA_por` decimal(5,2) DEFAULT NULL,
  `impuesto` decimal(10,2) DEFAULT NULL,
  `Subtotal` decimal(10,2) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo_fact` varchar(255) DEFAULT NULL,
  `usuario` varchar(25) DEFAULT NULL,
  `factura` int(11) DEFAULT NULL,
  `id_df` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

DROP TABLE IF EXISTS `facturas`;
CREATE TABLE `facturas` (
  `id_factura` int(11) NOT NULL,
  `factura` int(11) NOT NULL,
  `id_serie` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_factura` date NOT NULL,
  `descuento_global` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado_factura` enum('pendiente','pagada','cancelada') DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `familias`
--

DROP TABLE IF EXISTS `familias`;
CREATE TABLE `familias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `familias`
--

INSERT INTO `familias` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Herramientas manuales', 'Herramientas utilizadas para labores de jardinería manual'),
(2, 'Plantas', 'Diversas plantas ornamentales y funcionales para el jardín'),
(3, 'Sustratos y fertilizantes', 'Materiales y nutrientes para mejorar la calidad del suelo'),
(4, 'Sistema de riego', 'Equipos y accesorios para riego automático o manual'),
(5, 'Decoración exterior', 'Artículos para embellecer el jardín con elementos decorativos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

DROP TABLE IF EXISTS `inventario`;
CREATE TABLE `inventario` (
  `id` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `id_almacen` int(11) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `iva`
--

DROP TABLE IF EXISTS `iva`;
CREATE TABLE `iva` (
  `idIVA` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `porcentaje` float DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `iva`
--

INSERT INTO `iva` (`idIVA`, `nombre`, `porcentaje`, `empresa`) VALUES
(2, 'IVA reducido 10%', 10, 1),
(3, 'IVA superreducido 4%', 4, 1),
(1, 'IVA estándar 21%', 21, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `iva_productos`
--

DROP TABLE IF EXISTS `iva_productos`;
CREATE TABLE `iva_productos` (
  `id` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `porcentaje_iva` decimal(5,2) NOT NULL,
  `fecha_aplicacion` date NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `iva_productos`
--

INSERT INTO `iva_productos` (`id`, `id_articulo`, `porcentaje_iva`, `fecha_aplicacion`, `id_iva`) VALUES
(1, 1, 21.00, '2024-10-15', 1),
(2, 2, 21.00, '2024-10-15', 1),
(3, 3, 21.00, '2024-10-15', 1),
(4, 4, 21.00, '2024-10-15', 1),
(5, 5, 21.00, '2024-10-15', 1),
(6, 6, 21.00, '2024-10-15', 1),
(7, 7, 21.00, '2024-10-15', 1),
(8, 8, 21.00, '2024-10-15', 1),
(9, 9, 21.00, '2024-10-15', 1),
(10, 10, 21.00, '2024-10-15', 1),
(11, 11, 21.00, '2024-10-15', 1),
(12, 12, 21.00, '2024-10-15', 1),
(13, 13, 21.00, '2024-10-15', 1),
(14, 14, 21.00, '2024-10-15', 1),
(15, 15, 21.00, '2024-10-15', 1),
(16, 16, 21.00, '2024-10-15', 1),
(17, 17, 21.00, '2024-10-15', 1),
(18, 18, 21.00, '2024-10-15', 1),
(19, 19, 21.00, '2024-10-15', 1),
(20, 20, 21.00, '2024-10-15', 1),
(21, 21, 21.00, '2024-10-15', 1),
(22, 22, 21.00, '2024-10-15', 1),
(23, 23, 21.00, '2024-10-15', 1),
(24, 24, 21.00, '2024-10-15', 1),
(25, 25, 21.00, '2024-10-15', 1),
(26, 26, 21.00, '2024-10-15', 1),
(27, 27, 21.00, '2024-10-15', 1),
(28, 28, 21.00, '2024-10-15', 1),
(29, 29, 21.00, '2024-10-15', 1),
(30, 30, 21.00, '2024-10-15', 1),
(31, 31, 21.00, '2024-10-15', 1),
(32, 32, 21.00, '2024-10-15', 1),
(33, 33, 21.00, '2024-10-15', 1),
(34, 34, 21.00, '2024-10-15', 1),
(35, 35, 21.00, '2024-10-15', 1),
(36, 36, 21.00, '2024-10-15', 1),
(37, 37, 21.00, '2024-10-15', 1),
(38, 38, 21.00, '2024-10-15', 1),
(39, 39, 21.00, '2024-10-15', 1),
(40, 40, 21.00, '2024-10-15', 1),
(41, 41, 21.00, '2024-10-15', 1),
(42, 42, 21.00, '2024-10-15', 1),
(43, 43, 21.00, '2024-10-15', 1),
(44, 44, 21.00, '2024-10-15', 1),
(45, 45, 21.00, '2024-10-15', 1),
(46, 46, 21.00, '2024-10-15', 1),
(47, 47, 21.00, '2024-10-15', 1),
(48, 48, 21.00, '2024-10-15', 1),
(49, 49, 21.00, '2024-10-15', 1),
(50, 50, 21.00, '2024-10-15', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

DROP TABLE IF EXISTS `personas`;
CREATE TABLE `personas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `Pais` varchar(30) NOT NULL,
  `Localidad` varchar(30) NOT NULL,
  `CP` varchar(5) NOT NULL,
  `provincia` varchar(30) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id`, `nombre`, `apellidos`, `dni`, `email`, `telefono`, `direccion`, `Pais`, `Localidad`, `CP`, `provincia`, `fecha_nacimiento`, `created_at`) VALUES
(1, 'Prueba', 'Prueba', '45371224R', 'gusaljr6-@gmail.com', '672835672', 'calle sallent 66 2 piso', 'España', 'Andratx', '07150', 'Islas Baleares', '1996-01-06', '2024-09-03 17:41:27'),
(2, 'Gustavo Alonso ', 'Baquerizo Moreira', '45371227R', 'gusaljr6@gmail.com', '672835671', 'c/ Fra Antonio Llinas 19', '', '', '', '', '1996-01-06', '2024-09-06 19:16:47'),
(3, 'Gustavo Alonso 2', 'Baquerizo Moreira', '45371227R2', 'gusaljr6@gmail.com2', '672835671', 'c/ Fra Antonio Llinas 19', '', '', '', '', '1996-01-06', '2024-09-06 19:19:41'),
(5, 'Desiree ', 'Salvador', '456123456l', 'ghjhgh@hgjhg.com', '602524692', 'calle futura2', 'españa', 'andratcx', '07150', 'baleares', '2001-01-01', '2024-09-13 18:03:08'),
(6, 'DESIREE ', 'SALVADOR SAMBRUNO', '48410135S', 'DESI@GMAIL.COM', '971235324', 'CALLE FRA ANTONIO LLINAS 19', 'España', 'Andratx', '07150', 'Baleares', '0000-00-00', '2024-09-21 18:57:22'),
(11, 'Victor', 'Vilela Morera', '45371227R3', 'vicvil@gmail.com', '987654321', 'calle sallent66', 'España', 'Andratx', '07150', 'baleres', '2024-10-10', '2024-10-07 18:43:31'),
(12, 'Victor', 'Vilela Morera', '45371227R8', 'vicvil@gmail.com8', '987654321', 'calle sallent66', 'España', 'Andratx', '07150', 'baleres', '2024-10-08', '2024-10-07 18:44:07'),
(13, 'Victor', 'Vilela Morera', '45371227R5', 'vicvil@gmail.com5', '987654321', 'calle sallent66', 'España', 'Andratx', '07150', 'baleres', '2024-10-25', '2024-10-07 19:17:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas_empresas`
--

DROP TABLE IF EXISTS `personas_empresas`;
CREATE TABLE `personas_empresas` (
  `id` int(11) NOT NULL,
  `persona_id` int(11) DEFAULT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `puesto` varchar(100) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios_punto_venta`
--

DROP TABLE IF EXISTS `precios_punto_venta`;
CREATE TABLE `precios_punto_venta` (
  `id` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `id_punto_venta` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntos_venta`
--

DROP TABLE IF EXISTS `puntos_venta`;
CREATE TABLE `puntos_venta` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `ubicacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`) VALUES
(1, 'Administrador'),
(2, 'Gerente'),
(3, 'Usuario'),
(4, 'Editor'),
(5, 'Soporte Técnico'),
(6, 'Auditor'),
(7, 'Cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `series_facturacion`
--

DROP TABLE IF EXISTS `series_facturacion`;
CREATE TABLE `series_facturacion` (
  `id_serie` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `nombre_serie` varchar(100) NOT NULL,
  `prefijo_serie` varchar(10) DEFAULT NULL,
  `numero_actual` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `series_facturacion`
--

INSERT INTO `series_facturacion` (`id_serie`, `id_empresa`, `nombre_serie`, `prefijo_serie`, `numero_actual`) VALUES
(1, 1, 'Factura General', '2024F', 0),
(2, 1, 'Factura Simplificada', '2024FS', 0),
(3, 1, 'Factura Proforma', '2024FP', 0),
(4, 1, 'Albarán', '2024A', 0),
(5, 1, 'Presupuesto', '2024P', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `stock_movimientos`
--

DROP TABLE IF EXISTS `stock_movimientos`;
CREATE TABLE `stock_movimientos` (
  `id` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `id_almacen` int(11) NOT NULL,
  `tipo_movimiento` enum('entrada','salida') NOT NULL,
  `cantidad` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `motivo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `persona_id` int(11) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `token` varchar(255) DEFAULT NULL,
  `perfil` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `persona_id`, `username`, `password_hash`, `rol_id`, `activo`, `token`, `perfil`) VALUES
(1, 1, 'gusaljr', 'a6c89c1de8abd6b6c4879a329f05252818c77abc3f4830724c2f57118207576d', 1, 1, 'e5b11001-7849-11ef-aa5d-00ff6e754067', 'public/static/img/avatars/avatar.jpg'),
(5, 6, 'DESI', 'cd0999413d9c56e336e2ff2fcafe949cf08adef3adb624f2b4df0e6bdbe5faae', 1, 1, '6ebf4c21-784d-11ef-aa5d-00ff6e754067', 'fotos/pngegg.png'),
(10, 11, 'desi4', 'cd0999413d9c56e336e2ff2fcafe949cf08adef3adb624f2b4df0e6bdbe5faae', 1, 1, '1da42a67-84dc-11ef-91eb-00ff6e754067', ''),
(11, 12, 'desi8', 'cd0999413d9c56e336e2ff2fcafe949cf08adef3adb624f2b4df0e6bdbe5faae', 1, 1, '3392291d-84dc-11ef-91eb-00ff6e754067', ''),
(12, 13, 'desi5', 'cd0999413d9c56e336e2ff2fcafe949cf08adef3adb624f2b4df0e6bdbe5faae', 1, 1, 'e74aa3b9-84e0-11ef-91eb-00ff6e754067', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_empresas`
--

DROP TABLE IF EXISTS `usuario_empresas`;
CREATE TABLE `usuario_empresas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_empresas`
--

INSERT INTO `usuario_empresas` (`id`, `usuario_id`, `empresa_id`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 5, 1, '2024-01-01', '2026-12-31'),
(2, 5, 2, '2024-09-01', '2024-12-31'),
(3, 11, 1, '2024-10-07', '2025-10-07'),
(4, 11, 2, '2024-10-07', '2025-10-07');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacenes`
--
ALTER TABLE `almacenes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_familia` (`id_familia`),
  ADD KEY `id_empresa` (`id_empresa`);

--
-- Indices de la tabla `articulos_servicios`
--
ALTER TABLE `articulos_servicios`
  ADD PRIMARY KEY (`id_item`);

--
-- Indices de la tabla `cierres_contables`
--
ALTER TABLE `cierres_contables`
  ADD PRIMARY KEY (`id_cierre`),
  ADD KEY `id_empresa` (`id_empresa`);

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalle_compras`
--
ALTER TABLE `detalle_compras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_compra` (`id_compra`),
  ADD KEY `id_articulo` (`id_articulo`);

--
-- Indices de la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cif` (`cif`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `empresas_id`
--
ALTER TABLE `empresas_id`
  ADD PRIMARY KEY (`id_empresa`);

--
-- Indices de la tabla `faclin`
--
ALTER TABLE `faclin`
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_Serie` (`id_Serie`),
  ADD KEY `id_empresas` (`id_empresas`),
  ADD KEY `Id_articulos` (`Id_articulos`),
  ADD KEY `id_factura` (`id_factura`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id_factura`),
  ADD KEY `id_serie` (`id_serie`),
  ADD KEY `fk_factura_cliente` (`id_cliente`);

--
-- Indices de la tabla `familias`
--
ALTER TABLE `familias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_articulo` (`id_articulo`),
  ADD KEY `id_almacen` (`id_almacen`);

--
-- Indices de la tabla `iva_productos`
--
ALTER TABLE `iva_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_articulo` (`id_articulo`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `personas_empresas`
--
ALTER TABLE `personas_empresas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `persona_id` (`persona_id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Indices de la tabla `precios_punto_venta`
--
ALTER TABLE `precios_punto_venta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_articulo` (`id_articulo`),
  ADD KEY `id_punto_venta` (`id_punto_venta`);

--
-- Indices de la tabla `puntos_venta`
--
ALTER TABLE `puntos_venta`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `series_facturacion`
--
ALTER TABLE `series_facturacion`
  ADD PRIMARY KEY (`id_serie`),
  ADD KEY `id_empresa` (`id_empresa`);

--
-- Indices de la tabla `stock_movimientos`
--
ALTER TABLE `stock_movimientos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_articulo` (`id_articulo`),
  ADD KEY `id_almacen` (`id_almacen`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `persona_id` (`persona_id`),
  ADD KEY `rol_id` (`rol_id`);

--
-- Indices de la tabla `usuario_empresas`
--
ALTER TABLE `usuario_empresas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacenes`
--
ALTER TABLE `almacenes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `articulos`
--
ALTER TABLE `articulos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT de la tabla `articulos_servicios`
--
ALTER TABLE `articulos_servicios`
  MODIFY `id_item` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cierres_contables`
--
ALTER TABLE `cierres_contables`
  MODIFY `id_cierre` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_compras`
--
ALTER TABLE `detalle_compras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresas`
--
ALTER TABLE `empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresas_id`
--
ALTER TABLE `empresas_id`
  MODIFY `id_empresa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id_factura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `familias`
--
ALTER TABLE `familias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `iva_productos`
--
ALTER TABLE `iva_productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `personas_empresas`
--
ALTER TABLE `personas_empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `precios_punto_venta`
--
ALTER TABLE `precios_punto_venta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `puntos_venta`
--
ALTER TABLE `puntos_venta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `series_facturacion`
--
ALTER TABLE `series_facturacion`
  MODIFY `id_serie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `stock_movimientos`
--
ALTER TABLE `stock_movimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `usuario_empresas`
--
ALTER TABLE `usuario_empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD CONSTRAINT `articulos_ibfk_1` FOREIGN KEY (`id_familia`) REFERENCES `familias` (`id`),
  ADD CONSTRAINT `articulos_ibfk_2` FOREIGN KEY (`id_empresa`) REFERENCES `empresas_id` (`id_empresa`);

--
-- Filtros para la tabla `cierres_contables`
--
ALTER TABLE `cierres_contables`
  ADD CONSTRAINT `cierres_contables_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresas_id` (`id_empresa`);

--
-- Filtros para la tabla `detalle_compras`
--
ALTER TABLE `detalle_compras`
  ADD CONSTRAINT `detalle_compras_ibfk_1` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id`),
  ADD CONSTRAINT `detalle_compras_ibfk_2` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id`);

--
-- Filtros para la tabla `faclin`
--
ALTER TABLE `faclin`
  ADD CONSTRAINT `faclin_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `personas` (`id`),
  ADD CONSTRAINT `faclin_ibfk_2` FOREIGN KEY (`id_Serie`) REFERENCES `series_facturacion` (`id_serie`),
  ADD CONSTRAINT `faclin_ibfk_3` FOREIGN KEY (`id_empresas`) REFERENCES `empresas_id` (`id_empresa`),
  ADD CONSTRAINT `faclin_ibfk_4` FOREIGN KEY (`Id_articulos`) REFERENCES `articulos` (`id`),
  ADD CONSTRAINT `faclin_ibfk_5` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id_factura`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_serie`) REFERENCES `series_facturacion` (`id_serie`),
  ADD CONSTRAINT `fk_factura_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `personas` (`id`);

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id`),
  ADD CONSTRAINT `inventario_ibfk_2` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes` (`id`);

--
-- Filtros para la tabla `iva_productos`
--
ALTER TABLE `iva_productos`
  ADD CONSTRAINT `iva_productos_ibfk_1` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id`);

--
-- Filtros para la tabla `personas_empresas`
--
ALTER TABLE `personas_empresas`
  ADD CONSTRAINT `personas_empresas_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`),
  ADD CONSTRAINT `personas_empresas_ibfk_2` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`);

--
-- Filtros para la tabla `precios_punto_venta`
--
ALTER TABLE `precios_punto_venta`
  ADD CONSTRAINT `precios_punto_venta_ibfk_1` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id`),
  ADD CONSTRAINT `precios_punto_venta_ibfk_2` FOREIGN KEY (`id_punto_venta`) REFERENCES `puntos_venta` (`id`);

--
-- Filtros para la tabla `series_facturacion`
--
ALTER TABLE `series_facturacion`
  ADD CONSTRAINT `series_facturacion_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresas_id` (`id_empresa`);

--
-- Filtros para la tabla `stock_movimientos`
--
ALTER TABLE `stock_movimientos`
  ADD CONSTRAINT `stock_movimientos_ibfk_1` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id`),
  ADD CONSTRAINT `stock_movimientos_ibfk_2` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes` (`id`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`),
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `usuario_empresas`
--
ALTER TABLE `usuario_empresas`
  ADD CONSTRAINT `usuario_empresas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `usuario_empresas_ibfk_2` FOREIGN KEY (`empresa_id`) REFERENCES `empresas_id` (`id_empresa`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
