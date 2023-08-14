-- These queries have been added in Heroku as Dataclips.

-- questions and answers
SELECT panels.name AS panel, demo_questions.body AS question, demo_options.label AS answer, count(*) AS usage_count
FROM demo_query_options
LEFT JOIN demo_options ON demo_query_options.demo_option_id = demo_options.id
LEFT JOIN demo_questions ON demo_options.demo_question_id = demo_questions.id
LEFT JOIN demo_queries ON demo_query_options.demo_query_id = demo_queries.id
LEFT JOIN panels on demo_queries.panel_id = panels.id
WHERE demo_queries.created_at > CURRENT_DATE - INTERVAL '1 year'
GROUP BY panels.name, demo_options.id, demo_options.label, demo_questions.body
ORDER BY usage_count DESC;

-- questions only
SELECT panels.name AS panel, demo_questions.body AS question, count(*) AS usage_count
FROM demo_query_options
LEFT JOIN demo_options ON demo_query_options.demo_option_id = demo_options.id
LEFT JOIN demo_questions ON demo_options.demo_question_id = demo_questions.id
LEFT JOIN demo_queries ON demo_query_options.demo_query_id = demo_queries.id
LEFT JOIN panels on demo_queries.panel_id = panels.id
WHERE demo_queries.created_at > CURRENT_DATE - INTERVAL '1 year'
GROUP BY panels.name, demo_questions.id, demo_questions.body
ORDER BY usage_count DESC;
