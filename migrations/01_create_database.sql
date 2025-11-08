-- migrations/01_create_database.sql
-- Create database and set charset
CREATE DATABASE IF NOT EXISTS `student_records_db`
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_general_ci;

USE `student_records_db`;