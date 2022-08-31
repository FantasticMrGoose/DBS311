

SET SERVEROUTPUT ON;

-- Question 1

CREATE OR REPLACE PROCEDURE spIsEven (
    n IN NUMERIC
    ) AS
BEGIN
    IF MOD(n,2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number is even.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number is odd.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Data not found.');
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: To many rows returned!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END spIsEven;

-- Testing
BEGIN
    spIsEven(22);
END;

BEGIN
    spIsEven(11);
END;

--Question 2
CREATE OR REPLACE PROCEDURE find_employee (
    emp_num IN NUMBER
    ) AS
    fname employees.first_name%TYPE;
    lname employees.last_name%TYPE;
    email employees.email%TYPE;
    phone employees.phone_number%TYPE;
    hire_date employees.hire_date%TYPE;
    job_title employees.job_id%TYPE;
BEGIN
    SELECT first_name, last_name, email, phone_number, hire_date, job_id 
        INTO fName, lName, email, phone, hire_date, job_title
    FROM employees
    WHERE employee_id = emp_num;
    
    DBMS_OUTPUT.PUT_LINE('First name: ' || fname);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || lName);
    DBMS_OUTPUT.PUT_LINE('Email: ' || email);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || phone);
    DBMS_OUTPUT.PUT_LINE('Hire date: ' || to_char(hire_date, 'DD-MON-YY'));
    DBMS_OUTPUT.PUT_LINE('Job title: ' || job_title);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: To many rows returned!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END find_employee;        
        
-- Testing
BEGIN
    find_employee(107);
END;

-- Question 3
CREATE OR REPLACE PROCEDURE update_salary_by_dept (
    deptID IN employees.department_id%TYPE,
    pct_raise IN FLOAT
    ) AS
    numDepts INT;
BEGIN
    SELECT count (department_id)
        INTO numDepts
    FROM employees
    WHERE department_id = deptID;
    
    IF (numDepts > 0 AND pct_raise > 0) THEN
        UPDATE employees 
            SET salary = salary * (1 +pct_raise)
        WHERE department_id = deptID
            AND salary > 0;
        DBMS_OUTPUT.PUT_LINE('Rows Updated: ' || SQL%ROWCOUNT);
    ELSIF pct_raise <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Please enter a valid raise amount.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Department not found.');
    END IF;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: To many rows returned!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END update_salary_by_dept; 

DECLARE
    deptID employees.department_id%TYPE := 50;
    pct_raise FLOAT := 0.02;
BEGIN
    update_salary_by_dept(deptID, pct_raise);
END;

-- Question 4
CREATE OR REPLACE PROCEDURE spUpdateSalary_UnderAvg AS
    avgSalary employees.salary%TYPE;
BEGIN
    SELECT AVG(salary)
        INTO avgSalary
    FROM employees;
    
    IF avgSalary <= 9000 THEN 
        UPDATE employees
            SET salary = salary * 1.02;
        DBMS_OUTPUT.PUT_LINE('Rows Updated: ' || SQL%ROWCOUNT);
    ELSIF avgSalary > 9000 THEN
        UPDATE employees
            SET salary = salary * 1.01
        WHERE employees.salary < avgSalary;
        DBMS_OUTPUT.PUT_LINE('Rows Updated: ' || SQL%ROWCOUNT);
    END IF;    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: To many rows returned!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END spUpdateSalary_UnderAvg;

-- Testing
BEGIN
    spUpdateSalary_UnderAvg();
END;

-- Question 5
CREATE OR REPLACE PROCEDURE spSalaryReport AS
    sal_low INT :=0;
    sal_fair INT :=0;
    sal_high INT :=0;
    minSal employees.salary%TYPE;
    avgSal employees.salary%TYPE;
    maxSal employees.salary%TYPE;
BEGIN
    SELECT MIN(salary), AVG(salary), MAX(salary) 
        INTO minSal, avgSal, maxSal
    FROM employees;
        
    FOR t_emp IN (
        SELECT salary FROM employees 
    )
    LOOP
        IF t_emp.salary < ((avgSal - minSal)/2) THEN
            sal_low := sal_low + 1;
        ELSIF t_emp.salary > ((maxSal - avgSal)/2) THEN
            sal_high := sal_high + 1;
        ELSE
            sal_fair := sal_fair + 1;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Low: ' || sal_low);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || sal_fair);
    DBMS_OUTPUT.PUT_LINE('High: ' || sal_high);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: To many rows returned!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END spSalaryReport;

BEGIN
    spSalaryReport();
END;




CREATE OR REPLACE PROCEDURE spGoalScorersReport
AS
CURSOR c IS
SELECT * FROM GoalScorers;
v_PLAYERID GOALSCORERS.PLAYERID%type;
v_NUMGOALS GOALSCORERS.NUMGOALS%type default null ;
v_TEAMID GOALSCORERS.TEAMID%type;
v_NUMASSISTS GOALSCORERS.NUMASSISTS%type default null ;
v_GAMEID GOALSCORERS.GAMEID%type;
v_GOALID GOALSCORERS.GOALID%type;
BEGIN

FOR temp IN c
LOOP
DBMS_OUTPUT.PUT_LINE(RPAD(temp.goalID, 6, ' ') || ' ' || RPAD(temp.gameID, 6, ' ')
|| ' ' || RPAD(v_PLAYERID, 8, ' ') || RPAD(v_TEAMID, 6, ' ')
|| ' ' || RPAD(v_NUMGOALS, 8, ' ')|| ' ' || RPAD(v_NUMASSISTS, 10, ' ')
);
END LOOP;

OPEN c;
DBMS_OUTPUT.PUT_LINE(RPAD('GoalID', 6, ' ') || ' ' || RPAD('GameID', 6, ' ')
|| ' ' || RPAD('PlayerID', 8, ' ') || ' ' || RPAD('TeamID', 6, ' ')
|| ' ' || RPAD('NumGoals', 8, ' ')|| ' ' || RPAD('NumAssists', 10, ' ')
);
LOOP
FETCH c INTO v_GOALID, v_GAMEID, v_PLAYERID, v_TEAMID, v_NUMGOALS,
v_NUMASSISTS;
EXIT WHEN c%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(RPAD(v_GOALID, 6, ' ') || ' ' || RPAD(v_GAMEID, 6, ' ')
|| ' ' || RPAD(v_PLAYERID, 8, ' ') || RPAD(v_TEAMID, 6, ' ')
|| ' ' || RPAD(v_NUMGOALS, 8, ' ')|| ' ' || RPAD(v_NUMASSISTS, 10, ' ')
);
END LOOP;
CLOSE c;
END spGamesReport;