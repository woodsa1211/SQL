SELECT * 
FROM 
[Project Portfolio].[dbo].[CovidDeaths_01$]
WHERE continent is not null
order by 3,4

SELECT * 
FROM 
[Project Portfolio].[dbo].[CovidVaccination$]
WHERE continent is not null
order by 3,4

-- Select Data that we are going to be using 


SELECT Location, date, total_cases, new_cases, total_deaths,population  
FROM 
[Project Portfolio].[dbo].[CovidDeaths_01$]
WHERE continent is not null
order by 1,2 



-- Looking at Total Cases vs. Total Deaths 
-- shows likelihood of dying if you contract covid in your country  

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPercentage 
FROM 
[Project Portfolio].[dbo].[CovidDeaths_01$]
WHERE location like '%states%' AND continent is not null
order by 1,2  


-- Looking at Total Cases vs. Population 
-- Shows what percentage of population got Covid 

SELECT Location, date, population, total_cases, (total_cases/population)* 100 AS PercentPopulationInfected 
FROM [Project Portfolio].[dbo].[CovidDeaths_01$]
-- WHERE location like '%states%' AND WHERE continent is not null
order by 1,2  

-- Looking at Countries with Highest Infection Rate compared to Population 
SELECT Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))* 100 AS PercentPopulationInfected 
FROM [Project Portfolio].[dbo].[CovidDeaths_01$] 
WHERE continent is not null
Group by Location, Population
order by PercentPopulationInfected DESC 

-- Showing Countries with the Highest Death Count per Population 

SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Project Portfolio].[dbo].[CovidDeaths_01$] 
-- WHERE location like '%states%'
WHERE continent is not null
Group by Location
order by TotalDeathCount DESC  

-- LET'S BREAK THINGS DOWN BY CONTINENT 

-- Showing continents with the highest death count per population  
SELECT  continent, Max(cast(total_deaths as int)) as TotalDeathCount
From [Project Portfolio].[dbo].[CovidDeaths_01$] 
-- WHERE location like '%states%'
WHERE continent is not null
Group by continent
order by TotalDeathCount DESC




-- Global Numbers: Worldwide Covid Cases/Deaths by Day 

SELECT date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage 
FROM 
[Project Portfolio].[dbo].[CovidDeaths_01$]
--WHERE location like '%states%' 
where continent is not null
Group by date
order by 1,2 

-- Total Worldwide Covid Cases/Death Percentage 
SELECT Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage 
FROM 
[Project Portfolio].[dbo].[CovidDeaths_01$]
--WHERE location like '%states%' 
where continent is not null
--Group by date
order by 1,2 


-- Looking at Total Population vs Vaccinations 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated 
FROM
[Project Portfolio]..[CovidDeaths_01$] dea
JOIN [Project Portfolio]..[CovidVaccination$] vac
ON dea.location = vac.location 
AND dea.date = vac.date
where dea.continent is not null
order by 1,2, 3

--USE CTE 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
FROM
[Project Portfolio]..[CovidDeaths_01$] dea
JOIN [Project Portfolio]..[CovidVaccination$] vac
ON dea.location = vac.location 
AND dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeopleVaccinated/Population) * 100 
From PopvsVac




-- TEMP Table 

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
) 

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
FROM
[Project Portfolio]..[CovidDeaths_01$] dea
JOIN [Project Portfolio]..[CovidVaccination$] vac
ON dea.location = vac.location 
AND dea.date = vac.date
where dea.continent is not null
--order by 2, 3

SELECT *, (RollingPeopleVaccinated/Population) * 100 
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

--View of Percentage Population Vaccinated 
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
FROM
[Project Portfolio]..[CovidDeaths_01$] dea
JOIN [Project Portfolio]..[CovidVaccination$] vac
ON dea.location = vac.location 
AND dea.date = vac.date
where dea.continent is not null
--order by 2, 3

--View of continents death count
Create View ContinentTotalDeathCount as 
SELECT  continent, Max(cast(total_deaths as int)) as TotalDeathCount
From [Project Portfolio].[dbo].[CovidDeaths_01$] 
-- WHERE location like '%states%'
WHERE continent is not null
Group by continent
-- Order by TotalDeathCount DESC

--View of Countries with Highest Infection Rate compared to Population 
Create View CountriesInfectionRatevsPopulation as
SELECT Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))* 100 AS PercentPopulationInfected 
FROM [Project Portfolio].[dbo].[CovidDeaths_01$] 
WHERE continent is not null
Group by Location, Population
--order by PercentPopulationInfected DESC 

-- View of View of Countries Death Count/% VS Countries Infection Count/% 
Create View CountriesDeathVsInfection as 
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage, 
Max(total_cases) as HighestInfectionCount, 
Max((total_cases/population))* 100 AS PercentPopulationInfected
From [Project Portfolio].[dbo].[CovidDeaths_01$] 
-- WHERE location like '%states%'
WHERE continent is not null
Group by Location
--order by TotalDeathCount DESC  


Select * 
From PercentPopulationVaccinated
