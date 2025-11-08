-- Student Records Database Schema for MariaDB
-- File: student_records_schema.sql
-- Purpose: Full relational schema with PKs, FKs, constraints and relationships

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `student_records_db`
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_general_ci;

USE `student_records_db`;

-- -----------------------------------------------------
-- Table: departments (one department has many courses)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `departments` (
  `department_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `dept_code` VARCHAR(10) NOT NULL UNIQUE,
  `name` VARCHAR(120) NOT NULL,
  `office` VARCHAR(80),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: instructors (an instructor may teach many classes)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `instructors` (
  `instructor_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(60) NOT NULL,
  `last_name` VARCHAR(60) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `hire_date` DATE NOT NULL,
  `department_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`instructor_id`),
  CONSTRAINT `fk_instructor_dept` FOREIGN KEY (`department_id`) REFERENCES `departments`(`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: students
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_number` VARCHAR(20) NOT NULL UNIQUE,
  `first_name` VARCHAR(60) NOT NULL,
  `last_name` VARCHAR(60) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `birth_date` DATE,
  `enroll_date` DATE NOT NULL,
  `status` ENUM('active','inactive','graduated','suspended') NOT NULL DEFAULT 'active',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: addresses (one-to-one with students)
-- Implemented by making student_id the PRIMARY KEY here
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addresses` (
  `student_id` INT UNSIGNED NOT NULL,
  `street` VARCHAR(200) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100),
  `postal_code` VARCHAR(20),
  `country` VARCHAR(100) NOT NULL DEFAULT 'Country',
  `phone` VARCHAR(30),
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`),
  CONSTRAINT `fk_address_student` FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: courses
-- Each course belongs to a department (one-to-many)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `courses` (
  `course_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_code` VARCHAR(20) NOT NULL UNIQUE,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `credit_hours` DECIMAL(3,1) NOT NULL DEFAULT 3.0,
  `department_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`course_id`),
  CONSTRAINT `fk_course_dept` FOREIGN KEY (`department_id`) REFERENCES `departments`(`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: classes (course offerings)
-- One course may have many classes; one instructor may teach many classes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classes` (
  `class_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` INT UNSIGNED NOT NULL,
  `term` VARCHAR(30) NOT NULL, -- e.g., 'Fall 2025'
  `section` VARCHAR(10) NOT NULL,
  `instructor_id` INT UNSIGNED NOT NULL,
  `capacity` INT UNSIGNED NOT NULL DEFAULT 30,
  `location` VARCHAR(100),
  `start_date` DATE,
  `end_date` DATE,
  PRIMARY KEY (`class_id`),
  UNIQUE KEY `uq_course_term_section` (`course_id`,`term`,`section`),
  CONSTRAINT `fk_class_course` FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_class_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructors`(`instructor_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tip: In MariaDB prior to some versions, FOREIGN KEYs with SET NULL require the referencing column to be nullable. Make instructor_id nullable.
ALTER TABLE `classes` MODIFY `instructor_id` INT UNSIGNED NULL;

-- -----------------------------------------------------
-- Table: enrollments (many-to-many between students and classes)
-- Composite primary key (student_id, class_id) to prevent duplicates
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `enrollments` (
  `student_id` INT UNSIGNED NOT NULL,
  `class_id` INT UNSIGNED NOT NULL,
  `enrolled_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `grade` VARCHAR(4), -- letter grade or NULL until assigned
  PRIMARY KEY (`student_id`,`class_id`),
  INDEX `idx_enroll_class` (`class_id`),
  CONSTRAINT `fk_enroll_student` FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_enroll_class` FOREIGN KEY (`class_id`) REFERENCES `classes`(`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: course_instructors (many-to-many: courses <-> instructors)
-- Useful when multiple instructors are associated with a course (not specific class offerings)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `course_instructors` (
  `course_id` INT UNSIGNED NOT NULL,
  `instructor_id` INT UNSIGNED NOT NULL,
  `assigned_on` DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`course_id`,`instructor_id`),
  CONSTRAINT `fk_ci_course` FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ci_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructors`(`instructor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Views and helper objects (optional)
-- -----------------------------------------------------
-- View: roster for a class
CREATE OR REPLACE VIEW `class_roster` AS
SELECT c.class_id, c.term, c.section, co.course_code, co.title AS course_title,
  s.student_id, s.student_number, s.first_name, s.last_name, e.enrolled_on, e.grade
FROM `classes` c
JOIN `courses` co ON co.course_id = c.course_id
JOIN `enrollments` e ON e.class_id = c.class_id
JOIN `students` s ON s.student_id = e.student_id;

SET FOREIGN_KEY_CHECKS = 1;

-- End of schema
