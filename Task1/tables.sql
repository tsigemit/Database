CREATE TABLE Students(
  idnr NUMERIC(10,0) PRIMARY KEY, -- This needs to be a large enough integer type to accept a 10 digit number
  name TEXT NOT NULL,
  login TEXT NOT NULL,
  program TEXT NOT NULL
);

CREATE TABLE Branches(
  name TEXT,
  program TEXT,
  PRIMARY KEY (name, program)
);

CREATE TABLE Courses(
  code CHAR(6) PRIMARY KEY,
  name TEXT NOT NULL,
  credits FLOAT NOT NULL,
  department TEXT
);


CREATE TABLE LimitedCourses(
  course CHAR(6) PRIMARY KEY,
  seats INTEGER NOT NULL
);


CREATE TABLE Classifications (
  title TEXT PRIMARY KEY
);

CREATE TABLE Classified (
  course CHAR(6) REFERENCES Courses,
  classification TEXT REFERENCES Classifications,
  PRIMARY KEY (course, classification)
);

CREATE TABLE StudentBranches(
  student NUMERIC(10,0) PRIMARY KEY,
  program TEXT  NOT NULL,
  branch TEXT  NOT NULL,
  FOREIGN KEY (student) REFERENCES Students(idnr),
  FOREIGN KEY (branch,program) REFERENCES Branches(name,program)
);

CREATE TABLE MandatoryProgram(
  course CHAR(6) REFERENCES Courses,
  program TEXT NOT NULL,
  PRIMARY KEY (program,course)
);


CREATE TABLE MandatoryBranch(
  course CHAR(6) REFERENCES Courses,
  branch TEXT,
  program TEXT,
  FOREIGN KEY (branch,program) REFERENCES Branches(name,program),
  PRIMARY KEY (program,branch,course)
);

CREATE TABLE RecommendedBranch(
  course CHAR(6) REFERENCES Courses,
  branch TEXT,
  program TEXT,
  FOREIGN KEY (branch,program) REFERENCES Branches(name,program),
  PRIMARY KEY (program,branch,course)
);

CREATE TABLE Registered(
  student NUMERIC(10,0) REFERENCES Students,
  course CHAR(6) REFERENCES Courses,
  PRIMARY KEY (student,course)
);

CREATE TABLE Taken(
  student NUMERIC(10,0) REFERENCES Students,
  course CHAR(6) REFERENCES Courses,
  grade CHAR(1) NOT NULL,
  CONSTRAINT ValidGrade CHECK (grade IN ('U','3','4','5')),
  PRIMARY KEY (student,course)
);

CREATE TABLE WaitingList(
  student NUMERIC(10,0) REFERENCES Students,
  course CHAR(6) REFERENCES LimitedCourses,
  position INT NOT NULL, -- TIMESTAMP or SEQUENCE is also OK
  PRIMARY KEY (student,course)
);


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

INSERT INTO StudentBranches VALUES (2222222222,'Prog1','B1');
INSERT INTO StudentBranches VALUES (3333333333,'Prog2','B1');
INSERT INTO StudentBranches VALUES (4444444444,'Prog1','B1');

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


