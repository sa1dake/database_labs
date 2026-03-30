SELECT c.name, AVG(p.budget) AS avg_budget
FROM projects p
JOIN categories c ON p.category_id = c.id
GROUP BY c.name;
