-- student_records_seed.sql
-- Sample seed data with Kenyan names
USE `student_records_db`;

START TRANSACTION;

-- Departments
INSERT INTO departments (dept_code, name, office) VALUES
('CS', 'Computer Science', 'Main Block A'),
('ENG', 'Engineering', 'Engineering Block'),
('BUS', 'Business', 'Business School');

-- Instructors
INSERT INTO instructors (first_name, last_name, email, hire_date, department_id) VALUES
('Mwangi','Karanja','mwangi.karanja@univ.ac.ke','2018-02-10', (SELECT department_id FROM departments WHERE dept_code='CS')),
('Amina','Owino','amina.owino@univ.ac.ke','2019-08-01', (SELECT department_id FROM departments WHERE dept_code='ENG')),
('Grace','Wanjiru','grace.wanjiru@univ.ac.ke','2017-06-15', (SELECT department_id FROM departments WHERE dept_code='BUS')),
('Julius','Njoroge','julius.njoroge@univ.ac.ke','2020-01-05', (SELECT department_id FROM departments WHERE dept_code='CS'));

-- Courses
INSERT INTO courses (course_code, title, description, credit_hours, department_id) VALUES
('CS101','Introduction to Programming','Basic programming concepts using Python',3.0,(SELECT department_id FROM departments WHERE dept_code='CS')),
('CS201','Data Structures','Study of data structures and algorithms',3.0,(SELECT department_id FROM departments WHERE dept_code='CS')),
('ENG101','Engineering Mechanics','Introductory mechanics',3.0,(SELECT department_id FROM departments WHERE dept_code='ENG')),
('BUS101','Principles of Management','Foundations of management',3.0,(SELECT department_id FROM departments WHERE dept_code='BUS')),
('BUS201','Accounting I','Financial accounting principles',3.0,(SELECT department_id FROM departments WHERE dept_code='BUS'));

-- Students
INSERT INTO students (student_number, first_name, last_name, email, birth_date, enroll_date) VALUES
('S001','Julius','Owino','julius.owino@student.univ.ac.ke','2001-05-12','2020-09-01'),
('S002','Asha','Wanjiru','asha.wanjiru@student.univ.ac.ke','2002-11-03','2021-09-01'),
('S003','Robert','Mwangi','robert.mwangi@student.univ.ac.ke','2000-02-20','2019-09-01'),
('S004','Mary','Njeri','mary.njeri@student.univ.ac.ke','2001-07-30','2020-09-01'),
('S005','Kevin','Kiptoo','kevin.kiptoo@student.univ.ac.ke','2003-01-17','2022-09-01');

-- Addresses (use SELECT to link student_id)
INSERT INTO addresses (student_id, street, city, state, postal_code, country, phone)
SELECT student_id, '12 Kenyatta Ave', 'Nairobi', 'Nairobi', '00100', 'Kenya', '+254700000001' FROM students WHERE student_number='S001';

INSERT INTO addresses (student_id, street, city, state, postal_code, country, phone)
SELECT student_id, '45 Moi Street', 'Nairobi', 'Nairobi', '00102', 'Kenya', '+254700000002' FROM students WHERE student_number='S002';

INSERT INTO addresses (student_id, street, city, state, postal_code, country, phone)
SELECT student_id, '78 Kenyatta Ave', 'Nakuru', 'Rift Valley', '20100', 'Kenya', '+254700000003' FROM students WHERE student_number='S003';

INSERT INTO addresses (student_id, street, city, state, postal_code, country, phone)
SELECT student_id, '9 Harambee Rd', 'Mombasa', 'Coast', '80100', 'Kenya', '+254700000004' FROM students WHERE student_number='S004';

INSERT INTO addresses (student_id, street, city, state, postal_code, country, phone)
SELECT student_id, '101 Village Rd', 'Eldoret', 'Rift Valley', '30100', 'Kenya', '+254700000005' FROM students WHERE student_number='S005';

-- Classes (course offerings)
INSERT INTO classes (course_id, term, section, instructor_id, capacity, location, start_date, end_date) VALUES
((SELECT course_id FROM courses WHERE course_code='CS101'),'Fall 2025','A',(SELECT instructor_id FROM instructors WHERE email='mwangi.karanja@univ.ac.ke'),40,'Main Hall','2025-09-01','2025-12-15'),
((SELECT course_id FROM courses WHERE course_code='CS201'),'Fall 2025','A',(SELECT instructor_id FROM instructors WHERE email='julius.njoroge@univ.ac.ke'),35,'Lab 2','2025-09-01','2025-12-15'),
((SELECT course_id FROM courses WHERE course_code='BUS101'),'Fall 2025','A',(SELECT instructor_id FROM instructors WHERE email='grace.wanjiru@univ.ac.ke'),50,'Business Hall','2025-09-01','2025-12-15');

-- Enrollments
INSERT INTO enrollments (student_id, class_id) VALUES
((SELECT student_id FROM students WHERE student_number='S001'), (SELECT class_id FROM classes WHERE term='Fall 2025' AND section='A' AND course_id=(SELECT course_id FROM courses WHERE course_code='CS101'))),
((SELECT student_id FROM students WHERE student_number='S002'), (SELECT class_id FROM classes WHERE term='Fall 2025' AND section='A' AND course_id=(SELECT course_id FROM courses WHERE course_code='CS101'))),
((SELECT student_id FROM students WHERE student_number='S003'), (SELECT class_id FROM classes WHERE term='Fall 2025' AND section='A' AND course_id=(SELECT course_id FROM courses WHERE course_code='CS201'))),
((SELECT student_id FROM students WHERE student_number='S004'), (SELECT class_id FROM classes WHERE term='Fall 2025' AND section='A' AND course_id=(SELECT course_id FROM courses WHERE course_code='BUS101'))),
((SELECT student_id FROM students WHERE student_number='S005'), (SELECT class_id FROM classes WHERE term='Fall 2025' AND section='A' AND course_id=(SELECT course_id FROM courses WHERE course_code='BUS101')));

-- Course_Instructors (associate instructors with courses)
INSERT INTO course_instructors (course_id, instructor_id) VALUES
((SELECT course_id FROM courses WHERE course_code='CS101'), (SELECT instructor_id FROM instructors WHERE email='mwangi.karanja@univ.ac.ke')),
((SELECT course_id FROM courses WHERE course_code='CS201'), (SELECT instructor_id FROM instructors WHERE email='julius.njoroge@univ.ac.ke')),
((SELECT course_id FROM courses WHERE course_code='BUS101'), (SELECT instructor_id FROM instructors WHERE email='grace.wanjiru@univ.ac.ke'));

COMMIT;