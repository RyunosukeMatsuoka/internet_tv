SELECT
  dm.dept_no,
  d.dept_name,
  e.emp_no,
  e.first_name,
  e.last_name,
FROM
  departments AS d
  INNER JOIN dept_manager AS dm
    ON d.dept_no = dm.dept_no
  INNER JOIN employees AS e
    ON dm.emp_no = e.emp_no
WHERE dm.to_date = '9999-01-01'
\G
