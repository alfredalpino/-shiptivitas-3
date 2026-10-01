-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change
-- Kanban Board was released on 2018-06-02.
-- Daily active users = distinct users who logged in on a given day.

-- 1A. Daily active users over time (for the before/after DAU graph)
SELECT
  DATE(login_timestamp, 'unixepoch') AS day,
  COUNT(DISTINCT user_id) AS daily_active_users,
  CASE
    WHEN DATE(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'before'
    ELSE 'after'
  END AS period
FROM login_history
GROUP BY day
ORDER BY day;


-- 1B. Average daily active users before vs after the Kanban release
WITH daily_active_users AS (
  SELECT
    DATE(login_timestamp, 'unixepoch') AS day,
    COUNT(DISTINCT user_id) AS dau
  FROM login_history
  GROUP BY day
)
SELECT
  CASE
    WHEN day < '2018-06-02' THEN 'before'
    ELSE 'after'
  END AS period,
  COUNT(*) AS num_days,
  ROUND(AVG(dau), 2) AS avg_daily_active_users,
  MIN(dau) AS min_dau,
  MAX(dau) AS max_dau
FROM daily_active_users
GROUP BY period
ORDER BY period DESC;


-- PART 2: Create a SQL query that indicates the number of status changes by card

SELECT
  cch.cardID AS card_id,
  c.name AS card_name,
  c.status AS current_status,
  COUNT(*) AS status_change_count
FROM card_change_history AS cch
LEFT JOIN card AS c
  ON c.id = cch.cardID
WHERE COALESCE(cch.oldStatus, '') != COALESCE(cch.newStatus, '')
GROUP BY cch.cardID
ORDER BY status_change_count DESC, card_id ASC;
