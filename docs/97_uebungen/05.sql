-- 1. Die "Hire" Prozedur
DELIMITER //
CREATE PROCEDURE hire_employee(
    IN p_first_name VARCHAR(14),
    IN p_last_name VARCHAR(16),
    IN p_gender ENUM('M','F'),
    IN p_birth_date DATE,
    IN p_dept_name VARCHAR(40),
    IN p_title VARCHAR(50),
    IN p_salary INT
)
BEGIN
    DECLARE v_emp_no INT;
    DECLARE v_dept_no CHAR(4);
    
    START TRANSACTION;
    
    -- 1. Neue ID
    SELECT MAX(emp_no) + 1 INTO v_emp_no FROM employees;
    
    -- 2. Insert Employee
    INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
    VALUES (v_emp_no, p_birth_date, p_first_name, p_last_name, p_gender, CURDATE());
    
    -- 3. Dept Lookup & Insert
    SELECT dept_no INTO v_dept_no FROM departments WHERE dept_name = p_dept_name;
    INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
    VALUES (v_emp_no, v_dept_no, CURDATE(), '9999-01-01');
    
    -- 4. Title Insert
    INSERT INTO titles (emp_no, title, from_date, to_date)
    VALUES (v_emp_no, p_title, CURDATE(), '9999-01-01');
    
    -- 5. Salary Insert
    INSERT INTO salaries (emp_no, salary, from_date, to_date)
    VALUES (v_emp_no, p_salary, CURDATE(), '9999-01-01');
    
    COMMIT;
END //
DELIMITER ;

-- 2. Salary Protection Trigger
DELIMITER //
CREATE TRIGGER before_salaries_update
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Gehaltskürzungen sind nicht erlaubt!';
    END IF;
END //
DELIMITER ;

-- 3. Audit Event
SET GLOBAL event_scheduler = ON;

CREATE EVENT purge_audit_log
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
    DELETE FROM audit_log WHERE created_at < NOW() - INTERVAL 1 YEAR;

-- 4. Cursor Loop (Bonus Calculation)
CREATE TABLE IF NOT EXISTS bonuses (emp_no INT, bonus_amount DECIMAL(10,2));

DELIMITER //
CREATE PROCEDURE calculate_bonuses()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_no INT;
    DECLARE v_hire_date DATE;
    DECLARE cur1 CURSOR FOR SELECT emp_no, hire_date FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur1;
    
    read_loop: LOOP
        FETCH cur1 INTO v_emp_no, v_hire_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Logik: Mehr als 10 Jahre dabei?
        IF DATEDIFF(NOW(), v_hire_date) > 3650 THEN
            INSERT INTO bonuses VALUES (v_emp_no, 1000.00);
        END IF;
    END LOOP;
    
    CLOSE cur1;
END //
DELIMITER ;

-- BONUS 1: OUT Parameter
DELIMITER //
CREATE PROCEDURE get_dept_stats(
    IN p_dept_no CHAR(4),
    OUT p_min_sal INT,
    OUT p_max_sal INT,
    OUT p_avg_sal DECIMAL(10,2)
)
BEGIN
    SELECT MIN(salary), MAX(salary), AVG(salary)
    INTO p_min_sal, p_max_sal, p_avg_sal
    FROM salaries s
    JOIN dept_emp de ON s.emp_no = de.emp_no
    WHERE de.dept_no = p_dept_no AND s.to_date > NOW();
END //
DELIMITER ;

-- BONUS 2: Security Context
CREATE PROCEDURE secure_proc()
SQL SECURITY DEFINER
BEGIN
    -- Kann auf Tabellen zugreifen, auf die der Aufrufer keine Rechte hat
    SELECT * FROM sensitive_data;
END;

-- BONUS 3: Show Create
SHOW CREATE PROCEDURE hire_employee;

-- BONUS 4: Error Handling (Resignal)
-- DECLARE EXIT HANDLER FOR SQLEXCEPTION ... RESIGNAL;

-- BONUS 5: Dynamic SQL
DELIMITER //
CREATE PROCEDURE count_rows(IN p_table_name VARCHAR(64), OUT p_count INT)
BEGIN
    SET @sql = CONCAT('SELECT COUNT(*) INTO @cnt FROM ', p_table_name);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET p_count = @cnt;
END //
DELIMITER ;

-- BONUS 6: Deterministic
-- CREATE FUNCTION ... DETERMINISTIC ...

-- BONUS 7: Trigger Cascade
-- Trigger A updates Table B -> Trigger B fires. (Standardverhalten in MySQL).

-- BONUS 8: Event Scheduling (One Time)
CREATE EVENT one_time_job
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 5 MINUTE
ON COMPLETION NOT PRESERVE
DO UPDATE my_table SET status = 'processed';

-- BONUS 9: Proc calling Proc
-- Einfach `CALL sub_proc();` innerhalb des BEGIN/END Blocks.

-- BONUS 10: User Variables
SET @my_var = 100;
-- In Prozedur: SET @my_var = @my_var + 1;
