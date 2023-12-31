USE project;
DROP TABLE IF EXISTS AccidentData;
CREATE TABLE AccidentData (
Index_code VARCHAR(100),
Accident_Severity VARCHAR(100),
Accident_Date Date,
Latitude DECIMAL(8,6),
Light_Conditions VARCHAR(100),
District_Area VARCHAR(100),
Longitude DECIMAL(7,6),
Number_of_Casualities INT(100),
Number_of_Vehicle INT(100),
Road_Surface_Condition VARCHAR(100),
Road_Type VARCHAR(100),
Urban_or_Rural_Area VARCHAR(100),
Weather_Conditions VARCHAR(100),
Vehicle_Type VARCHAR(100)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL infile "C:\\Users\\Rex\\Desktop\\Data Analyst Project CSV\\SQL Projects\\Project 01 accident\\accident data.csv"
into table AccidentData
fields terminated by ','
ignore 1 rows;

SELECT *
FROM accidentdata;



### Find the percentage of different accident severity for different years

WITH Different_Severity (Accident_Severity, number_of_AccidentSeverity) 
as
(
SELECT Accident_Severity, COUNT(Accident_Severity) 
FROM accidentdata
WHERE Accident_Date LIKE '2019%'
GROUP BY Accident_Severity
)

SELECT Accident_Severity, number_of_AccidentSeverity* 100 / (SELECT SUM(number_of_AccidentSeverity) FROM Different_Severity) AS AccidentSeverity
FROM Different_Severity
GROUP BY Accident_Severity;

WITH Different_Severity (Accident_Severity, number_of_AccidentSeverity) 
as
(
SELECT Accident_Severity, COUNT(Accident_Severity) 
FROM accidentdata
WHERE Accident_Date LIKE '2020%'
GROUP BY Accident_Severity
)

SELECT Accident_Severity, number_of_AccidentSeverity* 100 / (SELECT SUM(number_of_AccidentSeverity) FROM Different_Severity) AS AccidentSeverity
FROM Different_Severity
GROUP BY Accident_Severity;

WITH Different_Severity (Accident_Severity, number_of_AccidentSeverity) 
as
(
SELECT Accident_Severity, COUNT(Accident_Severity) 
FROM accidentdata
WHERE Accident_Date LIKE '2021%'
GROUP BY Accident_Severity
)

SELECT Accident_Severity, number_of_AccidentSeverity* 100 / (SELECT SUM(number_of_AccidentSeverity) FROM Different_Severity) AS AccidentSeverity
FROM Different_Severity
GROUP BY Accident_Severity;

WITH Different_Severity (Accident_Severity, number_of_AccidentSeverity) 
as
(
SELECT Accident_Severity, COUNT(Accident_Severity) 
FROM accidentdata
WHERE Accident_Date LIKE '2022%'
GROUP BY Accident_Severity
)

SELECT Accident_Severity, number_of_AccidentSeverity* 100 / (SELECT SUM(number_of_AccidentSeverity) FROM Different_Severity) AS AccidentSeverity
FROM Different_Severity
GROUP BY Accident_Severity;

# See the number of vehicle involve in most accidents
SELECT Number_of_Vehicle, COUNT(Number_of_Vehicle)
FROM accidentdata
GROUP BY Number_of_Vehicle
ORDER BY COUNT(Number_of_Vehicle) DESC; 


# See the types of vehicle involve in most accidents
SELECT Vehicle_Type, COUNT(Vehicle_Type)
FROM accidentdata
GROUP BY Vehicle_Type
ORDER BY COUNT(Vehicle_Type) DESC; 


# See what Light_Conditions is in the accidents
SELECT Light_Conditions, COUNT(Light_Conditions)
FROM accidentdata
GROUP BY Light_Conditions
ORDER BY COUNT(Light_Conditions) DESC; 

# See what weather conditions + Road_Surface_Condition causes the most accident
SELECT Weather_Conditions, Road_Surface_Condition, COUNT(Weather_Conditions) AS NumberOfAccident
FROM accidentdata
WHERE NOT Weather_Conditions = '' AND NOT Road_Surface_Condition = ''
GROUP BY Weather_Conditions, Road_Surface_Condition
ORDER BY Weather_Conditions, NumberOfAccident DESC; 


