DROP OWNED BY jonas CASCADE;
\i tables.sql
\i views.sql
\i inserts.sql

SELECT * FROM BasicInformation;

SELECT * FROM FinishedCourses;

SELECT * FROM PassedCourses;

SELECT * FROM Registrations;

SELECT * FROM UnreadMandatory;

SELECT * FROM PathToGraduation;


--ToCheck
--DELETE FROM MandatoryProgram;
--DELETE FROM MandatoryBranch;
--SELECT * FROM PathToGraduation;
