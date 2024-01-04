select * 
from CovidDeaths cd 
-- where continent is not NULL 
order by 3,4

-- select *
-- from CovidVaccinations
-- order by 3,4

-- Select Data that wer are going to be using


Select 

location
,date
,total_cases
,new_cases
,total_deaths
,population

from
CovidDeaths
where continent is not NULL 
order by 1,2

-- looking at the total cases vs total deahs
-- shows the likelihood of dying if you contract Covid in your conutry

Select 

location
,date
,total_cases
,total_deaths
,(total_deaths/total_cases)* 100  as DeathPercentage
from
CovidDeaths

-- where location like '%states%'

order by 1,2


-- Looking at total cases vs Population
-- shows what % of pop got Covid


Select 

location
,date
,total_cases
,population
,(total_cases/population)* 100  as PercentofPopulationInfected
from
CovidDeaths

where 
location like '%states%'

order by 1,2


-- Looking at Countries w/ highest infection rate compared to pop

Select 

Location
,Population
,Max(total_cases) as HighestInfectionCount
,Max((total_cases/population))* 100 as PercentofPopulationInfected

from
CovidDeaths

-- where location like '%states%'
group by location, population

order by PercentofPopulationInfected DESC 


-- Showing Countries with Highest Death Count per Population

Select 

Location
,Max(total_deaths)as TotalDeathCount

from
CovidDeaths

-- where location like '%states%'
group by Location
order by TotalDeathCount DESC 

-- CNow cutting it up by continent
-- Showing contintents with the highest death count per populaton

Select 

Continent
,Max(total_deaths)as TotalDeathCount

from
CovidDeaths 

-- where location like '%states%'
where continent is not NULL 
group by continent
order by TotalDeathCount DESC 

-- Global Numbers

Select

date
,new_cases
,new_deaths
,(new_deaths/new_cases)* 100  as DeathPercentage

-- where location like '%states%'
where continent is not NULL 

from sys.CovidDeaths 

-- Join CovidDeaths with CovidVaccinations
-- Looking at Total Populations VS Vaccinations
Select

DEA.Continent
,DEA.Location
,DEA.Date
,DEA.Population
,VAC.new_vaccinations
,sum(vac.new_vaccinations) over (Partition by DEA.Location ORDER by DEA.Location, DEA.Date) as RollingPplVaccinated
-- ,(RollingPplVaccinated/population)*100

From sys.CovidDeaths DEA
Join sys.CovidVaccinations VAC
On DEA.Location = VAC.location
and DEA.date = VAC.date
where VAC.new_vaccinations is not NULL 
and dea.location like '%states%'


-- CTE
With PopVsVacc (Continent, Location, Date, Population, new_vaccinations, RollingPplVaccinated)as
(
Select
DEA.Continent
,DEA.Location
,DEA.Date
,DEA.Population
,VAC.new_vaccinations
,sum(vac.new_vaccinations) over (Partition by DEA.Location ORDER by DEA.Location, DEA.Date) as RollingPplVaccinated
-- ,(RollingPplVaccinated/population)*100

From sys.CovidDeaths DEA
Join sys.CovidVaccinations VAC
On DEA.Location = VAC.location
and DEA.date = VAC.date
where VAC.new_vaccinations is not NULL 
and dea.location like '%states%'
)

SELECT *, (RollingPplVaccinated/Population)*100
from PopVsVacc

-- Quick View for Data Viz
Create View PercentofPopulationInfected as
Select 

location
,date
,total_cases
,population
,(total_cases/population)* 100  as PercentofPopulationInfected
from
CovidDeaths

where location like '%states%'

