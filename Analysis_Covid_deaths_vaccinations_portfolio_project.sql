SELECT *
FROM [Portfolio project]..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM [Portfolio project]..CovidVaccination
--ORDER BY 3,4
SELECT Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio project]..CovidDeaths
ORDER BY 1,2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio project]..CovidDeaths
WHERE Location like '%India%'
and continent is not null
ORDER BY 1,2


--Looking at Total Cases vs Population
--Shows what percentage of people got covid
SELECT Location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From [Portfolio project]..CovidDeaths
--WHERE Location like '%states%'
ORDER BY 1,2


--Looking at countries with highest infection rate compared to population
SELECT Location, population, MAX(total_cases) AS HighestCases, MAX((total_cases/population)*100) as PercentagePopulationInfected
From [Portfolio project]..CovidDeaths
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC


--Showing countries with highest death count per population 
SELECT Location, population, MAX(CAST(total_deaths AS int)) AS HighestDeaths, MAX((total_deaths/population)*100) as PercentagePopulationDied
From [Portfolio project]..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentagePopulationDied DESC


--Showing Continents with the highest death count per population
--Lets Break Things By Continent
SELECT continent, MAX(CAST(total_deaths AS int)) AS HighestDeaths
From [Portfolio project]..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY HighestDeaths DESC


--Global Numbers

SELECT SUM(new_cases) AS global_total_cases, SUM(CAST(new_deaths AS int)) AS global_total_deaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 as DeathPercentageGlobally
From [Portfolio project]..CovidDeaths
--WHERE Location like '%India%'
where continent is not null
ORDER BY 1,2

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) AS TotalVaccinationtilldate
FROM [Portfolio project]..CovidDeaths dea
JOIN [Portfolio project]..CovidVaccination  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3



--USE CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, TotalVaccinationtilldate)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) AS TotalVaccinationtilldate
FROM [Portfolio project]..CovidDeaths dea
JOIN [Portfolio project]..CovidVaccination  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (TotalVaccinationtilldate/population)*100
FROM PopvsVac


--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalVaccinationtilldate numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) AS TotalVaccinationtilldate
FROM [Portfolio project]..CovidDeaths dea
JOIN [Portfolio project]..CovidVaccination  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3
select *, (TotalVaccinationtilldate/population)*100
FROM #PercentPopulationVaccinated

--Creating View to store Data for later Visualisatio

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) AS TotalVaccinationtilldate
FROM [Portfolio project]..CovidDeaths dea
JOIN [Portfolio project]..CovidVaccination  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3.

Select *
FROM PercentPopulationVaccinated

 
