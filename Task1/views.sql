-- View: StudentsFollowing
-- For all students, their names, and the program and branch (if any) they
-- are following.
CREATE OR REPLACE VIEW BasicInformation AS
SELECT idnr, name, login, Students.program, branch
FROM Students LEFT OUTER JOIN StudentBranches ON idnr = student;

-- View: FinishedCourses
-- For all students, all finished courses, along with their names, grades
-- (grade 'U', '3', '4' or '5') and number of credits.
CREATE OR REPLACE VIEW FinishedCourses AS
SELECT idnr as student, course, grade, credits
FROM Students
  JOIN Taken ON idnr = student
  JOIN Courses ON code = course;

-- View: Registrations
-- All registered and waiting students for all courses, along with their
-- waiting status ('registered' or 'waiting').
CREATE OR REPLACE VIEW Registrations AS
(SELECT student, course, 'registered' AS status
 FROM Registered)
UNION
(SELECT student, course, 'waiting' AS status
 FROM WaitingList);

-- View: PassedCourses
-- For all students, all passed courses, i.e. courses finished with a grade
-- other than 'U', and the number of credits for those courses. This view is
-- intended as a helper view towards the PathToGraduation view, and will not be
-- directly used by your application.
CREATE OR REPLACE VIEW PassedCourses AS
SELECT student, course, credits
 FROM FinishedCourses
 WHERE grade != 'U';

-- View: UnreadMandatory
-- For all students, the mandatory courses (branch and program) they have not
-- yet passed. This view is intended as a helper view towards the
-- PathToGraduation view, and will not be directly used by your application.
CREATE OR REPLACE VIEW UnreadMandatory AS
((SELECT idnr as student, course
  FROM Students JOIN Mandatoryprogram USING (program))
UNION
(SELECT student, course
 FROM StudentBranches JOIN MandatoryBranch USING (branch, program) ))
EXCEPT
(SELECT student, course FROM PassedCourses);

CREATE VIEW PathToGraduation AS
WITH
AllClassified AS -- This is a clever but not necessary trick to make the classification queries below simpler
 (SELECT student, classification, COUNT(*) as num, SUM(credits) total
  FROM PassedCourses JOIN Classified USING (course) 
  GROUP BY (student, classification)),
MandatoryLeft AS
 (SELECT student, COUNT(Course) AS mandatory_courses_left
  FROM UnreadMandatory
  GROUP BY student),
TotalCredits AS
 (SELECT student, SUM(credits) AS total_credits
  FROM PassedCourses
  GROUP BY student),
BranchCredits AS
 (SELECT student, SUM(credits) AS branch_credits
  FROM StudentBranches
    JOIN PassedCourses USING (student)
    JOIN RecommendedBranch USING (branch,program)
  GROUP BY student),
MathCredits AS
 (SELECT student, total AS math_credits FROM AllClassified WHERE classification = 'math'),
ResearchCredits AS
 (SELECT student, total AS research_credits FROM AllClassified WHERE classification = 'research'),
SeminarCount AS
 (SELECT student, num AS seminar_courses FROM AllClassified WHERE classification = 'seminar')
-- End of WITH-clause, actual query starts here
SELECT 
  student, 
  COALESCE(total_credits,0) totalCredits, -- The underscore naming in attributes is not required, but may help understanding
  COALESCE(mandatory_courses_left,0) mandatoryLeft, 
  COALESCE(math_credits,0) mathCredits, 
  COALESCE(research_credits,0) researchCredits, 
  COALESCE(seminar_courses,0) seminarsCourses,
  (branch IS NOT NULL
   AND mandatory_courses_left IS NULL
   AND branch_credits >= 10
   AND math_credits >= 20
   AND research_credits >= 10
   AND seminar_courses >= 1) AS qualified
FROM (SELECT idnr as student FROM Students) Students
  LEFT OUTER JOIN StudentBranches USING (student)
  LEFT OUTER JOIN MandatoryLeft USING (student)
  LEFT OUTER JOIN BranchCredits USING (student)
  LEFT OUTER JOIN TotalCredits USING (student)
  LEFT OUTER JOIN MathCredits USING (student)
  LEFT OUTER JOIN ResearchCredits USING (student)
  LEFT OUTER JOIN SeminarCount USING (student)
