/*Дизайн бази даних:
1. Створіть базу даних для управління курсами. База має включати наступні таблиці: 
- students: student_no, teacher_no, course_no, student_name, email, birth_date.
- teachers: teacher_no, teacher_name, phone_no
- courses: course_no, course_name, start_date, end_date
2. Додайте будь-які данні (7-10 рядків) в кожну таблицю.
3. По кожному викладачу покажіть кількість студентів з якими він працював
4. Спеціально зробіть 3 дубляжі в таблиці students (додайте ще 3 однакові рядки) 
5. Напишіть запит який виведе дублюючі рядки в таблиці students
*/
DROP DATABASE IF EXISTS courses_db;
CREATE DATABASE IF NOT EXISTS courses_db;
SHOW DATABASES;
USE courses_db;

DROP TABLE IF EXISTS teachers;
CREATE TABLE IF NOT EXISTS teachers (
    teacher_no INT AUTO_INCREMENT PRIMARY KEY,
    teacher_name VARCHAR(255),
    phone_no VARCHAR(20));
DESCRIBE teachers;

DROP TABLE IF EXISTS courses;
CREATE TABLE IF NOT EXISTS courses (
    course_no INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255),
    start_date DATE,
    end_date DATE);
DESCRIBE courses;

DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students (
    student_no INT AUTO_INCREMENT PRIMARY KEY,
    teacher_no INT,
    course_no INT,
    student_name VARCHAR(255),
    email VARCHAR(255),
    birth_date DATE,
    FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no),
    FOREIGN KEY (course_no) REFERENCES courses(course_no));
DESCRIBE students;

USE courses_db;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
INSERT INTO teachers (teacher_name, phone_no)
VALUES ('teacher_1', '123-456-1111'),
       ('teacher_2', '123-456-2222'),
       ('teacher_3', '123-456-3333'),
       ('teacher_4', '123-456-4444'),
       ('teacher_5', '123-456-5555');
INSERT INTO courses (course_name, start_date, end_date)
VALUES ('course_1', '2023-01-01', '2023-03-01'),
       ('course_2', '2023-02-01', '2023-05-01'),
       ('course_3', '2023-03-01', '2023-07-01'),
       ('course_4', '2023-04-01', '2023-09-01');
INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (1, 1, 'student_1', 'a_st1@example.com', '2000-01-15'),
       (1, 2, 'student_2', 'b_st2@example.com', '1999-01-10'),
       (2, 3, 'student_3', 'c_st3@example.com', '1998-02-20'),
       (2, 4, 'student_4', 'd_st4@example.com', '1997-03-25'),
       (3, 1, 'student_5', 'e_st5@example.com', '1996-04-30'),
       (3, 2, 'student_6', 'f_st66@example.com', '1995-01-15'),
       (4, 3, 'student_7', 'g_st7@example.com', '2000-07-10'),
       (4, 4, 'student_8', 'h_st8@example.com', '1999-03-20'),
       (5, 1, 'student_9', 'j_st9@example.com', '1998-05-25'),
       (5, 2, 'student_10', 'k_st10@example.com', '1997-11-30');
ALTER TABLE teachers
ADD COLUMN students_count INT;
UPDATE teachers
LEFT JOIN (SELECT teacher_no,COUNT(student_no) AS students_count
    FROM students
    GROUP BY teacher_no) counts ON teachers.teacher_no = counts.teacher_no
SET teachers.students_count = IFNULL(counts.students_count, 0);
COMMIT;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
SELECT teacher_no, course_no, student_name, email, birth_date
FROM students
LIMIT 3;
SELECT * FROM students;

SELECT t.teacher_no, t.teacher_name, COUNT(s.student_no)
FROM teachers AS t
INNER JOIN students AS s 
ON (t.teacher_no = s.teacher_no)
GROUP BY 1, 2;

SELECT teacher_no, course_no, student_name, email, birth_date, COUNT(*) AS dubl
FROM students
GROUP BY teacher_no, course_no, student_name, email, birth_date
HAVING COUNT(*) > 1;
