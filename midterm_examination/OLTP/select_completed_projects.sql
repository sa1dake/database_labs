SELECT p.title
FROM projects p
JOIN proposals pr ON p.id = pr.project_id
JOIN contracts c ON pr.id = c.proposal_id
WHERE pr.freelancer_id = 1
  AND c.status = 'completed';
