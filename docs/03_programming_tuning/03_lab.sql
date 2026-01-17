-- stored procedure
DELIMITER //
CREATE OR REPLACE PROCEDURE search_ocean(IN p_term VARCHAR(255))
BEGIN
    SELECT title, content
    FROM ocean_articles
    WHERE MATCH(title, content) AGAINST(p_term IN BOOLEAN MODE)
    LIMIT 5;
END //
DELIMITER ;
