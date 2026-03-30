SELECT
    f.name,
    COUNT(c.id) AS completed_projects,
    RANK() OVER (ORDER BY COUNT(c.id) DESC) AS success_rank
FROM contracts c
JOIN proposals pr ON c.proposal_id = pr.id
JOIN freelancers f ON pr.freelancer_id = f.id
WHERE c.status = 'completed'
GROUP BY f.id, f.name;
