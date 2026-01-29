SELECT 'regions'      AS table_name, COUNT(*) AS row_count FROM regions
UNION ALL
SELECT 'countries'    AS table_name, COUNT(*) AS row_count FROM countries
UNION ALL
SELECT 'locations'    AS table_name, COUNT(*) AS row_count FROM locations
UNION ALL
SELECT 'departments'  AS table_name, COUNT(*) AS row_count FROM departments
UNION ALL
SELECT 'jobs'         AS table_name, COUNT(*) AS row_count FROM jobs
UNION ALL
SELECT 'employees'    AS table_name, COUNT(*) AS row_count FROM employees
UNION ALL
SELECT 'job_history'  AS table_name, COUNT(*) AS row_count FROM job_history;
