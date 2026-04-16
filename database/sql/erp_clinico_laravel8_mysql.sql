-- ERP Clínico Modular
-- Base: Laravel 8 + MySQL 8

CREATE DATABASE IF NOT EXISTS clinicas_erp
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE clinicas_erp;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- 1) Seguridad
-- =========================
CREATE TABLE roles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE permissions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  last_login_at DATETIME NULL,
  remember_token VARCHAR(100) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE role_user (
  role_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at TIMESTAMP NULL,
  PRIMARY KEY (role_id, user_id),
  CONSTRAINT fk_role_user_role FOREIGN KEY (role_id) REFERENCES roles(id),
  CONSTRAINT fk_role_user_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE permission_role (
  permission_id BIGINT UNSIGNED NOT NULL,
  role_id BIGINT UNSIGNED NOT NULL,
  created_at TIMESTAMP NULL,
  PRIMARY KEY (permission_id, role_id),
  CONSTRAINT fk_permission_role_permission FOREIGN KEY (permission_id) REFERENCES permissions(id),
  CONSTRAINT fk_permission_role_role FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

-- =========================
-- 2) Configuración
-- =========================
CREATE TABLE clinics (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(180) NOT NULL,
  tax_id VARCHAR(30) NULL,
  phone VARCHAR(30) NULL,
  email VARCHAR(150) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE branches (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clinic_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255) NULL,
  phone VARCHAR(30) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_branches_clinic_id (clinic_id),
  CONSTRAINT fk_branches_clinic FOREIGN KEY (clinic_id) REFERENCES clinics(id)
) ENGINE=InnoDB;

CREATE TABLE offices (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  branch_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  floor VARCHAR(50) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_offices_branch_id (branch_id),
  CONSTRAINT fk_offices_branch FOREIGN KEY (branch_id) REFERENCES branches(id)
) ENGINE=InnoDB;

CREATE TABLE specialties (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
) ENGINE=InnoDB;

-- =========================
-- 3) Pacientes
-- =========================
CREATE TABLE patients (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE,
  document_type VARCHAR(30) NOT NULL,
  document_number VARCHAR(50) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  birth_date DATE NULL,
  sex ENUM('M','F','O') NULL,
  phone VARCHAR(30) NULL,
  email VARCHAR(150) NULL,
  address VARCHAR(255) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  UNIQUE KEY uq_patient_document (document_type, document_number)
) ENGINE=InnoDB;

-- =========================
-- 4) Agenda y Citas
-- =========================
CREATE TABLE appointments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  patient_id BIGINT UNSIGNED NOT NULL,
  doctor_user_id BIGINT UNSIGNED NOT NULL,
  branch_id BIGINT UNSIGNED NOT NULL,
  office_id BIGINT UNSIGNED NULL,
  specialty_id BIGINT UNSIGNED NULL,
  scheduled_at DATETIME NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'scheduled',
  reason VARCHAR(255) NULL,
  created_by BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_appointments_patient_id (patient_id),
  INDEX idx_appointments_doctor_user_id (doctor_user_id),
  INDEX idx_appointments_branch_id (branch_id),
  INDEX idx_appointments_scheduled_at (scheduled_at),
  CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
  CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_user_id) REFERENCES users(id),
  CONSTRAINT fk_appointments_branch FOREIGN KEY (branch_id) REFERENCES branches(id),
  CONSTRAINT fk_appointments_office FOREIGN KEY (office_id) REFERENCES offices(id),
  CONSTRAINT fk_appointments_specialty FOREIGN KEY (specialty_id) REFERENCES specialties(id),
  CONSTRAINT fk_appointments_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- =========================
-- 5) Admisión y Atención
-- =========================
CREATE TABLE admissions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  appointment_id BIGINT UNSIGNED NULL,
  patient_id BIGINT UNSIGNED NOT NULL,
  branch_id BIGINT UNSIGNED NOT NULL,
  check_in_at DATETIME NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'open',
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_admissions_patient_id (patient_id),
  CONSTRAINT fk_admissions_appointment FOREIGN KEY (appointment_id) REFERENCES appointments(id),
  CONSTRAINT fk_admissions_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
  CONSTRAINT fk_admissions_branch FOREIGN KEY (branch_id) REFERENCES branches(id)
) ENGINE=InnoDB;

CREATE TABLE encounters (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  admission_id BIGINT UNSIGNED NOT NULL,
  patient_id BIGINT UNSIGNED NOT NULL,
  doctor_user_id BIGINT UNSIGNED NOT NULL,
  started_at DATETIME NOT NULL,
  ended_at DATETIME NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  UNIQUE KEY uq_encounter_admission (admission_id),
  INDEX idx_encounters_patient_id (patient_id),
  INDEX idx_encounters_doctor_user_id (doctor_user_id),
  CONSTRAINT fk_encounters_admission FOREIGN KEY (admission_id) REFERENCES admissions(id),
  CONSTRAINT fk_encounters_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
  CONSTRAINT fk_encounters_doctor FOREIGN KEY (doctor_user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- =========================
-- 6) Historia Clínica
-- =========================
CREATE TABLE clinical_notes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  encounter_id BIGINT UNSIGNED NOT NULL,
  author_user_id BIGINT UNSIGNED NOT NULL,
  note_type VARCHAR(50) NOT NULL,
  content LONGTEXT NOT NULL,
  is_signed TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_clinical_notes_encounter_id (encounter_id),
  CONSTRAINT fk_clinical_notes_encounter FOREIGN KEY (encounter_id) REFERENCES encounters(id),
  CONSTRAINT fk_clinical_notes_author FOREIGN KEY (author_user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE diagnoses (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  encounter_id BIGINT UNSIGNED NOT NULL,
  cie10_code VARCHAR(20) NULL,
  description VARCHAR(255) NOT NULL,
  diagnosis_type VARCHAR(30) NOT NULL DEFAULT 'primary',
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_diagnoses_encounter_id (encounter_id),
  CONSTRAINT fk_diagnoses_encounter FOREIGN KEY (encounter_id) REFERENCES encounters(id)
) ENGINE=InnoDB;

-- =========================
-- 7) Prescripciones y Órdenes
-- =========================
CREATE TABLE prescriptions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  encounter_id BIGINT UNSIGNED NOT NULL,
  doctor_user_id BIGINT UNSIGNED NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'active',
  notes VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_prescriptions_encounter_id (encounter_id),
  CONSTRAINT fk_prescriptions_encounter FOREIGN KEY (encounter_id) REFERENCES encounters(id),
  CONSTRAINT fk_prescriptions_doctor FOREIGN KEY (doctor_user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE prescription_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  prescription_id BIGINT UNSIGNED NOT NULL,
  medication_name VARCHAR(180) NOT NULL,
  dose VARCHAR(120) NULL,
  frequency VARCHAR(120) NULL,
  duration_days INT NULL,
  instructions VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_prescription_items_prescription_id (prescription_id),
  CONSTRAINT fk_prescription_items_prescription FOREIGN KEY (prescription_id) REFERENCES prescriptions(id)
) ENGINE=InnoDB;

-- =========================
-- 8) Facturación y Caja
-- =========================
CREATE TABLE invoices (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  patient_id BIGINT UNSIGNED NOT NULL,
  encounter_id BIGINT UNSIGNED NULL,
  invoice_number VARCHAR(40) NOT NULL UNIQUE,
  issue_date DATE NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
  tax DECIMAL(12,2) NOT NULL DEFAULT 0,
  total DECIMAL(12,2) NOT NULL DEFAULT 0,
  status VARCHAR(30) NOT NULL DEFAULT 'draft',
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_invoices_patient_id (patient_id),
  CONSTRAINT fk_invoices_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
  CONSTRAINT fk_invoices_encounter FOREIGN KEY (encounter_id) REFERENCES encounters(id)
) ENGINE=InnoDB;

CREATE TABLE invoice_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  invoice_id BIGINT UNSIGNED NOT NULL,
  description VARCHAR(255) NOT NULL,
  quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
  unit_price DECIMAL(12,2) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_invoice_items_invoice_id (invoice_id),
  CONSTRAINT fk_invoice_items_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id)
) ENGINE=InnoDB;

CREATE TABLE payments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  invoice_id BIGINT UNSIGNED NOT NULL,
  method VARCHAR(40) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  paid_at DATETIME NOT NULL,
  reference VARCHAR(100) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_payments_invoice_id (invoice_id),
  CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id)
) ENGINE=InnoDB;

-- =========================
-- 9) Inventario/Farmacia
-- =========================
CREATE TABLE products (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(60) NOT NULL UNIQUE,
  name VARCHAR(180) NOT NULL,
  product_type VARCHAR(30) NOT NULL DEFAULT 'medication',
  unit VARCHAR(30) NOT NULL DEFAULT 'unit',
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE inventory_movements (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT UNSIGNED NOT NULL,
  movement_type ENUM('in','out','adjustment') NOT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  reason VARCHAR(255) NULL,
  related_prescription_item_id BIGINT UNSIGNED NULL,
  moved_at DATETIME NOT NULL,
  created_by BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_inventory_movements_product_id (product_id),
  CONSTRAINT fk_inventory_movements_product FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT fk_inventory_movements_prescription_item FOREIGN KEY (related_prescription_item_id) REFERENCES prescription_items(id),
  CONSTRAINT fk_inventory_movements_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- =========================
-- 10) Auditoría
-- =========================
CREATE TABLE audit_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  module VARCHAR(60) NOT NULL,
  entity VARCHAR(60) NOT NULL,
  entity_id BIGINT UNSIGNED NULL,
  action VARCHAR(60) NOT NULL,
  old_values JSON NULL,
  new_values JSON NULL,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  created_at DATETIME NOT NULL,
  INDEX idx_audit_logs_user_id (user_id),
  INDEX idx_audit_logs_entity (entity, entity_id),
  CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
