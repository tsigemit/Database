-- Registration process
CREATE OR REPLACE FUNCTION register() RETURNS TRIGGER AS $$
BEGIN

-- If the student has already passed this course before
IF (EXISTS (SELECT course FROM Taken WHERE course =  NEW.course AND student=NEW.student AND grade <> 'U'))
  THEN RAISE EXCEPTION 'Student has already passed this course';

-- If the student is already registered to the course
ELSEIF (EXISTS (SELECT course FROM Registered WHERE NEW.student =student AND course =  NEW.course))
  THEN RAISE EXCEPTION 'Student is already registered to this course';

-- If the student has not taken all prerequisite courses
ELSEIF(EXISTS (SELECT prerequisite from Prerequisite where course= NEW.course group by prerequisite having prerequisite NOT IN (SELECT course from PassedCourses where student=NEW.student)))
  THEN RAISE NOTICE 'Student has not taken all prerequisites for this course';

-- Otherwise, if the student meets all requirements
ELSE

  -- If the course is full, add student and course to waiting list
  IF (EXISTS (SELECT course FROM fullCourses WHERE course = NEW.course))
    THEN
  INSERT INTO WaitingList(student, course, position) VALUES(NEW.student, NEW.course, (SELECT COUNT(course)+1 FROM WaitingList WHERE course=NEW.course));
    RAISE INFO'This course is full, student has been added to waiting list';

  -- If the course is not full, register the student
  ELSE
    INSERT INTO Registered(student, course) VALUES(NEW.student, NEW.course);
    RAISE NOTICE 'Registration successful';

    -- If the student was waiting, remove them from the queue and update queue
  END IF;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER register
INSTEAD OF INSERT ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE register();

-- Unregistration process
CREATE OR REPLACE FUNCTION unregister() RETURNS TRIGGER AS $$
BEGIN
IF(EXISTS (SELECT course FROM OverFull WHERE course =OLD.course))
	THEN
	DELETE FROM Registered WHERE OLD.student =student AND course =  OLD.course;
    DELETE FROM WaitingList WHERE OLD.student =student AND course =  OLD.course;
END IF;
-- If the student is registered, delete them from registrations and add the first student from waitingList
IF (EXISTS (SELECT student FROM Registered WHERE student = OLD.student AND course=OLD.course))
  THEN 
  DELETE FROM Registered WHERE OLD.student = student AND course = OLD.course;
  INSERT INTO Registered(student, course) SELECT student, course from WaitingList WHERE OLD.course = course AND position=
 (SELECT MIN(position) from WaitingList WHERE course=OLD.course group by course);
  DELETE FROM WaitingList WHERE OLD.course = course AND position= (SELECT MIN(position) from WaitingList WHERE course=OLD.course group by course);
  UPDATE WaitingList SET position=position-1 WHERE course=OLD.course; 

-- If the student is in the waiting list instead, delete them from the queue
ELSIF (EXISTS (SELECT student FROM WaitingList WHERE student = OLD.student))
  THEN
  DELETE FROM WaitingList WHERE student = OLD.student AND course = OLD.course;
-- If the student is neither registered nor in the waiting list, do nothing
ELSE
  RETURN NULL;

END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;
  
CREATE TRIGGER unregister
INSTEAD OF DELETE ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE unregister();
