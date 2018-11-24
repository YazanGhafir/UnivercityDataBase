DROP OWNED BY yazan CASCADE;

CREATE TABLE Students (
    idnr NUMERIC (10),
    sname TEXT NOT NULL,
    login TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (idnr)
);

CREATE TABLE Branches (
    bname TEXT,
    program TEXT,
    PRIMARY KEY (bname, program)
);

CREATE TABLE Courses (
    ccode CHAR (6),
    cname TEXT NOT NULL,
    credits INTEGER NOT NULL,
    CHECK (credits > 0 AND credits <= 100),
    department TEXT NOT NULL,
    PRIMARY KEY (ccode)
);

CREATE TABLE LimitedCourses (
    lccode CHAR (6),
    seats INTEGER NOT NULL,
    CHECK (seats > 0 AND seats <= 500),
    PRIMARY KEY (lccode),
    FOREIGN KEY (lccode) REFERENCES courses(ccode)
);

CREATE TABLE Classifications (
    cname TEXT,
    PRIMARY KEY (cname)
);

CREATE TABLE StudentBranches (
    student NUMERIC (10),
    branch TEXT,
    program TEXT,
    PRIMARY KEY (student, branch, program),
    FOREIGN KEY (student) REFERENCES students(idnr),
    FOREIGN KEY (branch,program) REFERENCES Branches(bname,program)
);

CREATE TABLE Classified (
    course CHAR (6),
    classification TEXT,
    PRIMARY KEY (course, classification),
    FOREIGN KEY (course) REFERENCES courses(ccode),
    FOREIGN KEY (classification) REFERENCES Classifications(cname)
);

CREATE TABLE MandatoryProgram (
    course CHAR (6),
    program TEXT,
    PRIMARY KEY (course, program),
    FOREIGN KEY (course) REFERENCES courses(ccode)
);

CREATE TABLE MandatoryBranch (
    course CHAR (6),
    branch TEXT,
    program TEXT,
    PRIMARY KEY (course, branch, program),
    FOREIGN KEY (course) REFERENCES courses(ccode),
    FOREIGN KEY (branch, program) REFERENCES Branches(bname, program)
);

CREATE TABLE RecommendedBranch (
    course CHAR (6),
    branch TEXT,
    program TEXT,
    PRIMARY KEY (course, branch, program),
    FOREIGN KEY (course) REFERENCES courses(ccode),
    FOREIGN KEY (branch, program) REFERENCES Branches(bname, program)
);

CREATE TABLE Registered (
    student NUMERIC (10),
    course CHAR (6),
    PRIMARY KEY (student, course),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES courses(ccode)
);

CREATE TABLE Taken (
    student NUMERIC (10),
    course CHAR (6),
    grade TEXT,
    CHECK (grade = 'U' OR grade = '3' OR grade = '4' OR grade = '5'),
    PRIMARY KEY (student, course),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES courses(ccode)
);


CREATE TABLE WaitingList (
    student NUMERIC (10),
    course CHAR (6),
    position SERIAL,
    PRIMARY KEY (student, course),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(lccode)
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

INSERT INTO StudentBranches VALUES (2222222222,'B1','Prog1');
INSERT INTO StudentBranches VALUES (3333333333,'B1','Prog2');
INSERT INTO StudentBranches VALUES (4444444444,'B1','Prog1');
INSERT INTO StudentBranches VALUES (5555555555,'B1','prog3');

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


SELECT * FROM Students;
SELECT * FROM Branches;
SELECT * FROM courses;
SELECT * FROM LimitedCourses;
SELECT * FROM Classifications;
SELECT * FROM StudentBranches;
SELECT * FROM Classified;
SELECT * FROM MandatoryProgram;
SELECT * FROM MandatoryBranch;
SELECT * FROM RecommendedBranch;
SELECT * FROM Registered;
SELECT * FROM Taken;
SELECT * FROM WaitingList;