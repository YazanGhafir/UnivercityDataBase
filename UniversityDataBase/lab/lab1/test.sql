DROP OWNED BY yazan CASCADE;

CREATE TABLE students (
    idNumber TEXT,
    name TEXT,
    cid CHAR(7),
    PRIMARY KEY (idNumber)
);

CREATE TABLE grades (
    student TEXT,
    cource CHAR (6),
    grade INT,
    PRIMARY KEY (student, cource),
    FOREIGN KEY (student) REFERENCES Students(idNumber),
    FOREIGN KEY (cource) REFERENCES cources(ccode)
);

CREATE TABLE cources (
    ccode CHAR (6),
    PRIMARY KEY (ccode)
);

INSERT INTO students VALUES ('19930124-xxxx', 'Yazan', 'ghafiro');
INSERT INTO students VALUES ('19930122-xxxx', 'Mohamad', 'mohamoh');
INSERT INTO students VALUES ('19930121-xxxx', 'Carl', 'carlosh');
INSERT INTO students VALUES ('19930125-xxxx', 'Erik', 'ericano');
INSERT INTO grades VALUES (3);

INSERT INTO cources VALUES ('TDA367');
UPDATE grades SET grade=3 WHERE student='Yazan';

SELECT * FROM students;
SELECT * FROM grades;
SELECT * FROM cources;

-- INSERT into grades VALUES ('Mohamad', 'TDA367', '5');
-- INSERT into grades VALUES ('Yazan', 'TDA367', '5');
-- INSERT into grades VALUES ('Yazan', 'TDA367', '5');