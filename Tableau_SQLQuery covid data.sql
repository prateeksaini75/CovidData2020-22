
--Covid data queries for tableau:

-- 1. Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio project]..CovidDeaths
--Where location like '%india%'
where continent is not null 
--Group By date
order by 1,2


-- 2. Total Deaths per Continent

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio project]..CovidDeaths
--Where location like '%india%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'Lower middle income', 'Low income', 'Upper middle income', 'High income')
Group by location
order by TotalDeathCount desc


-- 3.Total Deaths per Continent

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio project]..CovidDeaths
--Where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.Percent Population Infected


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio project]..CovidDeaths
--Where location like '%india%'
Group by Location, Population, date
order by PercentPopulationInfected desc












