WITH no_proposals AS (
    SELECT id, title, budget
    FROM projects
    WHERE id NOT IN (SELECT project_id FROM proposals)
      AND deadline BETWEEN '2024-01-01' AND '2024-12-31'
)
SELECT * FROM no_proposals;
