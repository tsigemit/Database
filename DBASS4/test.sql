SELECT *from PassedCourses;
SELECT *from OverFull;
SELECT *from fullCourses;
SELECT *from FullCourseRegistration;
SELECT *from WaitingList;
SELECT *from CourseQueuePositions;
SELECT *from Registrations WHERE course ='ME002';
SELECT course FROM PassedCourses WHERE course ='CS001';
DELETe FROM WaitingList WHERE course ='CS009' AND student=9210031820;
INSERT INTO  Registrations (student, course) VALUES (9803258004, 'ME001');
INSERT INTO waitinglist (student, course, position) VALUES (9210031820, 'ME002 ', 1);
INSERT INTO Registered(student, course) VALUES (9210031820, 'ME002');
with value1
AS (select course, count(course) as numStudents from Registered group by course),
 value2 AS (select course, numStudents from value1, Limitedcourse where seats<=numStudents AND course=code) 
select *from value2;
