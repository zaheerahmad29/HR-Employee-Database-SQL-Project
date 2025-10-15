CREATE DATABASE PROJECT
USE PROJECT 

SELECT * FROM Attendance
SELECT * FROM Departments
SELECT * FROM Employees
SELECT * FROM Performance
SELECT * FROM Salaries

--HR / Employee Database project

--Q. 1 What is the total number of employees in the Employees table?

SELECT
	COUNT(*) AS 'Total Number Of Employees'
FROM
	Employees

--Q 2. List the names and IDs of all employees in the HR department.

SELECT
	Employees.EmployeeID,
	Employees.FirstName,
	Employees.LastName
FROM
	Employees 
JOIN Departments AS D ON Employees.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'HR'

-- Q 3. What is the highest salary in the Salaries table?

SELECT
	MAX(Salaries.Salary) AS 'Highest'
FROM
	Salaries

--Q4. Find the EmployeeID of all employees from the Performance table who have a performance score of 5.

SELECT
	*
FROM
	Performance
WHERE Performance.PerformanceScore = 5

--Q5. What is the total number of 'Absent' days recorded in the Attendance table?

SELECT 
	COUNT(Attendance.Status) AS 'Total Absent'
FROM Attendance
WHERE Attendance.Status = 'ABSENT'

--Q6 Show the names of all departments from the Departments table.

SELECT
	DepartmentName
FROM
	Departments

--Q7. Find the names of employees whose FirstName is 'John'.
SELECT
	*
FROM
	Employees
WHERE Employees.FirstName = 'JOHN'

--Q8. Count how many employees are in each department.

SELECT
	Departments.DepartmentName,
	COUNT(Employees.EmployeeID) AS 'Total Employees Department'
FROM
	Departments
JOIN Employees ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName

--Q9. What is the total sum of all salaries recorded in the Salaries table?

SELECT
	SUM(Salaries.Salary) AS 'Total_Salaries'
FROM
	Salaries

--Q10. Find the names and IDs of employees from the Employees table whose EmployeeID is greater than 'E0100'.

SELECT
	Employees.EmployeeID,
	Employees.FirstName
FROM	
	Employees
WHERE Employees.EmployeeID >= 'E0100'


--Q11. Calculate the average salary for each department.

SELECT
	Departments.DepartmentName,
	AVG(Salaries.Salary) AS 'Average_Salary'
FROM
	Departments
	JOIN Employees	ON	Employees.DepartmentID = Departments.DepartmentID
	JOIN Salaries	ON	Salaries.EmployeeID	=	Employees.EmployeeID
GROUP BY DepartmentName

--Q12. Show the names of employees and their department names (DepartmentName) whose salary is more than ₹1,00,000.

SELECT
	Employees.FirstName,
	Departments.DepartmentName,
	Salaries.Salary AS 'Employee_Salary'
FROM
	Departments
	JOIN Employees	ON	Employees.DepartmentID = Departments.DepartmentID
	JOIN Salaries	ON	Salaries.EmployeeID	=	Employees.EmployeeID
WHERE Salaries.Salary > 100000
ORDER BY Employee_Salary ASC

--Q13. Find the names and salaries of the top 5 highest-paid employees.

SELECT TOP 5
	Employees.FirstName,
	Salaries.Salary 
FROM
	Departments
	JOIN Employees	ON	Employees.DepartmentID = Departments.DepartmentID
	JOIN Salaries	ON	Salaries.EmployeeID	=	Employees.EmployeeID
ORDER BY Salary DESC

--Q14. List the departments that have more than 40 employees.

SELECT
	DepartmentName,
	COUNT(EmployeeID) AS 'Number_of_Employee'
FROM
	Departments
JOIN Employees	ON	Employees.DepartmentID	=	Departments.DepartmentID
GROUP BY DepartmentName
HAVING COUNT(EmployeeID) > 40
ORDER BY Number_of_Employee ASC

--Q15. Find the names of all employees and their performance scores who have a performance score less than 3.

SELECT
	Employees.FirstName,
	PerformanceScore
FROM
	Employees
JOIN Performance	ON	Performance.EmployeeID	=	Employees.EmployeeID
WHERE PerformanceScore < 3

--Q16. Using the Attendance table, find the EmployeeID and names of employees who were 'Absent' more than 10 times.

SELECT
	Employees.EmployeeID,
	Employees.FirstName,
	Attendance.Status,
	COUNT(Employees.EmployeeID) AS 'Absent_Count'
FROM
	Attendance
JOIN Employees	ON	Employees.EmployeeID	=	Attendance.EmployeeID
WHERE Attendance.Status = 'Absent'
GROUP BY Employees.EmployeeID,FirstName,Status
HAVING COUNT(Employees.EmployeeID) > 10

--Q17. Show the names of employees and the date of their most recent performance review.

SELECT
	Employees.FirstName,
	Employees.LastName,
	MAX(Performance.ReviewDate) AS 'Recent_Date'
FROM
	Employees
JOIN Performance	ON	Performance.EmployeeID	=	Employees.EmployeeID
GROUP BY Employees.FirstName,Employees.LastName

--Q18. Find the names of employees who have the lowest salary.

SELECT 
	Employees.FirstName,
	Employees.LastName,
	Salaries.Salary
FROM
	Employees
JOIN	Salaries	ON	Salaries.EmployeeID	=	Employees.EmployeeID
WHERE Salaries.Salary = (SELECT MIN(Salaries.Salary) FROM Salaries)

--Q19. What is the average salary of employees in the Marketing department?

SELECT
	Departments.DepartmentName,
	AVG(Salaries.Salary) AS 'Average_Salary'
FROM
	Employees
JOIN	Salaries	ON	Salaries.EmployeeID	=	Employees.EmployeeID
JOIN	Departments	ON	Departments.DepartmentID	=	Employees.DepartmentID
WHERE Departments.DepartmentName	=	'Marketing' 
GROUP BY DepartmentName

--Q20. Find the names of all employees and their department names whose performance score is 4 or more.

SELECT
	Employees.FirstName,
	Employees.LastName,
	Departments.DepartmentName,
	Performance.PerformanceScore
FROM
	Employees
JOIN	Departments		ON	Departments.DepartmentID	=	Employees.DepartmentID
JOIN	Performance		ON	Performance.EmployeeID		=	Employees.EmployeeID
WHERE Performance.PerformanceScore >= 4

--Q21. Find the name and salary of the highest-paid employee in each department.

WITH Highest AS
(SELECT
	Departments.DepartmentName,
	Employees.FirstName,
	Employees.LastName,
	Salaries.Salary,
	RANK() OVER(PARTITION BY DepartmentName ORDER BY Salary DESC) AS 'Highest_Paid'
FROM
	Employees
JOIN	Salaries	ON	Salaries.EmployeeID	=	Employees.EmployeeID
JOIN	Departments	ON	Departments.DepartmentID	=	Employees.DepartmentID
)
	SELECT * FROM Highest
	WHERE Highest.Highest_Paid	=	1

--Q22. Show the names and salaries of employees whose salary is greater than the average salary of their respective department.

SELECT
    d.DepartmentName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    s.Salary
FROM Employees e
JOIN Departments d 
    ON d.DepartmentID = e.DepartmentID
JOIN Salaries s 
    ON s.EmployeeID = e.EmployeeID
WHERE s.Salary > (
    SELECT AVG(s2.Salary)
    FROM Employees e2
    JOIN Salaries s2 ON s2.EmployeeID = e2.EmployeeID
    WHERE e2.DepartmentID = e.DepartmentID
)
ORDER BY d.DepartmentName, s.Salary ASC

--Q23. List the top 3 departments with the highest average performance score.

SELECT	TOP 3
	Departments.DepartmentName,
	AVG(Performance.PerformanceScore) AS 'Average'
FROM
	Departments
JOIN	Employees	ON		Employees.DepartmentID		=	Departments.DepartmentID
JOIN	Performance	ON		Performance.EmployeeID		=	Employees.EmployeeID
GROUP BY DepartmentName
ORDER BY Average DESC

--Q24. What is the difference between the highest and lowest salary in the Operations department?

SELECT
	Departments.DepartmentName,
	MAX(Salaries.Salary) AS 'Highest_Salary',
	MIN(Salaries.Salary) AS 'Lowest_Salary',
	(MAX(Salaries.Salary) - MIN(Salaries.Salary) ) AS 'Difference_Salary'
FROM
	Employees
JOIN	Departments	ON	Departments.DepartmentID	=	Employees.DepartmentID
JOIN	Salaries	ON	Salaries.EmployeeID			=	Employees.EmployeeID
WHERE Departments.DepartmentName	=	'Operations'
GROUP BY DepartmentName

--Q25. Calculate the percentage of 'Present' days for each employee over the last 6 months.

SELECT
	Employees.FirstName+ ' ' + Employees.LastName as 'EmployeeName',
	COUNT(CASE WHEN Attendance.Status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS 'Present_Percentage'
FROM
	Employees
JOIN	Attendance	ON	Attendance.EmployeeID	=	Employees.EmployeeID
WHERE Attendance.AttendanceDate >= DATEADD(MONTH,-6,GETDATE())
GROUP BY FirstName,LastName
ORDER BY Present_Percentage DESC	