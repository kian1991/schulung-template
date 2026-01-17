-- 1. Der sichere Geldtransfer
START TRANSACTION;
UPDATE salaries SET salary = salary - 5000 WHERE emp_no = 10001 AND to_date > NOW();
UPDATE salaries SET salary = salary + 5000 WHERE emp_no = 10002 AND to_date > NOW();
COMMIT;

-- 2. Dirty Read Simulation
-- Session A:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM employees WHERE emp_no = 10001; -- Dirty Read möglich

-- Session B:
START TRANSACTION;
UPDATE employees SET first_name = 'Schorsch' WHERE emp_no = 10001;
-- ROLLBACK;

-- 3. Deadlock provozieren
-- Session A:
START TRANSACTION;
UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10001;
-- Warte...
UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10002; -- Deadlock hier

-- Session B:
START TRANSACTION;
UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10002;
UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10001; -- Oder hier

-- 4. Pessimistic Locking
START TRANSACTION;
SELECT * FROM employees WHERE emp_no = 10001 FOR UPDATE;
-- Jetzt sind die Zeilen gesperrt bis zum COMMIT/ROLLBACK.
COMMIT;

-- BONUS 1: Savepoints
START TRANSACTION;
UPDATE employees SET birth_date = '2000-01-01' WHERE emp_no = 10001;
SAVEPOINT my_save;
UPDATE employees SET birth_date = '2020-01-01' WHERE emp_no = 10001;
ROLLBACK TO SAVEPOINT my_save;
COMMIT; -- Das erste Update bleibt, das zweite ist weg.

-- BONUS 2: Lock Wait Timeout
SET SESSION innodb_lock_wait_timeout = 1;
-- Dann Deadlock Szenario wiederholen -> Timeout Fehler.

-- BONUS 3: Phantom Read (Repeatable Read vs Read Committed)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; -- Phantom Read möglich
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- Standard, verhindert Phantom Read in InnoDB (meistens)

-- BONUS 4: Locking Read (Share Mode)
SELECT * FROM employees WHERE emp_no = 10001 LOCK IN SHARE MODE;
-- Andere können lesen, aber nicht schreiben.

-- BONUS 5: Foreign Key Deadlock
-- (Benötigt zwei Tabellen A und B mit FK aufeinander)
-- Insert in A (lockt B), Insert in B (lockt A) -> Deadlock.

-- BONUS 6: Serializable
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Jeder SELECT wird implizit zum LOCK IN SHARE MODE.

-- BONUS 7: Autocommit
SET autocommit=0;
UPDATE employees SET first_name = 'Test' WHERE emp_no = 10001;
-- Ohne COMMIT sind Änderungen nach Disconnect weg.

-- BONUS 8: Information Schema Locks
SELECT * FROM information_schema.INNODB_TRX;
SELECT * FROM performance_schema.data_locks;

-- BONUS 9: Skipped Locked
SELECT * FROM tasks WHERE status = 'OPEN' LIMIT 1 FOR UPDATE SKIP LOCKED;

-- BONUS 10: Consistent Snapshot
START TRANSACTION WITH CONSISTENT SNAPSHOT;
-- "Friert" die Zeit ein. Änderungen anderer Transaktionen werden nicht gesehen.
