----Tables 
CREATE TABLE Program (
  name TEXT PRIMARY KEY,
  abbreviation TEXT NOT NULL
);

CREATE TABLE Department (
  name TEXT PRIMARY KEY,
  abbreviation TEXT NOT NULL UNIQUE
);

CREATE TABLE Hosts (
  department TEXT NOT NULL REFERENCES Department(name),
  program TEXT NOT NULL REFERENCES Program(name),
  PRIMARY KEY(department, program)
);

CREATE TABLE Student (
  ssn NUMERIC (10) PRIMARY KEY,
  name TEXT NOT NULL,
  login TEXT NOT NULL UNIQUE,
  program TEXT NOT NULL REFERENCES Program(name),
  UNIQUE(ssn, program)
);

CREATE TABLE Branch (
  name TEXT NOT NULL,
  program TEXT NOT NULL REFERENCES Program(name),
  PRIMARY KEY(name, program)
);

CREATE TABLE BelongsTo (
  student NUMERIC (10) PRIMARY KEY REFERENCES Student(ssn),
  branch TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY(student, program) REFERENCES Student(ssn, program),
  FOREIGN KEY(branch, program) REFERENCES Branch(name, program)
);

CREATE TABLE Course (
  code VARCHAR(5) PRIMARY KEY,
  name TEXT NOT NULL,
  credits INTEGER NOT NULL,
  department TEXT NOT NULL REFERENCES Department(name)
);

CREATE TABLE Prerequisite (
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  prerequisite VARCHAR(5) NOT NULL REFERENCES Course(code),
  PRIMARY KEY(course, prerequisite)
);

CREATE TABLE Classification (
  name TEXT PRIMARY KEY
);

CREATE TABLE Classified (
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  classification TEXT NOT NULL REFERENCES Classification(name),
  PRIMARY KEY(course, classification)
);

CREATE TABLE MandatoryProgram (
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  program TEXT NOT NULL REFERENCES Program(name),
  PRIMARY KEY(course, program)
);

CREATE TABLE MandatoryBranch (
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  branch TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY(branch, program) REFERENCES Branch(name, program),
  PRIMARY KEY(course, branch, program)
);

CREATE TABLE RecommendedBranch (
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  branch TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY(branch, program) REFERENCES Branch(name, program),
  PRIMARY KEY(course, branch, program)
);

CREATE TABLE Registered (
  student NUMERIC (10) NOT NULL REFERENCES Student(ssn),
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  PRIMARY KEY(student, course)
);

CREATE TABLE Taken (
  student NUMERIC (10) NOT NULL REFERENCES Student(ssn),
  course VARCHAR(5) NOT NULL REFERENCES Course(code),
  grade CHAR(1) NOT NULL CHECK (grade IN ('U', '3','4','5')),
  PRIMARY KEY(student, course)
);

CREATE TABLE LimitedCourse (
  code VARCHAR(5) PRIMARY KEY REFERENCES Course(code),
  seats INTEGER NOT NULL CHECK(seats >0 AND seats <=3)
);

CREATE TABLE WaitingList (
  student NUMERIC (10) NOT NULL REFERENCES Student(ssn),
  course VARCHAR(5) NOT NULL REFERENCES LimitedCourse(code),
  position INTEGER NOT NULL,
  UNIQUE(position, course),
  PRIMARY KEY(student, course)
);
---Insert Statements
--
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO program (name, abbreviation) VALUES ('Computer Science and Engineering', 'CSEP');
INSERT INTO program (name, abbreviation) VALUES ('Information Technology', 'INTP');
--
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO branch (name, program) VALUES ('Algorithms, Languages and Logic', 'Computer Science and Engineering');
INSERT INTO branch (name, program) VALUES ('Computer Systems and Networks', 'Computer Science and Engineering');
INSERT INTO branch (name, program) VALUES ('Software Engineering', 'Computer Science and Engineering');
INSERT INTO branch (name, program) VALUES ('Software Engineering', 'Information Technology');
INSERT INTO branch (name, program) VALUES ('Interaction Design', 'Information Technology');
INSERT INTO branch (name, program) VALUES ('Algorithms, Languages and Logic', 'Information Technology');
--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO student (ssn, name, login, program) VALUES (9311020011, 'Roger Hansson', 'hanro', 'Computer Science and Engineering');
INSERT INTO student (ssn, name, login, program) VALUES (9411199442, 'Evelyn Bjork', 'bjoev', 'Computer Science and Engineering');
INSERT INTO student (ssn, name, login, program) VALUES (9803258004, 'Rosa Akesson', 'akero', 'Computer Science and Engineering');
INSERT INTO student (ssn, name, login, program) VALUES (8908307138, 'Isak Axelsson', 'axeis', 'Information Technology');
INSERT INTO student (ssn, name, login, program) VALUES (9704224170, 'Alex Lundqvist', 'lunal', 'Information Technology');
INSERT INTO student (ssn, name, login, program) VALUES (9210031820, 'Sandra Lindberg', 'linsa', 'Information Technology');
--
-- Data for Name: belongsto; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO belongsto (student, branch, program) VALUES (9311020011, 'Algorithms, Languages and Logic', 'Computer Science and Engineering');
INSERT INTO belongsto (student, branch, program) VALUES (9411199442, 'Computer Systems and Networks', 'Computer Science and Engineering');
INSERT INTO belongsto (student, branch, program) VALUES (9803258004, 'Software Engineering', 'Computer Science and Engineering');
INSERT INTO belongsto (student, branch, program) VALUES (8908307138, 'Software Engineering', 'Information Technology');
INSERT INTO belongsto (student, branch, program) VALUES (9704224170, 'Interaction Design', 'Information Technology');
--
-- Data for Name: classification; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO classification (name) VALUES ('Research');
INSERT INTO classification (name) VALUES ('Mathematical');
INSERT INTO classification (name) VALUES ('Seminar');
--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO department (name, abbreviation) VALUES ('Computer Science', 'CS');
INSERT INTO department (name, abbreviation) VALUES ('Computer Engineering', 'CE');
INSERT INTO department (name, abbreviation) VALUES ('Mathematical Science', 'MS');
INSERT INTO department (name, abbreviation) VALUES ('Management and Economics', 'ME');


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO course (code, name, credits, department) VALUES ('CS001', 'Object Oriented Programming', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CS002', 'Data Structures', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CS003', 'Databases', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CS004', 'Software Engineering Project', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CE001', 'Computer Hardware', 10, 'Computer Engineering');
INSERT INTO course (code, name, credits, department) VALUES ('CE002', 'Machine Oriented Programming', 10, 'Computer Engineering');
INSERT INTO course (code, name, credits, department) VALUES ('CE003', 'Computer Networks', 10, 'Computer Engineering');
INSERT INTO course (code, name, credits, department) VALUES ('CE004', 'Computer Engineering Project', 10, 'Computer Engineering');
INSERT INTO course (code, name, credits, department) VALUES ('MS001', 'Discrete Mathematics', 10, 'Mathematical Science');
INSERT INTO course (code, name, credits, department) VALUES ('MS002', 'Linear Algebra', 10, 'Mathematical Science');
INSERT INTO course (code, name, credits, department) VALUES ('MS003', 'Calculus', 10, 'Mathematical Science');
INSERT INTO course (code, name, credits, department) VALUES ('ME001', 'Project Management', 10, 'Management and Economics');
INSERT INTO course (code, name, credits, department) VALUES ('ME002', 'Research Methodology', 10, 'Management and Economics');
INSERT INTO course (code, name, credits, department) VALUES ('CS005', 'Algorithms', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CS006', 'Programming Language Technology', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('ME003', 'Agile Development', 10, 'Management and Economics');
INSERT INTO course (code, name, credits, department) VALUES ('CE005', 'Operating Systems', 10, 'Computer Engineering');
INSERT INTO course (code, name, credits, department) VALUES ('CE006', 'Routing and Switching', 10, 'Computer Engineering');
INSERT INTO course (code, name, credits, department) VALUES ('CS007', 'Human Computer Interaction', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CS008', 'Mobile Computing', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CS009', 'Artificial Intelligence', 10, 'Computer Science');
INSERT INTO course (code, name, credits, department) VALUES ('CE007', 'Masterclass in Areas of Advance', 10, 'Computer Engineering');
--
-- Data for Name: classified; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO classified (course, classification) VALUES ('MS001 ', 'Mathematical');
INSERT INTO classified (course, classification) VALUES ('MS002 ', 'Mathematical');
INSERT INTO classified (course, classification) VALUES ('MS003 ', 'Mathematical');
INSERT INTO classified (course, classification) VALUES ('ME001 ', 'Seminar');
INSERT INTO classified (course, classification) VALUES ('ME002 ', 'Seminar');
INSERT INTO classified (course, classification) VALUES ('ME002 ', 'Research');
INSERT INTO classified (course, classification) VALUES ('CS007 ', 'Seminar');
INSERT INTO classified (course, classification) VALUES ('CS009 ', 'Research');
INSERT INTO classified (course, classification) VALUES ('CE007 ', 'Research');
--
-- Data for Name: hosts; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO hosts (department, program) VALUES ('Computer Science', 'Computer Science and Engineering');
INSERT INTO hosts (department, program) VALUES ('Computer Engineering', 'Computer Science and Engineering');
INSERT INTO hosts (department, program) VALUES ('Computer Science', 'Information Technology');
INSERT INTO hosts (department, program) VALUES ('Management and Economics', 'Information Technology');
--
-- Data for Name: limitedcourse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO limitedcourse (code, seats) VALUES ('CS001 ', 1);
INSERT INTO limitedcourse (code, seats) VALUES ('ME002 ', 1);
INSERT INTO limitedcourse (code, seats) VALUES ('CS009 ', 1);
--
-- Data for Name: mandatorybranch; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS005 ', 'Algorithms, Languages and Logic', 'Computer Science and Engineering');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS006 ', 'Algorithms, Languages and Logic', 'Computer Science and Engineering');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS005 ', 'Algorithms, Languages and Logic', 'Information Technology');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS006 ', 'Algorithms, Languages and Logic', 'Information Technology');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CE005 ', 'Computer Systems and Networks', 'Computer Science and Engineering');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CE006 ', 'Computer Systems and Networks', 'Computer Science and Engineering');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('ME003 ', 'Software Engineering', 'Computer Science and Engineering');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS005 ', 'Software Engineering', 'Computer Science and Engineering');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('ME003 ', 'Software Engineering', 'Information Technology');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS005 ', 'Software Engineering', 'Information Technology');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS007 ', 'Interaction Design', 'Information Technology');
INSERT INTO mandatorybranch (course, branch, program) VALUES ('CS008 ', 'Interaction Design', 'Information Technology');
--
-- Data for Name: mandatoryprogram; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO mandatoryprogram (course, program) VALUES ('CS001 ', 'Computer Science and Engineering');
INSERT INTO mandatoryprogram (course, program) VALUES ('CS002 ', 'Computer Science and Engineering');
INSERT INTO mandatoryprogram (course, program) VALUES ('CE001 ', 'Computer Science and Engineering');
INSERT INTO mandatoryprogram (course, program) VALUES ('CE003 ', 'Computer Science and Engineering');
INSERT INTO mandatoryprogram (course, program) VALUES ('MS001 ', 'Computer Science and Engineering');
INSERT INTO mandatoryprogram (course, program) VALUES ('MS002 ', 'Computer Science and Engineering');
INSERT INTO mandatoryprogram (course, program) VALUES ('CS001 ', 'Information Technology');
INSERT INTO mandatoryprogram (course, program) VALUES ('CS002 ', 'Information Technology');
INSERT INTO mandatoryprogram (course, program) VALUES ('CS004 ', 'Information Technology');
INSERT INTO mandatoryprogram (course, program) VALUES ('ME001 ', 'Information Technology');
INSERT INTO mandatoryprogram (course, program) VALUES ('MS001 ', 'Information Technology');
INSERT INTO mandatoryprogram (course, program) VALUES ('MS002 ', 'Information Technology');
--
-- Data for Name: prerequisite; Type: TABLE DATA; Schema: public; Owner: postgres
--
--INSERT INTO prerequisite (course, prerequisite) VALUES ('CS002 ', 'CS005 ');
INSERT INTO prerequisite (course, prerequisite) VALUES ('CS002 ', 'CS006 ');
--INSERT INTO prerequisite (course, prerequisite) VALUES ('CS001 ', 'CS006 ');
--INSERT INTO prerequisite (course, prerequisite) VALUES ('ME001 ', 'ME003 ');
--INSERT INTO prerequisite (course, prerequisite) VALUES ('CS001 ', 'ME003 ');
--INSERT INTO prerequisite (course, prerequisite) VALUES ('CE002 ', 'CE005 ');
INSERT INTO prerequisite (course, prerequisite) VALUES ('CE001 ', 'CE005 ');
--INSERT INTO prerequisite (course, prerequisite) VALUES ('CE003 ', 'CE006 ');
--INSERT INTO prerequisite (course, prerequisite) VALUES ('CS003 ', 'CS008 ');
INSERT INTO prerequisite (course, prerequisite) VALUES ('CS001 ', 'CS009 ');
INSERT INTO prerequisite (course, prerequisite) VALUES ('CS002 ', 'CS009 ');


--
-- Data for Name: recommendedbranch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO recommendedbranch (course, branch, program) VALUES ('CS009 ', 'Algorithms, Languages and Logic', 'Computer Science and Engineering');
INSERT INTO recommendedbranch (course, branch, program) VALUES ('CS009 ', 'Algorithms, Languages and Logic', 'Information Technology');
INSERT INTO recommendedbranch (course, branch, program) VALUES ('CE007 ', 'Computer Systems and Networks', 'Computer Science and Engineering');
INSERT INTO recommendedbranch (course, branch, program) VALUES ('ME002 ', 'Software Engineering', 'Computer Science and Engineering');
INSERT INTO recommendedbranch (course, branch, program) VALUES ('ME002 ', 'Software Engineering', 'Information Technology');
INSERT INTO recommendedbranch (course, branch, program) VALUES ('ME002 ', 'Interaction Design', 'Information Technology');
--
-- Data for Name: registered; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO registered (student, course) VALUES (9311020011, 'CS001 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'CS002 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'CS003 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'CE001 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'MS001 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'MS002 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'MS003 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'ME001 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'ME002 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'CS005 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'CS006 ');
INSERT INTO registered (student, course) VALUES (9311020011, 'CE003 ');
--INSERT INTO registered (student, course) VALUES (9311020011, 'CS009 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'CS002 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'CS006 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'CS004 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'CE003 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'MS002 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'MS003 ');
--INSERT INTO registered (student, course) VALUES (9411199442, 'ME001 ');
INSERT INTO registered (student, course) VALUES (9411199442, 'ME002 ');
INSERT INTO registered (student, course) VALUES (8908307138, 'CS009 ');
INSERT INTO registered (student, course) VALUES (9803258004, 'ME002 ');
--INSERT INTO registered (student, course) VALUES (8908307138, 'ME002 ');
--INSERT INTO registered (student, course) VALUES (9704224170, 'CS009 ');
--INSERT INTO registered (student, course) VALUES (9210031820, 'CS009 ');
--
-- Data for Name: taken; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CS001 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CS002 ', '4');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CS003 ', '5');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CE001 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'MS001 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'MS002 ', '4');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'MS003 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'ME001 ', '5');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'ME002 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CS005 ', '5');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CS006 ', '4');
INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CE003 ', '5');
--INSERT INTO taken (student, course, grade) VALUES (9311020011, 'CS009 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9411199442, 'CS002 ', 'U');
INSERT INTO taken (student, course, grade) VALUES (9411199442, 'CS004 ', '3');
INSERT INTO taken (student, course, grade) VALUES (9411199442, 'CE003 ', 'U');
INSERT INTO taken (student, course, grade) VALUES (9411199442, 'MS002 ', '5');
INSERT INTO taken (student, course, grade) VALUES (9411199442, 'MS003 ', '4');
INSERT INTO taken (student, course, grade) VALUES (9411199442, 'CS006 ', '4');
--INSERT INTO taken (student, course, grade) VALUES (9411199442, 'ME001 ', 'U');
--INSERT INTO taken (student, course, grade) VALUES (9411199442, 'ME002 ', '4');

--
-- Data for Name: waitinglist; Type: TABLE DATA; Schema: public; Owner: postgres
--
--INSERT INTO waitinglist (student, course, "position") VALUES (9411199442, 'ME002 ', 1);
--INSERT INTO waitinglist (student, course, "position") VALUES (9704224170, 'ME002 ', 1);
--INSERT INTO waitinglist (student, course, "position") VALUES (9803258004, 'ME002 ', 2);
INSERT INTO waitinglist (student, course, "position") VALUES (9411199442, 'CS009 ', 1);
INSERT INTO waitinglist (student, course, "position") VALUES (9704224170, 'CS009 ', 2);
INSERT INTO waitinglist (student, course, "position") VALUES (9210031820, 'CS009 ', 3);
--
-- PostgreSQL database dump complete
--
---Views
CREATE VIEW StudentsFollowing (student, program, branch) AS
  SELECT ssn, Student.program, branch FROM Student
  LEFT OUTER JOIN BelongsTo ON Student.ssn = BelongsTo.student;

CREATE VIEW FinishedCourses(student, course, grade, credits) AS
	  SELECT student, course, grade, credits
	  FROM Taken, Course
	  WHERE Taken.course = Course.code;

CREATE VIEW Registrations(student, course, status) AS
	  SELECT student, course, 'registered' AS status
	  FROM Registered
	  UNION
	  SELECT student, course, 'waiting' AS status
	  FROM WaitingList;

CREATE VIEW PassedCourses(student, course, credits) AS
  SELECT student, course, credits
  FROM (
    SELECT * FROM FinishedCourses WHERE grade <> 'U'
  ) AS FinishedCourses;
CREATE VIEW UnreadMandatory(student, course) AS
  SELECT student, course
  FROM (
    SELECT student, course FROM StudentsFollowing, MandatoryProgram
    WHERE StudentsFollowing.program = MandatoryProgram.program
    UNION
    SELECT student, course FROM StudentsFollowing, MandatoryBranch
    WHERE StudentsFollowing.branch = MandatoryBranch.branch
  ) AS Mandatories
  EXCEPT
  SELECT student, course
  FROM (
    SELECT student, course FROM PassedCourses
  ) AS Passed
  ORDER BY student;
CREATE VIEW PathToGraduation (student, totalCredits, mandatoryLeft, mathCredits, researchCredits, seminarCourses, status)
AS(                    ---------------FROM PASSED AND MANDATORY
 WITH TotalCredits AS (SELECT ssn AS student,SUM (PassedCourses.credits) AS totalCredits FROM Student LEFT OUTER JOIN PassedCourses ON ssn=student GROUP BY ssn),
 MandatoryCredits  AS (select distinct ssn AS student, COUNT(UnreadMandatory.course) AS mandatoryLeft FROM Student LEFT JOIN UnreadMandatory ON ssn=student GROUP BY ssn), 
Final_Value1 AS (SELECT DISTINCT TotalCredits.student, totalCredits,mandatoryLeft FROM TotalCredits LEFT OUTER JOIN MandatoryCredits ON TotalCredits.student=MandatoryCredits.student),
                       ---------- For Maths Research and Seminar Courses
MaCredits AS (SELECT DISTINCT student, SUM(credits) AS MathematicalCredits FROM PassedCourses, Classified WHERE (PassedCourses.course=Classified.course AND classified.classification='Mathematical') GROUP BY student),
ReCredits AS (SELECT DISTINCT student, SUM(credits) as ResearchCredits FROM PassedCourses, Classified WHERE (PassedCourses.course=Classified.course AND classified.classification='Research') GROUP BY student),
SeCredits AS (SELECT DISTINCT student, COUNT(credits) AS SeminarCourses FROM PassedCourses, Classified WHERE (PassedCourses.course=Classified.course AND classified.classification='Seminar') GROUP BY student),
Final_Value2 AS (SELECT DISTINCT MaCredits.student,MaCredits.MathematicalCredits,ReCredits.ResearchCredits, SeCredits.SeminarCourses  FROM MaCredits LEFT OUTER JOIN ReCredits ON MaCredits.student=ReCredits.student LEFT OUTER JOIN SeCredits ON ReCredits.student=SeCredits.student),
Final_Value3 AS (SELECT ssn, mathematicalCredits, ResearchCredits, SeminarCourses FROM Student LEFT OUTER JOIN Final_Value2 ON Student.ssn=student),
                         --------TO ADD STATUS
Status AS ((SELECT student,TRUE AS status FROM Final_Value1 WHERE totalCredits=120) UNION SELECT student, FALSE AS status FROM Final_Value1 WHERE totalCredits!=120),
Final_Result AS (SELECT Final_Value1.student, totalCredits, mandatoryLeft,mathematicalCredits,researchCredits,seminarCourses FROM Final_Value1 LEFT  JOIN Final_Value2 ON Final_Value1.student=Final_Value2.student)
(SELECT DISTINCT Final_Result.student, COALESCE(totalCredits,0) AS totalCredits,COALESCE(mandatoryLeft,0) AS mandatoryLeft,COALESCE(mathematicalCredits,0) AS mathCredits, COALESCE(researchCredits,0) AS researchCredits, COALESCE(seminarCourses,0) AS seminarCourses,COALESCE(status,FALSE) AS status  FROM Final_Result LEFT JOIN Status ON Final_Result.student=Status.student ORDER BY totalCredits DESC)
);
---For task 3
CREATE VIEW CourseQueuePositions (course, student, place) as SELECT course, student, position from WaitingList;

CREATE VIEW fullCourses(course, numStudents) AS 
with value1
AS (select course, count(course) as numStudents from Registered group by course),
 value2 AS (select course, numStudents from value1, Limitedcourse where seats<=numStudents AND course=code) 
select *from value2;
CREATE VIEW OverFull(course) AS
WITH Table1 AS (SELECT DISTINCT course, COUNT(course) AS counter FROM Registered, LimitedCourse WHERE course=code GROUP BY course, code),
Table2 AS (SELECT DISTINCT course FROM LimitedCourse NATURAL JOIN Table1 WHERE counter > seats)
SELECT *FROM Table2;
--- for for task 4
CREATE VIEW RegisteredAndWaiting(student, course, status, place) AS
	  SELECT student, course, status, NULL AS place FROM Registrations WHERE status='registered'
	  UNION
	  SELECT student, course, 'waiting' AS status, place FROM CourseQueuePositions;
	  



