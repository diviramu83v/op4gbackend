-- this example is for one week vs the previous week
-- change the dates as needed

SELECT
  coalesce(previous_period.action, current_period.action) AS action,
  coalesce(previous_period.cnt, 0) AS old_count,
  coalesce(current_period.cnt, 0) AS new_count,
  coalesce(current_period.cnt, 0) - coalesce(previous_period.cnt, 0) AS diff
FROM (
  SELECT
    REGEXP_REPLACE(SUBSTRING(description, POSITION('Action:' IN description) + 8), '\s+$', '') AS action,
    count(*) AS cnt
  FROM
    system_events
  WHERE
    created_at >= '2021-01-18 00:00'
    AND created_at < '2021-01-25 00:00'
  GROUP BY
    REGEXP_REPLACE(SUBSTRING(description, POSITION('Action:' IN description) + 8), '\s+$', '')) AS previous_period
  FULL JOIN (
    SELECT
      REGEXP_REPLACE(SUBSTRING(description, POSITION('Action:' IN description) + 8), '\s+$', '') AS action,
      count(*) AS cnt
    FROM
      system_events
    WHERE
      created_at >= '2021-01-25 00:00'
      AND created_at < '2021-02-01 00:00'
    GROUP BY
      REGEXP_REPLACE(SUBSTRING(description, POSITION('Action:' IN description) + 8), '\s+$', '')) AS current_period ON previous_period.action = current_period.action
ORDER BY
  diff DESC;
