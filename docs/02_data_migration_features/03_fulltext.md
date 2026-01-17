---
title: "Fulltext Search"
---

## Fulltext Search

`LIKE '%wort%'` ist langsam und dumm (findet "Wörter" nicht, wenn man nach "Wort" sucht).
Fulltext Search ist die eingebaute Suchmaschine.

### Index erstellen
Ein Fulltext Index funktioniert wie ein Buch-Index. Er speichert, welches Wort in welcher Zeile vorkommt.

```sql
ALTER TABLE articles ADD FULLTEXT(title, body);
```

### Modus 1: Natural Language (Google-Style)
Versucht, die "besten" Treffer zu finden. Sortiert automatisch nach Relevanz.

```sql
SELECT *, MATCH(title, body) AGAINST('Database Tutorial') as score
FROM articles
WHERE MATCH(title, body) AGAINST('Database Tutorial');
```

### Modus 2: Boolean Mode 
Erlaubt Operatoren für präzise Kontrolle.

* `+`: Wort **muss** vorkommen.
* `-`: Wort **darf nicht** vorkommen.
* `*`: Wildcard (am Wortende).
* `""`: Exakte Phrase.

```sql
-- Finde Artikel, die "Database" enthalten, aber NICHT "Oracle".
-- "MySQL" ist optional, erhöht aber den Score.
SELECT * FROM articles
WHERE MATCH(title, body) AGAINST('+Database -Oracle MySQL' IN BOOLEAN MODE);
```

:::warning[Stopwords]
MySQL ignoriert sehr häufige Wörter ("the", "is", "and") automatisch. Das kann man konfigurieren, ist aber meistens gewollt.
:::
