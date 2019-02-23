
INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');

INSERT INTO Students VALUES (1111111111,'S1','ls1','Prog1');
INSERT INTO Students VALUES (2222222222,'S2','ls2','Prog1');
INSERT INTO Students VALUES (3333333333,'S3','ls3','Prog2');
INSERT INTO Students VALUES (4444444444,'S4','ls4','Prog1');

INSERT INTO Courses VALUES ('CCC111','C1',10,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',40,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');

INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);

INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');

INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');

INSERT INTO StudentBranches VALUES (2222222222,'B1','Prog1');
INSERT INTO StudentBranches VALUES (3333333333,'B1','Prog2');
INSERT INTO StudentBranches VALUES (4444444444,'B1','Prog1');

INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');

INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC555', 'B1', 'Prog2');

INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');

INSERT INTO Registered VALUES (1111111111,'CCC111');
INSERT INTO Registered VALUES (1111111111,'CCC222');
INSERT INTO Registered VALUES (1111111111,'CCC333');

INSERT INTO Registered VALUES (2222222222,'CCC222');

INSERT INTO Taken VALUES(4444444444,'CCC111','5');
INSERT INTO Taken VALUES(4444444444,'CCC222','5');
INSERT INTO Taken VALUES(4444444444,'CCC333','5');
INSERT INTO Taken VALUES(4444444444,'CCC444','5');

INSERT INTO Taken VALUES(1111111111,'CCC111','3');
INSERT INTO Taken VALUES(1111111111,'CCC222','3');
INSERT INTO Taken VALUES(1111111111,'CCC333','3');
INSERT INTO Taken VALUES(1111111111,'CCC444','3');

INSERT INTO Taken VALUES(2222222222,'CCC111','U');
INSERT INTO Taken VALUES(2222222222,'CCC222','U');
INSERT INTO Taken VALUES(2222222222,'CCC444','U');

INSERT INTO WaitingList VALUES(3333333333,'CCC222',1);
INSERT INTO WaitingList VALUES(3333333333,'CCC333',1);
INSERT INTO WaitingList VALUES(2222222222,'CCC333',2);
