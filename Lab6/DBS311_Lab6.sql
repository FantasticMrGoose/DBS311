
SET SERVEROUTPUT ON;

-- Question 1
CREATE OR REPLACE FUNCTION fncCalcFactorial(num1 INT) RETURN INT IS
       retFact INT := 1;
       calcFact INT := num1;
BEGIN
    FOR calcFact IN REVERSE 1..num1 LOOP
        retFact := retFact * calcFact;
    END LOOP;
    
    RETURN retFact;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('An arithmetic error occured');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');
END fncCalcFactorial;

-- Testing
BEGIN
    DBMS_OUTPUT.PUT_LINE( fncCalcFactorial(0));
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE( fncCalcFactorial(5));
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE( fncCalcFactorial(-1));
END;

-- Question 2
CREATE OR REPLACE PROCEDURE spCalcCurrentSalary (
    empID NUMBER,
    return_emp OUT employees%rowtype,
    vacationWks OUT INT,
    isFound OUT BOOLEAN
    ) AS 
    CURSOR empData IS
        SELECT * FROM employees WHERE employee_id = empID;
    yrsWorked INT := 0;
BEGIN
    OPEN empData;
    FETCH empData INTO return_emp;
    IF empData%NOTFOUND THEN
        isFound := false;
    ELSE
        isFound := true;
        yrsWorked := TRUNC(months_between(sysdate, return_emp.hire_date)/12,0);
        return_emp.salary := return_emp.salary * 12;
        
        IF yrsWorked > 3 THEN
            vacationWks := yrsWorked - 1;
            IF vacationWks > 6 THEN
                vacationWks := 6;
            END IF;
        ELSE
            vacationWks := 2;
        END IF;
        
        FOR i IN 1..yrsWorked LOOP
            return_emp.salary := return_emp.salary * 1.04;
        END LOOP;
    END IF;
    CLOSE empData;
EXCEPTION
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Cursor does not exist yet!');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('An arithmetic error occured');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END spCalcCurrentSalary;


-- Testing
DECLARE
    empData employees%rowtype;
    vacationWks INT;
    isFound BOOLEAN;
BEGIN
    FOR i IN 99..101 LOOP
    spCalcCurrentSalary(i, empData, vacationWks, isFound);
    DBMS_OUTPUT.PUT_LINE('------------------');
    IF isFound THEN
        DBMS_OUTPUT.PUT_LINE(RPAD('First Name:', 16, ' ' ) || empData.first_name);
        DBMS_OUTPUT.PUT_LINE(RPAD('Last Name:', 16, ' ' ) || empData.last_name);
        DBMS_OUTPUT.PUT_LINE(RPAD('Hire Date:', 16, ' ' ) || 
                to_char(empData.hire_date, 'fmMon". "DD", "YYYY'));
        DBMS_OUTPUT.PUT_LINE(RPAD('Salary:', 16, ' ' ) ||'$' || empData.salary);
        DBMS_OUTPUT.PUT_LINE(RPAD('Vacation Weeks:', 16, ' ' ) || vacationWks);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Employee Not Found');
    END IF;
    END LOOP;
END;

-- Question 3
CREATE OR REPLACE PROCEDURE spDepartmentsReport AS
    CURSOR deptInfo IS
        SELECT 
            nvl(d.department_id, 0) AS DeptID,
            nvl(d.department_name, 0) AS Department,
            nvl(city, 'N/A') AS City,
            count(employee_id) AS NumEmp
        FROM employees e FULL JOIN departments d ON e.department_id = d.department_id
            LEFT JOIN locations l ON d.location_id = l.location_id
        GROUP BY d.department_id, d.department_name, city
        ORDER BY d.department_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('DeptID   Department     City         NumEmp');
    FOR showDept IN deptInfo LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(showDept.DeptID, 6, ' ') || '   ' ||
        RPAD(showDept.Department, 15, ' ') || 
        RPAD(showDept.city, 10, ' ') || 
        LPAD(showDept.numEmp, 9, ' '));
    END LOOP;
EXCEPTION
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Cursor does not exist yet!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END spDepartmentsReport;

-- Testing
BEGIN
    spDepartmentsReport();
END;

-- Question 4 Part A
CREATE OR REPLACE FUNCTION spDetermineWinningTeam (game_id NUMBER) RETURN NUMBER
IS
    winnerID NUMBER := 0;
    gameInfo games%rowtype;
BEGIN
    SELECT * INTO gameInfo
    FROM games
    WHERE gameID = game_id;
    
    IF (gameInfo.isPlayed = 1) THEN
        IF gameInfo.homeScore > gameInfo.visitScore THEN
            winnerID := gameInfo.homeTeam;
        ELSIF gameInfo.homeScore < gameInfo.visitScore THEN
            winnerID := gameInfo.visitTeam;
        ELSE
            winnerID := 0;
        END IF;
    ELSE
        winnerID := -1;
    END IF;
    RETURN winnerID;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Returned more than one row!');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Could not get results!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Occured');
END spDetermineWinningTeam;

--Testing
DECLARE
    teamID NUMBER;
BEGIN
    teamID := spDetermineWinningTeam(39);
    DBMS_OUTPUT.PUT_LINE(teamID);
END;

-- Question 4 Part B
SELECT teamId, teamName, count(spDetermineWinningTeam(gameID)) AS Total_Wins 
FROM(
    SELECT teamID, 
        teamName,
        gameID,
        count(spDetermineWinningTeam(gameID)) AS Wins
    FROM games g JOIN teams t ON g.homeTeam = t.teamid
    WHERE spDetermineWinningTeam(gameID) = teamID
    GROUP BY teamID, teamName, gameID
    UNION
    SELECT teamID, 
        teamName, 
        gameID,
        count(spDetermineWinningTeam(gameID)) AS Wins
    FROM games g JOIN teams t ON g.visitTeam = t.teamid
    WHERE spDetermineWinningTeam(gameID) = teamID
    GROUP BY teamID, teamName, gameID
    ) s
GROUP BY teamId, teamName
ORDER BY teamID;
