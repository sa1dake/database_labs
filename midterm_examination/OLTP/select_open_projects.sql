SELECT p.*
FROM projects p
JOIN categories c ON p.category_id = c.id
WHERE p.status = 'open'
  AND c.name = 'Web Development';
