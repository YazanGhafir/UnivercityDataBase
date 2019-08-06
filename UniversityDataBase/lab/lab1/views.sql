	CREATE VIEW BasicInformation AS 
	SELECT idnr, name, login, Students.program, branch
	FROM Students LEFT OUTER JOIN StudentBranches
	ON (idnr = student);
	
	CREATE VIEW FinishedCourses AS
	SELECT  student, course, grade, credits
	FROM  Courses, Taken
	WHERE code = course;
	
	CREATE VIEW PassedCourses AS
	SELECT  student, course, credits
	FROM  FinishedCourses
	WHERE grade != 'U';
	
	CREATE VIEW Registrations AS
	(SELECT  student, course, 'registered' AS status
	FROM  Registered)
	UNION
	(SELECT student, course, 'waiting'
	FROM WaitingList);
	
	CREATE VIEW UnreadMandatory AS
	SELECT student, course 
	FROM 
	((SELECT idnr AS student, course FROM Students JOIN MandatoryProgram USING (program))
	UNION 
	(SELECT student, course FROM StudentBranches JOIN MandatoryBranch USING (program)))
	AS MandatoryCourses
	WHERE NOT EXISTS 
	(SELECT * FROM PassedCourses WHERE student = MandatoryCourses.student);
	
	
	CREATE VIEW E AS
	SELECT student, SUM(credits) AS credits
	FROM RecommendedBranch NATURAL JOIN (SELECT * FROM PassedCourses, BasicInformation WHERE student = idnr) AS Info
	GROUP BY student;
	
	-- The last view. We created two helper tables, the first one  has the first six columns combined with LEFT OUTER JOIN and an extra column with
	-- credits of the recommended courses, the second helper table checks if any student is qualified for graduation.
	
	CREATE VIEW PathToGraduation AS
	WITH
	Statistics AS (SELECT student, COALESCE(totalcredits, 0) AS totalcredits, COALESCE(mandatoryleft, 0) AS mandatoryleft, COALESCE(mathCredits, 0) AS mathCredits,
	COALESCE(researchcredits, 0) AS researchcredits, COALESCE(seminarcourses, 0) AS seminarcourses, COALESCE(recommendedCredits, 0) AS recommendedCredits
	FROM 
	(SELECT idnr AS student FROM BasicInformation) AS Students NATURAL LEFT OUTER JOIN 
	(SELECT student, SUM(credits) AS totalcredits FROM PassedCourses GROUP BY student) AS TotalC NATURAL LEFT OUTER JOIN 
	(SELECT student, COUNT(*) AS mandatoryleft FROM UnreadMandatory GROUP BY student) AS MandatoryL NATURAL LEFT OUTER JOIN 
	(SELECT student, SUM(credits) AS mathCredits FROM PassedCourses, Classified WHERE classification = 'math' AND PassedCourses.course = Classified.course GROUP BY student) AS MathC NATURAL LEFT OUTER JOIN 
	(SELECT student, SUM(credits) AS researchcredits FROM PassedCourses, Classified WHERE classification = 'research' AND PassedCourses.course = Classified.course GROUP BY student) AS ResearchC NATURAL LEFT OUTER JOIN 
	(SELECT student, COUNT(*) AS seminarcourses   FROM PassedCourses, Classified WHERE classification = 'seminar' AND PassedCourses.course = Classified.course GROUP BY student) AS SeminarC NATURAL LEFT OUTER JOIN
	(SELECT student, SUM(credits) AS recommendedCredits FROM RecommendedBranch NATURAL JOIN (SELECT * FROM PassedCourses, BasicInformation WHERE student = idnr) AS Info GROUP BY student) AS RecommendedCCredits),
	
	QualifiedStudents AS (SELECT student, TRUE AS qualified FROM Statistics WHERE mandatoryleft =0 AND mathCredits >=20 
	AND researchcredits >=10 AND seminarcourses >=1 AND recommendedCredits >= 10)

	SELECT student, totalcredits, mandatoryleft,mathCredits, researchcredits ,seminarcourses, COALESCE(qualified, FALSE) AS qualified 
	FROM Statistics NATURAL LEFT OUTER JOIN QualifiedStudents;
	
	
	