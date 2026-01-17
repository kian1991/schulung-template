---
title: "Übungen: Transaktionen"
---

# Übungen: Transaktionen & Locking

Diese Übungen erfordern zwei parallele Verbindungen (z.B. zwei Browser-Tabs in phpMyAdmin oder zwei Terminal-Fenster).

## Aufgabe 1: Der sichere Geldtransfer
**Szenario:** Du willst das Gehalt von Mitarbeiter 10001 um 5000 reduzieren und Mitarbeiter 10002 um 5000 erhöhen.

1.  Starte eine Transaktion (`START TRANSACTION`).
2.  Führe das erste Update aus.
3.  Prüfe in einer **anderen** Session, ob sich der Wert schon geändert hat. (Sollte nicht!)
4.  Führe das zweite Update aus.
5.  `COMMIT`.
6.  Prüfe erneut in der anderen Session.

## Aufgabe 2: Dirty Read Simulation
**Ziel:** Verstehe `READ UNCOMMITTED`.

1.  **Session A:** Setze Isolation Level: `SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED`.
2.  **Session B:** Starte Transaktion, ändere einen Namen in `employees` (z.B. "Georgi" -> "Schorsch"). **Kein Commit!**
3.  **Session A:** Lese den Datensatz. Siehst du "Schorsch"? (Ja!)
4.  **Session B:** `ROLLBACK`.
5.  **Session A:** Lese erneut. Was siehst du jetzt?

## Aufgabe 3: Deadlock provozieren
**Ziel:** Bringe die Datenbank dazu, einen Fehler 1213 zu werfen.

1.  **Session A:** `START TRANSACTION; UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10001;`
2.  **Session B:** `START TRANSACTION; UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10002;`
3.  **Session A:** `UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10002;` (Wartet...)
4.  **Session B:** `UPDATE salaries SET salary = salary + 1 WHERE emp_no = 10001;` (Boom!)

## Aufgabe 4: Pessimistic Locking
**Ziel:** Verhindere, dass jemand anderes Daten ändert, während du sie liest.

1.  **Session A:** `START TRANSACTION; SELECT * FROM employees WHERE emp_no = 10001 FOR UPDATE;`
2.  **Session B:** Versuche, den Namen von 10001 zu ändern. Was passiert?
3.  **Session A:** `COMMIT`. Was passiert jetzt bei B?

## Bonusübungen

1.  **Savepoints:** Starte eine Transaktion, setze einen `SAVEPOINT my_save`. Ändere Daten. Mache einen `ROLLBACK TO SAVEPOINT my_save`. Prüfe, ob die Änderungen weg sind, die Transaktion aber noch offen ist.
2.  **Lock Wait Timeout:** Setze in einer Session `SET SESSION innodb_lock_wait_timeout = 1;`. Provoziere einen Lock Wait (wie in Aufgabe 3 oder 4). Beobachte, wie schnell der Fehler kommt.
3.  **Phantom Read:** Versuche, in zwei Sessions ein "Phantom Read" Phänomen nachzustellen (Session A liest alle Mitarbeiter, Session B fügt einen neuen hinzu, Session A liest erneut). Vergleiche das Verhalten von `REPEATABLE READ` (Standard) und `READ COMMITTED`.
4.  **Locking Read (Share Mode):** Nutze `SELECT ... LOCK IN SHARE MODE` (oder `FOR SHARE` in neueren Versionen). Versuche in einer anderen Session, den Datensatz zu lesen (sollte gehen) und zu schreiben (sollte blockieren).
5.  **Foreign Key Deadlock:** Erstelle zwei Tabellen mit gegenseitigen Foreign Keys. Versuche, in zwei Transaktionen über Kreuz Daten einzufügen, um einen Deadlock zu provozieren.
6.  **Serializable:** Setze das Isolation Level auf `SERIALIZABLE`. Prüfe, wie sich das Verhalten bei einfachen SELECTs ändert (werden sie zu Locking Reads?).
7.  **Autocommit:** Deaktiviere `autocommit` (`SET autocommit=0`). Führe Updates durch. Beende die Session ohne Commit. Sind die Daten weg?
8.  **Information Schema Locks:** Während eine Transaktion blockiert (z.B. durch `FOR UPDATE`), prüfe in einer dritten Session die Tabelle `information_schema.INNODB_TRX` oder `performance_schema.data_locks`, um den Lock zu sehen.
9.  **Skipped Locked:** Nutze `SELECT ... FOR UPDATE SKIP LOCKED`. Starte zwei Sessions, die beide versuchen, "die nächsten 5 offenen Aufgaben" zu holen. Sie sollten unterschiedliche Zeilen bekommen.
10. **Consistent Snapshot:** Starte eine Transaktion mit `START TRANSACTION WITH CONSISTENT SNAPSHOT`. Ändere Daten in einer anderen Session. Prüfe, ob deine Transaktion den alten Stand sieht ("Time Travel").
