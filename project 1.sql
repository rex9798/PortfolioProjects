-- SELECT a database to work with
USE project;

-- Clean the data before importing to mysql

-- Create a table template first 

DROP TABLE IF EXISTS CovidDeaths;
CREATE TABLE CovidDeaths (
iso_code VARCHAR(100),
continent VARCHAR(100),
location VARCHAR(100),
date1 DATE,
population VARCHAR(100),
total_cases INT,
new_cases INT,
new_cases_smoothed DECIMAL (30,3),
total_deaths INT,
new_deaths INT,
new_deaths_smoothed DECIMAL (30,3),
total_cases_per_million DECIMAL (30,3),
new_cases_per_million DECIMAL (30,3),
new_cases_smoothed_per_million DECIMAL (30,3),
total_deaths_per_million DECIMAL (30,3),
new_deaths_per_million DECIMAL (30,3),
new_deaths_smoothed_per_million DECIMAL (30,3),
reproduction_rate DECIMAL (30,3),
icu_patients DECIMAL (30,3),
icu_patients_per_million DECIMAL (30,3),
hosp_patients DECIMAL (30,3),
hosp_patients_per_million DECIMAL (30,3),
weekly_icu_admissions DECIMAL (30,3),
weekly_icu_admissions_per_million DECIMAL (30,3),
weekly_hosp_admissions DECIMAL (30,3),
weekly_hosp_admissions_per_million DECIMAL (30,3)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL infile 'C:\\Users\\Rex\\Desktop\\Data Analyst Project CSV\\Project 1 Covid\\CovidDeaths.csv'
into table CovidDeaths
fields terminated by ','
ignore 1 rows;

-- Check to see if it works
SELECT *
FROM CovidDeaths
WHERE NOT continent = '';


-- Do the same with the second table
DROP TABLE IF EXISTS CovidVaccination;
CREATE TABLE CovidVaccination (
iso_code VARCHAR(100),
continent VARCHAR(100),
location VARCHAR(100),
date1 DATE,
new_tests INT,
total_tests INT,
total_tests_per_thousand DECIMAL (30,3),
new_tests_per_thousand DECIMAL (30,3),
new_tests_smoothed INT,
new_tests_smoothed_per_thousand DECIMAL (30,3),
positive_rate DECIMAL (30,3),
tests_per_case DECIMAL (30,1),
tests_units VARCHAR(100),
total_vaccinations INT,
people_vaccinated INT,
people_fully_vaccinated INT,
new_vaccinations INT,
new_vaccinations_smoothed INT,
total_vaccinations_per_hundred DECIMAL (30,2),
people_vaccinated_per_hundred DECIMAL (30,2),
people_fully_vaccinated_per_hundred DECIMAL (30,2),
new_vaccinations_smoothed_per_million INT,
stringency_index DECIMAL (30,2),
population_density DECIMAL (30,3),
median_age INT,
aged_65_older DECIMAL (30,3),
aged_70_older DECIMAL (30,3),
gdp_per_capita DECIMAL (30,3),
extreme_poverty DECIMAL (30,1),
cardiovasc_death_rate DECIMAL (30,3),
diabetes_prevalence DECIMAL (30,2),
female_smokers DECIMAL (30,1),
male_smokers DECIMAL (30,1),
handwashing_facilities DECIMAL (30,3),
hospital_beds_per_thousand DECIMAL (30,2),
life_expectancy DECIMAL (30,2),
human_development_index DECIMAL (30,3)
);

LOAD DATA LOCAL infile 'C:\\Users\\Rex\\Desktop\\Data Analyst Project CSV\\Project 1 Covid\\CovidVaccinations.csv'
into table CovidVaccination
fields terminated by ','
ignore 1 rows;

SELECT *
FROM CovidVaccination;

-- Select data that we are going to be using 
SELECT Location, date1, total_cases, new_cases, total_deaths, population
FROM CovidDeaths;

-- Looking at the Total Cases vs Total Deaths, and the deathpercentage
-- Shows the likelihood of dying if you got affected by covid in your country
SELECT Location, date1, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location like '%states%';

-- Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT Location, date1, Population, total_cases, (total_cases/Population)*100 as TotalCasesPercentage
FROM CovidDeaths
WHERE Location like '%states%';

-- Looking at the countries with highest infection rate compared to population
SELECT Location, MAX(total_cases) as HighestInfectionCount, Population
FROM CovidDeaths
GROUP BY Location;

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Showing countries with the highest death count per population
SELECT Location, Population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/Population))*100 as PercentPopulationDeaths
FROM CovidDeaths
WHERE NOT continent = ''
GROUP BY Location
ORDER BY HighestDeathCount DESC;

-- Let's break things down by continent
SELECT continent, Population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/Population))*100 as PercentPopulationDeaths
FROM CovidDeaths
WHERE NOT continent = ''
GROUP BY continent
ORDER BY HighestDeathCount DESC;

-- This is the correct way but stick with the one above
SELECT location, Population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/Population))*100 as PercentPopulationDeaths
FROM CovidDeaths
WHERE continent = ''
GROUP BY location
ORDER BY HighestDeathCount DESC;

-- Showing the contintents with the highest death count
SELECT continent, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE NOT continent = ''
GROUP BY continent;

-- Global Numbers
SELECT date1, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE NOT continent = ''
GROUP BY date1
ORDER BY SUM(new_cases); 

-- Lets use the other table covidvacinations
-- Looking at the total population vs vaccination
SELECT dea.location, dea.date1, dea.continent, dea.population, vac.new_vaccinations
FROM coviddeaths dea
JOIN covidvaccination vac ON dea.location = vac.location AND dea.date1 = vac.date1
WHERE NOT dea.continent = '' AND dea.location = 'Canada';



-- WRONG JUST TESTING
SELECT dea.location, dea.date1, dea.continent, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
FROM coviddeaths dea
JOIN covidvaccination  vac ON dea.location = vac.location AND dea.date1 = vac.date1
WHERE NOT dea.continent = '' 
GROUP BY dea.location;

SELECT dea.location, dea.date1, dea.continent, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date1) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccination  vac ON dea.location = vac.location AND dea.date1 = vac.date1
WHERE NOT dea.continent = '' AND dea.location = 'Albania'; 

-- USE CTE
With PopvsVac (Continent, location, date1, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.location, dea.date1, dea.continent, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date1) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccination  vac ON dea.location = vac.location AND dea.date1 = vac.date1
WHERE NOT dea.continent = '' 
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.location, dea.date1, dea.continent, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date1) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccination  vac ON dea.location = vac.location AND dea.date1 = vac.date1
WHERE NOT dea.continent = ''; 

SELECT * FROM project.percentpopulationvaccinated;




