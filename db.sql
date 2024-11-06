CREATE TABLE College_Department (
  college_id SERIAL PRIMARY KEY NOT NULL,
  college_name VARCHAR(100)
);

CREATE TABLE Student (
    student_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    address TEXT,
    contact_number VARCHAR(20),
    sex VARCHAR(10),
    birth_day DATE,
    zip_code VARCHAR(10),
    nationality VARCHAR(50),
    civil_status VARCHAR(20),
    student_type VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Teacher (
    teacher_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    address TEXT,
    contact_number VARCHAR(20),
    sex VARCHAR(10),
    birth_day DATE,
    zip_code VARCHAR(10),
    nationality VARCHAR(50),
    civil_status VARCHAR(20),
    email VARCHAR(100),
    employment_type VARCHAR(20),
    college_id INT REFERENCES College_Department(college_id)
);

CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    course_title VARCHAR(100),
    course_description TEXT,
    units INT
);

CREATE TABLE Course_Account (
    course_account_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES Courses(course_id),
    teacher_id INT REFERENCES Teacher(teacher_id)
);

CREATE TABLE Sections (
    section_id SERIAL PRIMARY KEY,
    year_level INT,
    section VARCHAR(50)
);


CREATE TABLE Student_Section (
    student_section_id SERIAL PRIMARY KEY,
    section_id INT REFERENCES Sections(section_id),
    student_id INT REFERENCES Student(student_id)
);

CREATE TABLE Guardians (
    guardian_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    sex VARCHAR(10),
    relationship VARCHAR(50),
    student_id INT REFERENCES Student(student_id)
);

CREATE TABLE Enrollment_Status (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Student(student_id),
    status VARCHAR(20)
);

CREATE TABLE Grades (
    student_id INT REFERENCES Student(student_id),
    student_section_id INT REFERENCES Student_Section(student_section_id),
    course_id INT REFERENCES Courses(course_id),
    teacher_id INT REFERENCES Teacher(teacher_id),
    PRIMARY KEY (student_id, course_id, teacher_id)
);

CREATE TABLE Task (
    task_id SERIAL PRIMARY KEY,
    course_account_id INT REFERENCES Course_Account(course_account_id),
    caption TEXT,
    document TEXT,
    student_section_id INT REFERENCES Student_Section(student_section_id)
);

CREATE TABLE Schedule (
    schedule_id SERIAL PRIMARY KEY,
    student_section_id INT REFERENCES Student_Section(student_section_id),
    course_account_id INT REFERENCES Course_Account(course_account_id)
);

CREATE TABLE Z_Table (
    zip_code VARCHAR(10) PRIMARY KEY,
    municipality VARCHAR(100),
    province VARCHAR(100),
    country VARCHAR(100)
);
