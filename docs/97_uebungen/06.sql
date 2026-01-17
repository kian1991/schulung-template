-- 1. The Slow Query
-- Vorher:
SELECT * FROM salaries WHERE salary = 60117;
-- EXPLAIN zeigt type=ALL (Full Table Scan)

CREATE INDEX idx_salary ON salaries(salary);

-- Nachher:
SELECT * FROM salaries WHERE salary = 60117;
-- EXPLAIN zeigt type=ref (Index Lookup)

-- 2. Composite Index
CREATE INDEX idx_name ON employees(last_name, first_name);

EXPLAIN SELECT * FROM employees WHERE last_name = 'Facello' AND first_name = 'Georgi';
-- Nutzt idx_name (key_len zeigt Nutzung beider Spalten an)

EXPLAIN SELECT * FROM employees WHERE first_name = 'Georgi';
-- Nutzt idx_name NICHT (oder nur als Index Scan, aber keinen Seek), weil first_name nicht links steht.
-- "Leftmost Prefix Rule" verletzt.

-- 3. Sorting Optimization
EXPLAIN SELECT * FROM employees ORDER BY hire_date LIMIT 10;
-- Zeigt "Using filesort"

CREATE INDEX idx_hire_date ON employees(hire_date);
-- Jetzt nutzt er den Index für die Sortierung -> "Using filesort" verschwindet.

-- 4. App-Side Profiling (Bun Script)
-- (Dies ist eine SQL Datei, daher hier nur Pseudocode)
/*
const start = performance.now();
const rows = await db`SELECT * FROM salaries LIMIT 100000`;
const queryTime = performance.now() - start;

const startProcess = performance.now();
// loop over rows...
const processTime = performance.now() - startProcess;

console.log(queryTime, processTime);
*/

-- BONUS 1: Invisible Index
ALTER TABLE employees ALTER INDEX idx_hire_date INVISIBLE;
EXPLAIN SELECT * FROM employees ORDER BY hire_date LIMIT 10; -- Wieder filesort

-- BONUS 2: Prefix Index
CREATE INDEX idx_last_name_prefix ON employees(last_name(3));

-- BONUS 3: Force Index
SELECT * FROM employees FORCE INDEX (idx_name) WHERE last_name = 'Facello';

-- BONUS 4: Covering Index
EXPLAIN SELECT last_name, first_name FROM employees WHERE last_name = 'Facello';
-- Extra: "Using index" (Daten kommen rein aus dem Index, kein Zugriff auf Table Heap nötig)

-- BONUS 5: Index Merge
-- SELECT * FROM t WHERE a=1 OR b=2;
-- Wenn Index auf a und Index auf b existiert, zeigt EXPLAIN type=index_merge

-- BONUS 6: Analyze Table
ANALYZE TABLE employees;
-- Aktualisiert Kardinalitäts-Statistiken. Sinnvoll nach großen Bulk-Inserts/Deletes.

-- BONUS 7: Optimizer Hints
SELECT /*+ MAX_EXECUTION_TIME(1000) */ * FROM salaries;

-- BONUS 8: Duplicate Index
-- Index(A) ist redundant, wenn Index(A, B) existiert.
-- Tools wie pt-duplicate-key-checker helfen.

-- BONUS 9: Cardinality
SHOW INDEX FROM employees;
-- Hohe Kardinalität = Viele eindeutige Werte = Guter Index.
-- Niedrige Kardinalität (z.B. Gender M/F) = Schlechter Index (meistens).

-- BONUS 10: Performance Schema
SELECT * FROM performance_schema.events_statements_history_long 
WHERE sql_text LIKE '%salaries%' 
ORDER BY timer_wait DESC LIMIT 1;
