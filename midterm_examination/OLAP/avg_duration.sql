SELECT ROUND(AVG(end_date - start_date), 2) AS avg_days_duration
FROM contracts
WHERE status = 'completed';
