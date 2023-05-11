-- 직원 남녀 숫자 알고 싶음.
SELECT gender, COUNT(*)
FROM employees
GROUP BY gender;

-- 사번 , 이름, 성, 현재 부서 어디인지 알고 싶음., 퇴사자 제외
SELECT A.emp_no,CONCAT (A.last_name,' ',A.first_name) AS Full_Name, C.dept_no, C.dept_name
FROM employees A
JOIN dept_emp B
ON A.emp_no = B.emp_no
JOIN departments C
ON B.dept_no = C.dept_no
WHERE to_date = '9999-01-01'
ORDER BY emp_no ;

-- 