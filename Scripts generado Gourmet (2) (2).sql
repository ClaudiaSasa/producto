-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema tienda_gourmet
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tienda_gourmet
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tienda_gourmet` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `tienda_gourmet` ;

-- -----------------------------------------------------
-- Table `tienda_gourmet`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`categorias` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(30) NOT NULL,
  `descripcion` VARCHAR(150) NULL DEFAULT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_categoria`),
  UNIQUE INDEX `nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(30) NOT NULL,
  `apellido` VARCHAR(30) NOT NULL,
  `documento` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(15) NULL DEFAULT NULL,
  `correo` VARCHAR(50) NOT NULL,
  `direccion` VARCHAR(150) NULL DEFAULT NULL,
  `ciudad` VARCHAR(50) NULL DEFAULT NULL,
  `fecha_registro` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `documento` (`documento` ASC) VISIBLE,
  UNIQUE INDEX `correo` (`correo` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`pedidos` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `fecha_pedido` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('PENDIENTE', 'CONFIRMADO', 'PREPARANDO', 'ENVIADO', 'ENTREGADO', 'CANCELADO') NULL DEFAULT 'PENDIENTE',
  `direccion_entrega` VARCHAR(50) NOT NULL,
  `total` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_cliente` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `tienda_gourmet`.`clientes` (`id_cliente`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `id_categoria` INT NOT NULL,
  `nombre` VARCHAR(30) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `precio` DECIMAL(15,2) NOT NULL,
  `stock` INT NOT NULL DEFAULT '0',
  `unidad_medida` VARCHAR(30) NULL DEFAULT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_producto`),
  INDEX `fk_producto_categoria` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_producto_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `tienda_gourmet`.`categorias` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`detalle_pedido` (
  `id_detalle` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(15,2) NOT NULL,
  `subtotal` DECIMAL(30,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  INDEX `fk_detalle_pedido` (`id_pedido` ASC) VISIBLE,
  INDEX `fk_detalle_producto` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `tienda_gourmet`.`pedidos` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `tienda_gourmet`.`productos` (`id_producto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`inventario` (
  `id_inventario` INT NOT NULL AUTO_INCREMENT,
  `id_producto` INT NOT NULL,
  `cantidad_disponible` INT NOT NULL DEFAULT '0',
  `cantidad_minima` INT NOT NULL DEFAULT '0',
  `fecha_actualizacion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_inventario`),
  UNIQUE INDEX `uq_inventario_producto` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_inventario_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `tienda_gourmet`.`productos` (`id_producto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`pagos` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NOT NULL,
  `fecha_pago` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `metodo_pago` ENUM('EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'PSE') NOT NULL,
  `valor` DECIMAL(15,2) NOT NULL,
  `estado` ENUM('PENDIENTE', 'APROBADO', 'RECHAZADO') NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (`id_pago`),
  INDEX `fk_pago_pedido` (`id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_pago_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `tienda_gourmet`.`pedidos` (`id_pedido`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tienda_gourmet`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tienda_gourmet`.`usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(50) NOT NULL,
  `contrasena` VARCHAR(255) NOT NULL,
  `rol` ENUM('ADMINISTRADOR', 'EMPLEADO') NOT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `nombre_usuario` (`nombre_usuario` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
