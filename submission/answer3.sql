With X AS(
	SELECT dept_name, count(ID) as cnt
	FROM instructor
	GROUP BY dept_name), 
Y AS (
	SELECT c.dept_name, sum(credits) AS tot_credits
	FROM course c, section s
	WHERE c.course_id=s.course_id
	GROUP BY c.dept_name)
SELECT X.dept_name, CAST(Y.tot_credits AS real)/X.cnt AS ratio
FROM X, Y
WHERE X.dept_name=Y.dept_name
ORDER BY ratio DESC, X.dept_name ASC;
