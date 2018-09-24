CREATE TABLE Program (
  name TEXT PRIMARY KEY,
  abbreviation CHAR(4) NOT NULL
);

CREATE TABLE Department (
  name TEXT PRIMARY KEY,
  abbreviation CHAR(2) NOT NULL UNIQUE
);

CREATE TABLE Hosts (
  department TEXT NOT NULL REFERENCES Department(name),
  program TEXT NOT NULL REFERENCES Program(name),
  PRIMARY KEY(department, program)
);

CREATE TABLE Student (
  ssn NUMERIC(10) PRIMARY KEY,
  name TEXT NOT NULL,
  login VARCHAR(5) NOT NULL UNIQUE,
  program TEXT NOT NULL REFERENCES Program(name),
  UNIQUE(ssn, program)
);

CREATE TABLE Branch (
  name TEXT NOT NULL,
  program TEXT NOT NULL REFERENCES Program(name),
  PRIMARY KEY(name, program)
);

CREATE TABLE BelongsTo (
  student NUMERIC(10) PRIMARY KEY REFERENCES Student(ssn),
  branch TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY(student, program) REFERENCES Student(ssn, program),
  FOREIGN KEY(branch, program) REFERENCES Branch(name, program)
);

CREATE TABLE Course (
  code NUMERIC(6) PRIMARY KEY,
  name TEXT NOT NULL,
  credits INTEGER NOT NULL,
  department TEXT NOT NULL REFERENCES Department(name)
);

CREATE TABLE Prerequisite (
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  prerequisite NUMERIC(6) NOT NULL REFERENCES Course(code),
  PRIMARY KEY(course, prerequisite)
);

CREATE TABLE Classification (
  name TEXT PRIMARY KEY
);

CREATE TABLE Classified (
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  classification TEXT NOT NULL REFERENCES Classification(name),
  PRIMARY KEY(course, classification)
);

CREATE TABLE MandatoryProgram (
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  program TEXT NOT NULL REFERENCES Program(name),
  PRIMARY KEY(course, program)
);

CREATE TABLE MandatoryBranch (
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  branch TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY(branch, program) REFERENCES Branch(name, program),
  PRIMARY KEY(course, branch, program)
);

CREATE TABLE RecommendedBranch (
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  branch TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY(branch, program) REFERENCES Branch(name, program),
  PRIMARY KEY(course, branch, program)
);

CREATE TABLE Registered (
  student NUMERIC(10) NOT NULL REFERENCES Student(ssn),
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  PRIMARY KEY(student, course)
);

CREATE TABLE Taken (
  student NUMERIC(10) NOT NULL REFERENCES Student(ssn),
  course NUMERIC(6) NOT NULL REFERENCES Course(code),
  grade CHAR(1) NOT NULL,
  PRIMARY KEY(student, course)
);

CREATE TABLE LimitedCourse (
  code NUMERIC(6) PRIMARY KEY REFERENCES Course(code),
  seats INTEGER NOT NULL
);

CREATE TABLE WaitingList (
  student NUMERIC(10) NOT NULL REFERENCES Student(ssn),
  course NUMERIC(6) NOT NULL REFERENCES LimitedCourse(code),
  position INTEGER NOT NULL,
  UNIQUE(position, course),
  PRIMARY KEY(student, course)
);
