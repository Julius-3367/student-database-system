-- migrations/04_classes_enrollments_course_instructors.sql
-- Classes, Enrollments, Course_Instructors and helper view

CREATE TABLE IF NOT EXISTS `classes` (
  `class_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` INT UNSIGNED NOT NULL,
  `term` VARCHAR(30) NOT NULL,
  `section` VARCHAR(10) NOT NULL,
  `instructor_id` INT UNSIGNED NULL,
  `capacity` INT UNSIGNED NOT NULL DEFAULT 30,
  `location` VARCHAR(100),
  `start_date` DATE,
  `end_date` DATE,
  PRIMARY KEY (`class_id`),
  UNIQUE KEY `uq_course_term_section` (`course_id`,`term`,`section`),
  CONSTRAINT `fk_class_course` FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_class_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructors`(`instructor_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `enrollments` (
  `student_id` INT UNSIGNED NOT NULL,
  `class_id` INT UNSIGNED NOT NULL,
  `enrolled_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `grade` VARCHAR(4),
  PRIMARY KEY (`student_id`,`class_id`),
  INDEX `idx_enroll_class` (`class_id`),
  CONSTRAINT `fk_enroll_student` FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_enroll_class` FOREIGN KEY (`class_id`) REFERENCES `classes`(`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `course_instructors` (
  `course_id` INT UNSIGNED NOT NULL,
  `instructor_id` INT UNSIGNED NOT NULL,
  `assigned_on` DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`course_id`,`instructor_id`),
  CONSTRAINT `fk_ci_course` FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ci_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructors`(`instructor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE OR REPLACE VIEW `class_roster` AS
SELECT c.class_id, c.term, c.section, co.course_code, co.title AS course_title,
  s.student_id, s.student_number, s.first_name, s.last_name, e.enrolled_on, e.grade
FROM `classes` c
JOIN `courses` co ON co.course_id = c.course_id
JOIN `enrollments` e ON e.class_id = c.class_id
JOIN `students` s ON s.student_id = e.student_id;