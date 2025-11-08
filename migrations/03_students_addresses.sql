-- migrations/03_students_addresses.sql
-- Students and Addresses (1-1 relationship)

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

CREATE TABLE IF NOT EXISTS `addresses` (
  `student_id` INT UNSIGNED NOT NULL,
  `street` VARCHAR(200) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100),
  `postal_code` VARCHAR(20),
  `country` VARCHAR(100) NOT NULL DEFAULT 'Kenya',
  `phone` VARCHAR(30),
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`),
  CONSTRAINT `fk_address_student` FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;