SELECT c.dept_name, sum(credits) AS tot_credits
FROM course c, section s
WHERE c.course_id=s.course_id
GROUP BY c.dept_name
HAVING sum(credits) > 5
ORDER BY tot_credits DESC;