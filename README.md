# student-database-system

This repository contains a MariaDB-compatible relational schema for a Student Records system.

Files added:

- `student_records_schema.sql` — Complete SQL file with `CREATE DATABASE`, `CREATE TABLE` statements, relationships (1-1, 1-M, M-M), constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL) and a sample view.
- `migrations/` — migration-friendly files split into ordered SQL files (create database, departments/instructors/courses, students/addresses, classes/enrollments/course_instructors).
- `student_records_seed.sql` — sample data to populate the database.
- `populate_db.sh` — small script to apply migrations and seed the DB (prompts for DB password interactively).
- `Makefile` — helper to run migrations and seed (uses `mysql` CLI; it will prompt for password).
- `erd.svg` — a vector ER diagram showing tables and relationships.

Quick import instructions (recommended order):

1. Run migrations (either with the Makefile or with the `mysql` client):

```bash
# Using Makefile (it will prompt for DB password):
make migrate MYSQL_USER=root MYSQL_HOST=localhost

# Or run the migration files directly (you will be prompted for password):
mysql -u root -p < migrations/01_create_database.sql
mysql -u root -p < migrations/02_departments_instructors_courses.sql
mysql -u root -p < migrations/03_students_addresses.sql
mysql -u root -p < migrations/04_classes_enrollments_course_instructors.sql
```

2. Apply seed data:

```bash
# Using Makefile:
make seed MYSQL_USER=root MYSQL_HOST=localhost

# Or with mysql client:
mysql -u root -p < student_records_seed.sql
```

3. Alternatively, run the convenience script (it runs migrations then seed):

```bash
./populate_db.sh -u root -h localhost
```

Notes:

- The main DB created is `student_records_db`.
- The schema uses `InnoDB` and `utf8mb4`.
- `addresses` implements a one-to-one relationship with `students` by using `student_id` as its primary key.
- `enrollments` models many-to-many between `students` and `classes` with composite PK (`student_id`, `class_id`).

If you'd like I can also:

- Add tests (simple SQL queries that assert counts/constraints).
- Generate a PNG version of the ER diagram.
- Add a small CLI to run queries against the DB.
