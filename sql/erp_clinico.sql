CREATE DATABASE IF NOT EXISTS erp_clinico
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE erp_clinico;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- 1. SEGURIDAD: USUARIOS, ROLES Y PERMISOS
-- =========================================================

DROP TABLE IF EXISTS auditoria_accesos_historia_clinica;
DROP TABLE IF EXISTS auditoria_eventos;
DROP TABLE IF EXISTS pagos;
DROP TABLE IF EXISTS metodos_pago;
DROP TABLE IF EXISTS detalle_facturas;
DROP TABLE IF EXISTS facturas;
DROP TABLE IF EXISTS diagnosticos;
DROP TABLE IF EXISTS entradas_historia_clinica;
DROP TABLE IF EXISTS historias_clinicas;
DROP TABLE IF EXISTS atenciones;
DROP TABLE IF EXISTS historial_estados_citas;
DROP TABLE IF EXISTS citas_medicas;
DROP TABLE IF EXISTS horarios_medicos;
DROP TABLE IF EXISTS pacientes_seguros;
DROP TABLE IF EXISTS pacientes;
DROP TABLE IF EXISTS medicos;
DROP TABLE IF EXISTS especialidades;
DROP TABLE IF EXISTS usuario_roles;
DROP TABLE IF EXISTS roles_permisos;
DROP TABLE IF EXISTS permisos;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(150) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    estado ENUM('ACTIVO','INACTIVO','BLOQUEADO') NOT NULL DEFAULT 'ACTIVO',
    ultimo_ingreso_at DATETIME NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE permisos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE usuario_roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NOT NULL,
    rol_id BIGINT UNSIGNED NOT NULL,
    asignado_por BIGINT UNSIGNED NULL,
    asignado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_usuario_rol (usuario_id, rol_id),
    CONSTRAINT fk_usuario_roles_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_usuario_roles_rol FOREIGN KEY (rol_id) REFERENCES roles(id),
    CONSTRAINT fk_usuario_roles_asignado_por FOREIGN KEY (asignado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE roles_permisos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    rol_id BIGINT UNSIGNED NOT NULL,
    permiso_id BIGINT UNSIGNED NOT NULL,
    UNIQUE KEY uk_rol_permiso (rol_id, permiso_id),
    CONSTRAINT fk_roles_permisos_rol FOREIGN KEY (rol_id) REFERENCES roles(id),
    CONSTRAINT fk_roles_permisos_permiso FOREIGN KEY (permiso_id) REFERENCES permisos(id)
) ENGINE=InnoDB;

-- =========================================================
-- 2. CATÁLOGOS: ESPECIALIDADES Y MÉTODOS DE PAGO
-- =========================================================

CREATE TABLE especialidades (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE metodos_pago (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================================================
-- 3. MÉDICOS
-- =========================================================

CREATE TABLE medicos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NOT NULL UNIQUE,
    especialidad_id BIGINT UNSIGNED NOT NULL,
    matricula_profesional VARCHAR(50) NOT NULL UNIQUE,
    numero_documento VARCHAR(30) NOT NULL,
    telefono VARCHAR(30) NULL,
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_medicos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_medicos_especialidad FOREIGN KEY (especialidad_id) REFERENCES especialidades(id)
) ENGINE=InnoDB;

CREATE TABLE horarios_medicos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    medico_id BIGINT UNSIGNED NOT NULL,
    dia_semana ENUM('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    consultorio VARCHAR(100) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_horarios_medicos_medico FOREIGN KEY (medico_id) REFERENCES medicos(id)
) ENGINE=InnoDB;

-- =========================================================
-- 4. PACIENTES
-- =========================================================

CREATE TABLE pacientes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo_paciente VARCHAR(30) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NULL,
    sexo ENUM('M','F','OTRO') NULL,
    tipo_documento ENUM('CI','PASAPORTE','OTRO') NOT NULL DEFAULT 'CI',
    numero_documento VARCHAR(30) NOT NULL,
    estado_civil VARCHAR(30) NULL,
    grupo_sanguineo VARCHAR(5) NULL,
    telefono VARCHAR(30) NULL,
    correo VARCHAR(150) NULL,
    direccion VARCHAR(255) NULL,
    contacto_emergencia_nombre VARCHAR(150) NULL,
    contacto_emergencia_telefono VARCHAR(30) NULL,
    estado ENUM('ACTIVO','INACTIVO','FALLECIDO') NOT NULL DEFAULT 'ACTIVO',
    creado_por BIGINT UNSIGNED NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_pacientes_documento (tipo_documento, numero_documento),
    CONSTRAINT fk_pacientes_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE pacientes_seguros (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    paciente_id BIGINT UNSIGNED NOT NULL,
    aseguradora VARCHAR(150) NOT NULL,
    numero_poliza VARCHAR(100) NOT NULL,
    titular VARCHAR(150) NULL,
    fecha_inicio DATE NULL,
    fecha_fin DATE NULL,
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pacientes_seguros_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
) ENGINE=InnoDB;

-- =========================================================
-- 5. CITAS MÉDICAS
-- =========================================================

CREATE TABLE citas_medicas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo_cita VARCHAR(30) NOT NULL UNIQUE,
    paciente_id BIGINT UNSIGNED NOT NULL,
    medico_id BIGINT UNSIGNED NOT NULL,
    especialidad_id BIGINT UNSIGNED NOT NULL,
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME NOT NULL,
    motivo VARCHAR(255) NULL,
    estado ENUM('PROGRAMADA','CONFIRMADA','EN_ESPERA','ATENDIDA','CANCELADA','NO_ASISTIO') NOT NULL DEFAULT 'PROGRAMADA',
    creado_por BIGINT UNSIGNED NOT NULL,
    cancelado_por BIGINT UNSIGNED NULL,
    cancelado_en DATETIME NULL,
    motivo_cancelacion VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_citas_medicas_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_citas_medicas_medico FOREIGN KEY (medico_id) REFERENCES medicos(id),
    CONSTRAINT fk_citas_medicas_especialidad FOREIGN KEY (especialidad_id) REFERENCES especialidades(id),
    CONSTRAINT fk_citas_medicas_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id),
    CONSTRAINT fk_citas_medicas_cancelado_por FOREIGN KEY (cancelado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE historial_estados_citas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cita_medica_id BIGINT UNSIGNED NOT NULL,
    estado_anterior VARCHAR(30) NULL,
    estado_nuevo VARCHAR(30) NOT NULL,
    cambiado_por BIGINT UNSIGNED NOT NULL,
    cambiado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacion VARCHAR(255) NULL,
    CONSTRAINT fk_historial_estados_citas_cita FOREIGN KEY (cita_medica_id) REFERENCES citas_medicas(id),
    CONSTRAINT fk_historial_estados_citas_usuario FOREIGN KEY (cambiado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- =========================================================
-- 6. ATENCIONES
-- =========================================================

CREATE TABLE atenciones (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo_atencion VARCHAR(30) NOT NULL UNIQUE,
    paciente_id BIGINT UNSIGNED NOT NULL,
    cita_medica_id BIGINT UNSIGNED NULL UNIQUE,
    medico_id BIGINT UNSIGNED NOT NULL,
    fecha_hora_atencion DATETIME NOT NULL,
    tipo_atencion ENUM('CONSULTA_EXTERNA','EMERGENCIA','CONTROL') NOT NULL DEFAULT 'CONSULTA_EXTERNA',
    estado ENUM('ABIERTA','CERRADA','ANULADA') NOT NULL DEFAULT 'ABIERTA',
    abierta_por BIGINT UNSIGNED NOT NULL,
    cerrada_por BIGINT UNSIGNED NULL,
    cerrada_en DATETIME NULL,
    observacion_cierre VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_atenciones_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_atenciones_cita FOREIGN KEY (cita_medica_id) REFERENCES citas_medicas(id),
    CONSTRAINT fk_atenciones_medico FOREIGN KEY (medico_id) REFERENCES medicos(id),
    CONSTRAINT fk_atenciones_abierta_por FOREIGN KEY (abierta_por) REFERENCES usuarios(id),
    CONSTRAINT fk_atenciones_cerrada_por FOREIGN KEY (cerrada_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- =========================================================
-- 7. HISTORIAS CLÍNICAS (INMUTABLES)
-- =========================================================

CREATE TABLE historias_clinicas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    paciente_id BIGINT UNSIGNED NOT NULL UNIQUE,
    numero_historia_clinica VARCHAR(30) NOT NULL UNIQUE,
    creado_por BIGINT UNSIGNED NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historias_clinicas_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_historias_clinicas_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE entradas_historia_clinica (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    historia_clinica_id BIGINT UNSIGNED NOT NULL,
    atencion_id BIGINT UNSIGNED NOT NULL,
    tipo_entrada ENUM(
        'EVOLUCION',
        'DIAGNOSTICO',
        'ALERGIA',
        'ANTECEDENTE',
        'SIGNOS_VITALES',
        'NOTA_RECETA',
        'CORRECCION'
    ) NOT NULL,
    numero_version INT NOT NULL,
    entrada_anterior_id BIGINT UNSIGNED NULL,
    contenido JSON NOT NULL,
    hash_clinico CHAR(64) NOT NULL,
    es_correccion TINYINT(1) NOT NULL DEFAULT 0,
    motivo_correccion VARCHAR(255) NULL,
    registrado_por BIGINT UNSIGNED NOT NULL,
    registrado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    firmado_por BIGINT UNSIGNED NULL,
    firmado_en DATETIME NULL,
    estado ENUM('ACTIVO','SUPERADO') NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT fk_entradas_historia_historia FOREIGN KEY (historia_clinica_id) REFERENCES historias_clinicas(id),
    CONSTRAINT fk_entradas_historia_atencion FOREIGN KEY (atencion_id) REFERENCES atenciones(id),
    CONSTRAINT fk_entradas_historia_anterior FOREIGN KEY (entrada_anterior_id) REFERENCES entradas_historia_clinica(id),
    CONSTRAINT fk_entradas_historia_registrado_por FOREIGN KEY (registrado_por) REFERENCES usuarios(id),
    CONSTRAINT fk_entradas_historia_firmado_por FOREIGN KEY (firmado_por) REFERENCES usuarios(id),
    UNIQUE KEY uk_historia_version (historia_clinica_id, numero_version)
) ENGINE=InnoDB;

CREATE TABLE diagnosticos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    atencion_id BIGINT UNSIGNED NOT NULL,
    entrada_historia_clinica_id BIGINT UNSIGNED NOT NULL,
    codigo_diagnostico VARCHAR(20) NULL,
    nombre_diagnostico VARCHAR(255) NOT NULL,
    tipo_diagnostico ENUM('PRINCIPAL','SECUNDARIO','PRESUNTIVO','CONFIRMADO') NOT NULL DEFAULT 'PRINCIPAL',
    creado_por BIGINT UNSIGNED NOT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_diagnosticos_atencion FOREIGN KEY (atencion_id) REFERENCES atenciones(id),
    CONSTRAINT fk_diagnosticos_entrada FOREIGN KEY (entrada_historia_clinica_id) REFERENCES entradas_historia_clinica(id),
    CONSTRAINT fk_diagnosticos_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- =========================================================
-- 8. FACTURACIÓN
-- =========================================================

CREATE TABLE facturas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    paciente_id BIGINT UNSIGNED NOT NULL,
    atencion_id BIGINT UNSIGNED NULL,
    fecha_emision DATETIME NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    descuento DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    impuesto DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    saldo_pendiente DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    estado ENUM('BORRADOR','EMITIDA','PAGADA_PARCIAL','PAGADA','ANULADA') NOT NULL DEFAULT 'BORRADOR',
    emitida_por BIGINT UNSIGNED NOT NULL,
    anulada_por BIGINT UNSIGNED NULL,
    anulada_en DATETIME NULL,
    motivo_anulacion VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_facturas_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_facturas_atencion FOREIGN KEY (atencion_id) REFERENCES atenciones(id),
    CONSTRAINT fk_facturas_emitida_por FOREIGN KEY (emitida_por) REFERENCES usuarios(id),
    CONSTRAINT fk_facturas_anulada_por FOREIGN KEY (anulada_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_facturas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    factura_id BIGINT UNSIGNED NOT NULL,
    tipo_item ENUM('CONSULTA','PROCEDIMIENTO','LABORATORIO','IMAGENOLOGIA','MEDICAMENTO','OTRO') NOT NULL,
    referencia_id BIGINT UNSIGNED NULL,
    descripcion VARCHAR(255) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL DEFAULT 1.00,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_linea DECIMAL(12,2) NOT NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_detalle_facturas_factura FOREIGN KEY (factura_id) REFERENCES facturas(id)
) ENGINE=InnoDB;

-- =========================================================
-- 9. PAGOS
-- =========================================================

CREATE TABLE pagos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    factura_id BIGINT UNSIGNED NOT NULL,
    metodo_pago_id BIGINT UNSIGNED NOT NULL,
    fecha_pago DATETIME NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    numero_referencia VARCHAR(100) NULL,
    codigo_transaccion VARCHAR(100) NULL,
    estado ENUM('REGISTRADO','CONFIRMADO','REVERSADO') NOT NULL DEFAULT 'REGISTRADO',
    recibido_por BIGINT UNSIGNED NOT NULL,
    observaciones VARCHAR(255) NULL,
    creado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pagos_factura FOREIGN KEY (factura_id) REFERENCES facturas(id),
    CONSTRAINT fk_pagos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id),
    CONSTRAINT fk_pagos_recibido_por FOREIGN KEY (recibido_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- =========================================================
-- 10. AUDITORÍA
-- =========================================================

CREATE TABLE auditoria_eventos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NULL,
    accion VARCHAR(100) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    entidad_id BIGINT UNSIGNED NOT NULL,
    valores_anteriores JSON NULL,
    valores_nuevos JSON NULL,
    direccion_ip VARCHAR(45) NULL,
    agente_usuario TEXT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_eventos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE auditoria_accesos_historia_clinica (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NOT NULL,
    paciente_id BIGINT UNSIGNED NOT NULL,
    historia_clinica_id BIGINT UNSIGNED NOT NULL,
    tipo_acceso ENUM('VER','IMPRIMIR','EXPORTAR','FIRMAR') NOT NULL,
    motivo VARCHAR(255) NULL,
    direccion_ip VARCHAR(45) NULL,
    agente_usuario TEXT NULL,
    accedido_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_accesos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_auditoria_accesos_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_auditoria_accesos_historia FOREIGN KEY (historia_clinica_id) REFERENCES historias_clinicas(id)
) ENGINE=InnoDB;

-- =========================================================
-- 11. ÍNDICES
-- =========================================================

CREATE INDEX idx_pacientes_apellidos_nombres ON pacientes(apellidos, nombres);
CREATE INDEX idx_pacientes_numero_documento ON pacientes(numero_documento);
CREATE INDEX idx_citas_fecha_inicio ON citas_medicas(fecha_hora_inicio);
CREATE INDEX idx_citas_medico_fecha ON citas_medicas(medico_id, fecha_hora_inicio);
CREATE INDEX idx_atenciones_paciente ON atenciones(paciente_id);
CREATE INDEX idx_entradas_historia_fecha ON entradas_historia_clinica(historia_clinica_id, registrado_en);
CREATE INDEX idx_facturas_paciente_fecha ON facturas(paciente_id, fecha_emision);
CREATE INDEX idx_pagos_factura ON pagos(factura_id);
CREATE INDEX idx_auditoria_eventos_entidad ON auditoria_eventos(entidad, entidad_id);
CREATE INDEX idx_auditoria_accesos_historia_fecha ON auditoria_accesos_historia_clinica(historia_clinica_id, accedido_en);

-- =========================================================
-- 12. DATOS INICIALES
-- =========================================================

INSERT INTO roles (codigo, nombre, descripcion) VALUES
('SUPER_ADMIN', 'Super Administrador', 'Acceso total al sistema'),
('ADMIN_CLINICA', 'Administrador de Clínica', 'Administra la clínica'),
('RECEPCION', 'Recepción', 'Registra pacientes y citas'),
('MEDICO', 'Médico', 'Atiende pacientes y registra historia clínica'),
('CAJA', 'Caja', 'Gestiona facturación y pagos'),
('AUDITOR', 'Auditor', 'Consulta auditorías y trazabilidad');

INSERT INTO permisos (codigo, nombre, descripcion) VALUES
('usuarios.ver', 'Ver usuarios', 'Permite ver usuarios'),
('usuarios.crear', 'Crear usuarios', 'Permite crear usuarios'),
('usuarios.editar', 'Editar usuarios', 'Permite editar usuarios'),
('roles.asignar', 'Asignar roles', 'Permite asignar roles'),
('pacientes.ver', 'Ver pacientes', 'Permite ver pacientes'),
('pacientes.crear', 'Crear pacientes', 'Permite crear pacientes'),
('pacientes.editar', 'Editar pacientes', 'Permite editar pacientes'),
('citas.ver', 'Ver citas', 'Permite ver citas'),
('citas.crear', 'Crear citas', 'Permite crear citas'),
('citas.editar', 'Editar citas', 'Permite editar citas'),
('atenciones.ver', 'Ver atenciones', 'Permite ver atenciones'),
('atenciones.crear', 'Crear atenciones', 'Permite crear atenciones'),
('historias.ver', 'Ver historias clínicas', 'Permite ver historia clínica'),
('historias.crear_entrada', 'Crear entrada clínica', 'Permite registrar entradas clínicas'),
('historias.firmar', 'Firmar historia clínica', 'Permite firmar entradas'),
('facturas.ver', 'Ver facturas', 'Permite ver facturas'),
('facturas.crear', 'Crear facturas', 'Permite emitir facturas'),
('pagos.registrar', 'Registrar pagos', 'Permite registrar pagos'),
('auditoria.ver', 'Ver auditoría', 'Permite ver trazabilidad');

INSERT INTO roles_permisos (rol_id, permiso_id)
SELECT r.id, p.id
FROM roles r
JOIN permisos p
WHERE r.codigo = 'SUPER_ADMIN';

INSERT INTO metodos_pago (codigo, nombre, descripcion) VALUES
('EFECTIVO', 'Efectivo', 'Pago en efectivo'),
('TARJETA', 'Tarjeta', 'Pago con tarjeta'),
('TRANSFERENCIA', 'Transferencia', 'Pago por transferencia bancaria'),
('QR', 'Código QR', 'Pago mediante código QR');

INSERT INTO especialidades (codigo, nombre, descripcion) VALUES
('MED_GEN', 'Medicina General', 'Consulta general'),
('PED', 'Pediatría', 'Atención pediátrica'),
('GIN', 'Ginecología', 'Atención ginecológica'),
('TRA', 'Traumatología', 'Atención traumatológica');

-- =========================================================
-- 13. TRIGGERS PARA PROTEGER HISTORIA CLÍNICA INMUTABLE
-- =========================================================

DELIMITER $$

CREATE TRIGGER trg_no_actualizar_entradas_historia
BEFORE UPDATE ON entradas_historia_clinica
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite actualizar entradas de historia clínica. Debe registrarse una nueva versión o corrección.';
END $$

CREATE TRIGGER trg_no_eliminar_entradas_historia
BEFORE DELETE ON entradas_historia_clinica
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminar entradas de historia clínica.';
END $$

CREATE TRIGGER trg_no_eliminar_historias_clinicas
BEFORE DELETE ON historias_clinicas
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminar historias clínicas.';
END $$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;
