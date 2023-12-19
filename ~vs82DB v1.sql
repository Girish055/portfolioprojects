select *
from [Portfolio Project]..['covid deaths$']
order by 3,4 

--select *
--from [Portfolio Project]..['covid vaccines$']
--order by 3,4

--total cases vs total Deaths

select location, date, total_cases, total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [Portfolio Project]..['covid deaths$']
where location like '%India%'
order by 1,2


-- Total cases vs Population

select location, date, total_cases, population, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS percentpopulationinfected
from [Portfolio Project]..['covid deaths$']
where location like '%India%'
order by 1,2

-- countries wit highest infection rates compared to population 

SELECT
    location,
    Population,
    MAX(total_cases) AS highestinfectioncount,
    (CONVERT(float, MAX(total_cases)) / NULLIF(MAX(CONVERT(float, population)), 0)) * 100 AS percentpopulationinfected
FROM
    [Portfolio Project]..['covid deaths$']
GROUP BY
    location, Population
ORDER BY
    percentpopulationinfected DESC;

--countries with highest death count per popuation

SELECT
    location, MAX(cast(total_deaths as int)) as totaldeathcount
FROM
    [Portfolio Project]..['covid deaths$']
	where continent is not null
GROUP BY
    location 
ORDER BY
     totaldeathcount DESC;


-- Looking at total popuylation vs vacination 


select *
From [Portfolio Project]..['covid deaths$'] dea
join[Portfolio Project]..['covid vaccines$'] vac
 on dea.location = vac.location
 and dea.date = vac.date

 select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
From [Portfolio Project]..['covid deaths$'] dea
join[Portfolio Project]..['covid vaccines$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2,3

 -- partition means break up by 

 select dea.continent, dea.date, dea.location, dea.population, 
 vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location)
From [Portfolio Project]..['covid deaths$'] dea
join[Portfolio Project]..['covid vaccines$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

  select dea.continent, dea.date, dea.location, dea.population, 
 vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location 
 order by dea.location, dea.date) as rollingpeoplevaccinated
From [Portfolio Project]..['covid deaths$'] dea
join[Portfolio Project]..['covid vaccines$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

  create view percentpopulationvaccinated as
  select dea.continent, dea.date, dea.location, dea.population, 
 vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location 
 order by dea.location, dea.date) as rollingpeoplevaccinated
From [Portfolio Project]..['covid deaths$'] dea
join[Portfolio Project]..['covid vaccines$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

