CREATE TABLE Department(
	d_name VARCHAR (20) NOT NULL,
	abbreviation VARCHAR(20)NOT NULL,
	PRIMARY KEY (d_name)
);
CREATE TABLE Program(
	p_name VARCHAR (20) NOT NULL,
	abbreviation VARCHAR(20)NOT NULL,
	PRIMARY KEY (p_name),
        department VARCHAR(20) NOT NULL REFERENCES Department (d_name),
);

CREATE TABLE Student(
	  ssn VARCHAR (10) NOT NULL, 
	  s_name VARCHAR (20) NOT NULL,
	  login VARCHAR (20) NOT NULL,
	  program VARCHAR(20)NOT NULL REFERENCES Program (p_name),
	  PRIMARY KEY (ssn),
	  UNIQUE(login),
	  UNIQUE (ssn, program)
);

CREATE TABLE Branch(
	b_name VARCHAR(20) NOT NULL, 
	program VARCHAR(20)NOT NULL REFERENCES Program(p_name),
	UNIQUE (b_name)
);

CREATE TABLE BelongsTo(
	student VARCHAR(20) NOT NULL REFERENCES Student (ssn), 
	branch VARCHAR(20) NOT NULL,
	program VARCHAR(20) UNIQUE NOT NULL,
	FOREIGN KEY (student, program) REFERENCES Student(ssn, program),
	FOREIGN KEY (branch) REFERENCES Branch(b_name)
);

CREATE TABLE Course(
	c_code VARCHAR (10) NOT NULL, 
	c_name VARCHAR (20) NOT NULL, 
	credits INT NOT NULL, 
	department VARCHAR (20) NOT NULL REFERENCES Department(d_name),
	PRIMARY KEY (c_code)
);

CREATE TABLE Prerequisite(
	course VARCHAR(20) NOT NULL REFERENCES Course(c_code),
	prerequisite VARCHAR(20) NOT NULL REFERENCES Course(c_code)
);

CREATE TABLE Classification(
name VARCHAR (20) NOT NULL PRIMARY KEY
);

CREATE TABLE Classified(
	 course VARCHAR (20) NOT NULL REFERENCES Course(c_name),
	 classification VARCHAR (20) NOT NULL REFERENCES Classification(name) -- Not implemented and created in database
 );
    
 CREATE TABLE MandatoryProgram(
	 course VARCHAR (20)NOT NULL REFERENCES Course (c_code),
	 program VARCHAR (20)NOT NULL REFERENCES Program (p_name)
);
CREATE TABLE MandatoryBranch(
    course VARCHAR (20)NOT NULL REFERENCES Course (c_code),
    branch VARCHAR (20)NOT NULL,
    program VARCHAR (20)NOT NULL,
    FOREIGN KEY (branch, program) REFERENCES Branch(b_name, program)
);

    
