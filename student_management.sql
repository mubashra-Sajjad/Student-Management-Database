
-- ==========================================
-- STUDENT MANAGEMENT DATABASE PROJECT
-- ==========================================

-- RESET OLD PROJECT OBJECTS (FRESH RUN)

DROP VIEW IF EXISTS StudentDetails;
DROP TRIGGER IF EXISTS AfterMarksUpdate;
DROP PROCEDURE IF EXISTS GetAllStudents;
DROP PROCEDURE IF EXISTS GetTopStudents;

DROP TABLE IF EXISTS MarksHistory_Backup;
DROP TABLE IF EXISTS Students_Backup;
DROP TABLE IF EXISTS Courses_Backup;
DROP TABLE IF EXISTS MarksHistory;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;


-- STEP 1: CREATE COURSES TABLE

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    CreditHours INT,
    Department VARCHAR(50)
) ENGINE=InnoDB;


-- STEP 2: CREATE STUDENTS TABLE

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Course VARCHAR(50),
    Marks INT,
    CourseID INT,
    CONSTRAINT fk_student_course
    FOREIGN KEY (CourseID)
    REFERENCES Courses(CourseID)
) ENGINE=InnoDB;


-- STEP 3: INSERT COURSES

INSERT INTO Courses VALUES
(101, 'Database Systems', 3, 'Computer Science'),
(102, 'Operating Systems', 3, 'Computer Science'),
(103, 'Business Management', 3, 'Business'),
(104, 'Cyber Security', 3, 'Computer Science'),
(105, 'Mathematics', 3, 'Mathematics');


-- STEP 4: INSERT STUDENTS

INSERT INTO Students VALUES
(1, 'Ayesha', 'ayesha@gmail.com', '03001234567', 'BSCS', 85, 101),
(2, 'Fatima', 'fatima@gmail.com', '03001234568', 'BSIT', 90, 102),
(3, 'Ali', 'ali@gmail.com', '03001234569', 'BSCS', 78, 104),
(4, 'Sara', 'sara@gmail.com', '03001234570', 'BBA', 88, 103);


-- STEP 5: DISPLAY ALL STUDENTS

SELECT * FROM Students;


-- STEP 6: DISPLAY ALL COURSES

SELECT * FROM Courses;


-- STEP 7: INNER JOIN

SELECT
    Students.StudentID,
    Students.StudentName,
    Students.Email,
    Courses.CourseName,
    Students.Marks
FROM Students
INNER JOIN Courses
ON Students.CourseID = Courses.CourseID;


-- STEP 8: SORT STUDENTS BY MARKS

SELECT * FROM Students
ORDER BY Marks DESC;


-- STEP 9: COUNT TOTAL STUDENTS

SELECT COUNT(*) AS TotalStudents
FROM Students;


-- STEP 10: CALCULATE AVERAGE MARKS

SELECT AVG(Marks) AS AverageMarks
FROM Students;


-- STEP 11: CREATE VIEW

CREATE VIEW StudentDetails AS
SELECT
    Students.StudentID,
    Students.StudentName,
    Students.Email,
    Courses.CourseName,
    Students.Marks
FROM Students
INNER JOIN Courses
ON Students.CourseID = Courses.CourseID;


-- STEP 12: DISPLAY VIEW

SELECT * FROM StudentDetails;


-- STEP 13: STUDENTS WITH MARKS ABOVE 80

SELECT * FROM StudentDetails
WHERE Marks > 80;


-- STEP 14: ALPHABETICAL ORDER

SELECT * FROM StudentDetails
ORDER BY StudentName ASC;


-- STEP 15: COUNT STUDENTS IN VIEW

SELECT COUNT(*) AS TotalStudents
FROM StudentDetails;


-- STEP 16: CREATE STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE GetAllStudents()
BEGIN
    SELECT * FROM Students;
END //

DELIMITER ;


-- STEP 17: CALL STORED PROCEDURE

CALL GetAllStudents();


-- STEP 18: CREATE TOP STUDENTS PROCEDURE

DELIMITER //

CREATE PROCEDURE GetTopStudents()
BEGIN
    SELECT * FROM Students
    WHERE Marks >= 85;
END //

DELIMITER ;


-- STEP 19: CALL TOP STUDENTS PROCEDURE

CALL GetTopStudents();


-- STEP 20: INTRODUCTION TO TRIGGERS
-- A trigger automatically executes after a specified
-- database event such as INSERT, UPDATE or DELETE.


-- STEP 21: CREATE MARKS HISTORY TABLE

CREATE TABLE MarksHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    OldMarks INT,
    NewMarks INT,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- STEP 22: CREATE UPDATE TRIGGER

DELIMITER //

CREATE TRIGGER AfterMarksUpdate
AFTER UPDATE ON Students
FOR EACH ROW
BEGIN
    IF NOT (OLD.Marks <=> NEW.Marks) THEN
        INSERT INTO MarksHistory
        (StudentID, OldMarks, NewMarks)
        VALUES
        (OLD.StudentID, OLD.Marks, NEW.Marks);
    END IF;
END //

DELIMITER ;


-- STEP 23: UPDATE STUDENT 1 MARKS

UPDATE Students
SET Marks = 95
WHERE StudentID = 1;


-- STEP 24: CHECK MARKS HISTORY

SELECT * FROM MarksHistory;


-- STEP 25: DISPLAY UPDATED STUDENT

SELECT * FROM Students;


-- STEP 26: CHECK CURRENT STUDENT MARKS

SELECT * FROM Students;


-- STEP 27: UPDATE STUDENT 2 MARKS

UPDATE Students
SET Marks = 96
WHERE StudentID = 2;


-- STEP 28: CHECK STUDENT 2

SELECT * FROM Students
WHERE StudentID = 2;


-- STEP 29: CHECK MARKS HISTORY

SELECT * FROM MarksHistory;


-- STEP 30: DISPLAY STUDENT DETAILS

SELECT * FROM StudentDetails;


-- STEP 31: START TRANSACTION

START TRANSACTION;


-- STEP 32: UPDATE STUDENT 3 MARKS

UPDATE Students
SET Marks = 80
WHERE StudentID = 3;


-- STEP 33: CHECK TEMPORARY UPDATE

SELECT * FROM Students
WHERE StudentID = 3;


-- STEP 34: ROLLBACK TRANSACTION

ROLLBACK;


-- VERIFY ORIGINAL MARKS

SELECT * FROM Students
WHERE StudentID = 3;


-- STEP 35: START NEW TRANSACTION

START TRANSACTION;


-- STEP 36: UPDATE STUDENT 3 MARKS

UPDATE Students
SET Marks = 92
WHERE StudentID = 3;


-- STEP 37: COMMIT TRANSACTION

COMMIT;


-- STEP 38: CHECK SAVED MARKS

SELECT * FROM Students
WHERE StudentID = 3;


-- STEP 39: DATABASE BACKUP
-- Backup means creating copies of database tables.


-- STEP 40: BACKUP COURSES TABLE

CREATE TABLE Courses_Backup LIKE Courses;

INSERT INTO Courses_Backup
SELECT * FROM Courses;


-- STEP 41: BACKUP STUDENTS TABLE

CREATE TABLE Students_Backup LIKE Students;

INSERT INTO Students_Backup
SELECT * FROM Students;


-- STEP 42: BACKUP MARKS HISTORY

CREATE TABLE MarksHistory_Backup LIKE MarksHistory;

INSERT INTO MarksHistory_Backup
SELECT * FROM MarksHistory;


-- STEP 43: VERIFY BACKUPS

SELECT * FROM Courses_Backup;

SELECT * FROM Students_Backup;

SELECT * FROM MarksHistory_Backup;


-- STEP 44: CHECK STUDENT BACKUP

SELECT * FROM Students_Backup;


-- STEP 45: DELETE STUDENT 4

DELETE FROM Students
WHERE StudentID = 4;


-- STEP 46: CHECK ORIGINAL TABLE

SELECT * FROM Students;


-- STEP 47: RECOVER STUDENT 4

INSERT INTO Students
SELECT *
FROM Students_Backup
WHERE StudentID = 4;


-- STEP 48: VERIFY RECOVERED STUDENT

SELECT * FROM Students
WHERE StudentID = 4;


-- STEP 49: DATABASE SECURITY
-- Security protects database from unauthorized access.
-- CREATE USER and GRANT are practiced separately
-- on a MySQL server where you have administrator access.


-- STEP 50: CREATE INDEX ON COURSE

CREATE INDEX idx_course
ON Students(Course);


-- STEP 51: CREATE INDEX ON MARKS

CREATE INDEX idx_marks
ON Students(Marks);


-- STEP 52: ANALYZE QUERY

EXPLAIN
SELECT * FROM Students
WHERE Course = 'BSCS';


-- STEP 53: SEARCH STUDENTS BY MARKS

SELECT * FROM Students
WHERE Marks >= 80;


-- STEP 54: SORT STUDENTS BY MARKS

SELECT * FROM Students
ORDER BY Marks DESC;


-- STEP 55: TOTAL STUDENTS

SELECT COUNT(*) AS TotalStudents
FROM Students;


-- STEP 56: HIGHEST MARKS

SELECT MAX(Marks) AS HighestMarks
FROM Students;


-- STEP 57: LOWEST MARKS

SELECT MIN(Marks) AS LowestMarks
FROM Students;


-- STEP 58: AVERAGE MARKS

SELECT AVG(Marks) AS AverageMarks
FROM Students;


-- STEP 59: COURSE-WISE STUDENT COUNT

SELECT Course, COUNT(*) AS TotalStudents
FROM Students
GROUP BY Course;


-- STEP 60: FINAL STUDENTS TABLE

SELECT * FROM Students;


-- STEP 61: FINAL COURSES TABLE

SELECT * FROM Courses;


-- STEP 62: FINAL STUDENT DETAILS VIEW

SELECT * FROM StudentDetails;


-- STEP 63: FINAL MARKS HISTORY

SELECT * FROM MarksHistory;


-- STEP 64: FINAL STUDENT BACKUP

SELECT * FROM Students_Backup;


-- STEP 65: FINAL COURSE BACKUP

SELECT * FROM Courses_Backup;


-- STEP 66: FINAL MARKS HISTORY BACKUP

SELECT * FROM MarksHistory_Backup;


-- STEP 67: CHECK ALL PROCEDURE STUDENTS

CALL GetAllStudents();


-- STEP 68: CHECK TOP STUDENTS

CALL GetTopStudents();
