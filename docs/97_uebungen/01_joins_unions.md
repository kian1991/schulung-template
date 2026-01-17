---
title: "Übungen: Joins & Unions"
---

# Übungen: Joins, Unions & Subqueries

Hier sind Aufgaben, um das Wissen zu vertiefen. Alle Aufgaben basieren auf der `employees` Datenbank.

## Aufgabe 1: Der einfache Join
**Ziel:** Liste alle Mitarbeiter auf, die aktuell in der Abteilung "Sales" arbeiten.
*   **Benötigte Tabellen:** `employees`, `dept_emp`, `departments`
*   **Bedingung:** `to_date > NOW()` (nur aktuelle Verknüpfungen)
*   **Ausgabe:** `first_name`, `last_name`, `dept_name`

## Aufgabe 2: Manager-Historie
**Ziel:** Wer war alles Manager der Abteilung "Development"?
*   **Benötigte Tabellen:** `dept_manager`, `departments`, `employees`
*   **Sortierung:** Nach `from_date` aufsteigend.
*   **Ausgabe:** `first_name`, `last_name`, `from_date`, `to_date`

## Aufgabe 3: Gehalts-Check (Aggregation)
**Ziel:** Wie hoch ist das **durchschnittliche** Gehalt in jeder Abteilung (aktuell)?
*   **Benötigte Tabellen:** `salaries`, `dept_emp`, `departments`
*   **Hinweis:** Vergiss nicht, nur aktuelle Gehälter und Abteilungszugehörigkeiten zu filtern!
*   **Ausgabe:** `dept_name`, `avg_salary` (gerundet auf 2 Stellen)

## Aufgabe 4: Missing Data (Left Join)
**Ziel:** (Theoretisch) Finde alle Mitarbeiter, die **keinen** Titel haben.
*   **Hinweis:** In der `employees` DB hat eigentlich jeder einen Titel. Um das zu testen, könnte man einen Dummy-User ohne Titel einfügen.
*   **Query:** Schreibe eine Query mit `LEFT JOIN` zwischen `employees` und `titles`, die nur Mitarbeiter ohne Titel-Eintrag liefert.

## Aufgabe 5: The Big Union
**Ziel:** Erstelle eine Liste aller "Manager" und aller "Senior Engineers".
*   **Spalten:** `first_name`, `last_name`, `role` (Setze den Wert manuell auf 'Manager' oder 'Senior Dev')
*   **Hinweis:** Nutze `UNION ALL` für bessere Performance, wenn Du weißt, dass es keine Überschneidungen gibt (oder `UNION` wenn doch).

## Bonusübungen

1.  **Self Join:** Finde alle Paare von Mitarbeitern, die den gleichen Nachnamen haben (gib nur die ersten 10 Paare aus).
2.  **Cross Join:** Generiere eine (theoretische) Liste aller möglichen Kombinationen aus Abteilungen und Titeln.
3.  **Subquery in FROM:** Finde alle Abteilungen, die mehr als 50.000 Einträge in der `dept_emp` Tabelle haben (nutze dazu eine Subquery in der FROM-Klausel oder eine CTE).
4.  **EXISTS vs. IN:** Finde alle Manager, die auch noch eine normale Rolle als "Engineer" hatten. Löse die Aufgabe einmal mit `IN` und einmal mit `EXISTS`. Vergleiche (theoretisch) die Performance.
5.  **Recursive CTE:** (Fortgeschritten) Erstelle eine rekursive CTE, die die Zahlen 1 bis 10 generiert. (Falls keine Hierarchie-Daten da sind, ist das eine gute Übung für die Syntax).
6.  **Natural Join:** Nutze `NATURAL JOIN` um `employees` und `dept_emp` zu verbinden. Was passiert? (Vorsicht: Es verbindet alle gleichnamigen Spalten!).
7.  **Finding Gaps:** Angenommen, wir haben eine Tabelle mit fortlaufenden Nummern (IDs). Schreibe eine Query (z.B. mit Self-Join), die Lücken in der Nummerierung findet.
8.  **Anti-Join:** Finde alle Abteilungen, die aktuell *keinen* Manager haben (falls das datentechnisch möglich wäre). Nutze dazu `LEFT JOIN ... WHERE ... IS NULL`.
9.  **Aggregation mit Filter:** Berechne das Durchschnittsgehalt pro Abteilung, aber berücksichtige nur Gehälter über 60.000. Nutze dazu eine gefilterte Aggregation (oder `WHERE` vor `GROUP BY`).
10. **Complex Grouping:** Gruppiere die Mitarbeiter nach Einstellungsjahr (`YEAR(hire_date)`) und Geschlecht. Zähle die Anzahl pro Gruppe.
