USE db_University_basic;
SELECT * FROM classroom;
SELECT * FROM course;
SELECT * FROM department;
SELECT * FROM instructor;
SELECT * FROM section;
SELECT * FROM student;
SELECT * FROM takes;
SELECT * FROM teaches;


###1. Can you please list all the courses that belong to the Comp. Sci. department and have 3 credits?
# 3 rows return
SELECT * FROM course WHERE dept_name = 'Comp. Sci.' AND credits = 3;

###2. Can you please list all the students who were instructed by Einstein; make sure there are not duplicities?
# Peltier is the only student who is instructed by Einstein. Assuming student who take PHY-101 which is instructed by Einstein.

DROP TABLE IF EXISTS tbl_1;
DROP TABLE IF EXISTS tbl_2;

CREATE TEMPORARY TABLE tbl_1
	SELECT * FROM
	(SELECT * FROM instructor WHERE name = 'Einstein') AS A
	NATURAL JOIN
	(SELECT * FROM teaches)  AS B;

CREATE TEMPORARY TABLE tbl_2
	SELECT * FROM 
	(SELECT * FROM takes) AS C
	NATURAL JOIN
	(SELECT * FROM student) AS D;
SELECT * FROM tbl_2 WHERE course_id = 'PHY-101';




###3. Can you please list the names of the all the faculty getting the highest salary within the whole university? (Retrieve aside of their names, their departments names and buildings)
# Einstein has the highest salary.
SELECT name, salary FROM instructor
ORDER BY salary DESC;

###4. Can you please list the names of all the instructors along with the titles of the courses that they teach?
# 13 rows return
SELECT DISTINCT C.title, A.name FROM
(SELECT * FROM instructor) AS A
NATURAL LEFT JOIN
(SELECT * FROM teaches)  AS B
NATURAL LEFT JOIN
(SELECT * FROM course) AS C;
    
###5. Can you please list the names of instructors with salary amounts between $90K and $100K?
# 3 rows return
SELECT name FROM instructor WHERE salary Between 90000 AND 100000;

###6. Can you please list what courses were taught in the fall of 2009?
# 3 rows return
SELECT A.title, B.SEMESTER FROM
	(SELECT * FROM course) AS A
    NATURAL JOIN 
    (SELECT * FROM teaches WHERE semester = 'Fall') AS B;
    
###7. Can you please list all the courses taught in the spring of 2010?
# 7 rows return
SELECT A.title, B.SEMESTER, B.year FROM
	(SELECT * FROM course) AS A
    NATURAL JOIN 
    (SELECT * FROM teaches WHERE semester = 'Spring' AND year = '2010') AS B;
    
###8. Can you please list all the courses taught in the fall of 2009 or in the spring of 2010.
# 10 rows return
SELECT A.title, B.SEMESTER, B.year FROM
	(SELECT * FROM course) AS A
    NATURAL JOIN 
    (SELECT * FROM teaches WHERE semester = 'Spring' AND year = '2010' OR semester = 'Fall' AND year = '2009') AS B;
    
###9. List the all the courses taught in the fall of 2009 and in the spring of 2010.
# 1 row return
SELECT A.course_id, A.semester, A.year, B.semester, B.year FROM
(SELECT * FROM teaches WHERE semester = 'Spring' AND year = '2010') AS A
INNER JOIN
(SELECT * FROM teaches WHERE semester = 'Fall' AND year = '2009') AS B
ON A.course_id = B.course_id;

    
###10. List all the faculty along with their salary and department of the faculty who tough a course in 2009
# 5 rows return
SELECT DISTINCT A.name, A.salary, A.dept_name, B.year FROM 
	(SELECT * FROM instructor) AS A 
	NATURAL JOIN
	(SELECT * FROM teaches WHERE year = '2009') AS B;
    
###11. Find the average salary of instructors in the Computer Science department.
# Average salary is 77333.333333
SELECT AVG(salary) AS avg_salary_comp_dept FROM instructor WHERE dept_name = 'Comp. Sci.';

###12. For each department, please find the maximum enrollment, across all sections, in autumn 2009
# return 2 rows
SELECT MAX(enrollment), D.dept_name FROM 
(SELECT COUNT(*) AS enrollment, B.dept_name, B.course_id FROM
takes as A NATURAL JOIN course as B NATURAL JOIN section AS C
WHERE A.year = '2009' AND A.semester_id = 'Fall'
GROUP BY B.dept_name, B.course_id) AS D
GROUP BY D.dept_name;

###13. Get a table displaying a list of all the students with their ID, the name, 
### the name of the department and the total number of credits along with the courses they have already taken?
# 22 rows return
SELECT A.ID, A.name, A.dept_name, A.tot_cred, B.course_id FROM 
(SELECT * FROM student) AS A
NATURAL JOIN
(SELECT * FROM takes) AS B;

###14. Display a list of students in the Comp. Sci. department, along with the course sections, 
###that they have taken in the spring of 2009. Make sure all courses taught in the spring are displayed 
###even if no student from the Comp. Sci. department has taken it.
# 3 rows return

SELECT * 
FROM section AS A NATURAL LEFT JOIN takes AS B LEFT JOIN ( SELECT ID, name FROM student WHERE dept_name = 'Comp. Sci.') AS C
ON B.ID = C.ID
WHERE  A.semester = 'Spring' AND A.year = '2009';


