SELECT s.ID, s.name, t.course_id, t.grade
FROM student s, takes t
WHERE s.ID=t.ID 
ORDER BY s.name, s.ID, t.course_id;
