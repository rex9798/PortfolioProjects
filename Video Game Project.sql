-- SELECT a database to work with
USE project;

DROP TABLE IF EXISTS vgsales;
CREATE TABLE vgsales (
Rank1 INT,
NAME1 VARCHAR(100),
Platform VARCHAR(100),
Year1 INT,
Genre VARCHAR(100),
Publisher VARCHAR(100),
NA_Sales DECIMAL (30,2),
EU_Sales DECIMAL (30,2),
JP_Sales DECIMAL (30,2),
Other_Sales DECIMAL (30,2),
Global_Sales DECIMAL (30,2)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL infile "C:\\Users\\Rex\\Desktop\\Data Analyst Project CSV\\Project 2 video games\\vgsales.csv"
into table vgsales
fields terminated by ','
ignore 1 rows;

-- See which Platform has the highest sale throughout the year
SELECT Platform, SUM(Global_Sales)
FROM vgsales
GROUP BY Platform 
ORDER BY SUM(Global_Sales) DESC;

SELECT Platform, SUM(NA_Sales)
FROM vgsales
GROUP BY Platform 
ORDER BY SUM(NA_Sales) DESC;

SELECT Platform, SUM(JP_Sales)
FROM vgsales
GROUP BY Platform 
ORDER BY SUM(JP_Sales) DESC;

SELECT Platform, SUM(EU_Sales)
FROM vgsales
GROUP BY Platform 
ORDER BY SUM(EU_Sales) DESC;

SELECT Platform, SUM(Other_Sales)
FROM vgsales
GROUP BY Platform 
ORDER BY SUM(Other_Sales) DESC;

-- See which Genre is the most popular throughout the different years
SELECT Year1, Genre, Name1, MAX(Global_Sales) AS HighestSales
FROM vgsales
WHERE NOT Year1 = 'N/A'
GROUP BY Year1
ORDER BY Year1;

SELECT Year1, Genre, MAX(Global_Sales) AS HighestSales, Name1
FROM vgsales
WHERE NOT Year1 = 'N/A' AND NAME1 LIKE '%Mario%'
GROUP BY Year1
ORDER BY Year1;

-- See Mario vs Pokemon two popular game series 
SELECT Year1, Name1, MAX(Global_Sales) AS HighestAmongTheTwo
FROM vgsales
WHERE NOT Year1 = 'N/A' AND NAME1 LIKE '%Mario%' OR NAME1 LIKE '%Pokemon%'
GROUP BY Year1
ORDER BY Year1;

-- See the percentage of Platform for the past years
WITH t(Platform, Global_Sales)
AS
(SELECT Platform, SUM(Global_Sales) 
 FROM vgsales
 WHERE NOT Year1 = 'N/A'
 GROUP BY Platform
)
SELECT Platform, Global_Sales * 100/(SELECT SUM(Global_Sales) FROM t) AS PercentageOfSales
FROM t
ORDER BY PercentageOfSales DESC;

-- See the percentage of Publisher for the past years
WITH t(Publisher, Global_Sales)
AS
(SELECT Publisher, SUM(Global_Sales)
FROM vgsales
WHERE NOT Year1 = 'N/A'
GROUP BY Publisher
)
SELECT Publisher, Global_Sales * 100 /(SELECT SUM(Global_Sales) FROM t) AS PercentageOfPublisher
FROM t
ORDER BY PercentageOfPublisher DESC;



