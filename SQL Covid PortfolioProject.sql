select*
FROM PortfolioProject..CovidDeaths

order by 3,4

--select*
--FROM PortfolioProject..CovidVaccinations

--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
order by 1,2

select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where location like '%Pakistan%'
order by 1,2

select location,date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
order by 1,2

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
Group by location,population
order by PercentPopulationInfected desc

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
where continent is not null
Group by location
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
where continent is not null
Group by continent
order by TotalDeathCount desc

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
where continent is not null
Group by location
order by TotalDeathCount desc

select date, SUM (new_cases), --(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
where continent is not null
Group by date
order by 1,2

select date,SUM(new_cases)as total_cases, SUM (cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercenetage
FROM PortfolioProject..CovidDeaths
--where location like '%Pakistan%'
where continent is not null
Group by date
order by 1,2

with PopvsVac(continent,location,date,population,New_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,	SUM(Cast( vac.new_vaccinations as int)) OVER(Partition by dea.location Order By dea.location,dea.date)
as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   On dea.location=vac.location
   and dea.date=vac.date
   where dea.continent is not null
  -- order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100
From PopvsVac
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,	SUM(Cast( vac.new_vaccinations as int)) OVER(Partition by dea.location Order By dea.location,dea.date)
as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   On dea.location=vac.location
   and dea.date=vac.date
  -- where dea.continent is not null
  -- order by 2,3

Select *,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,	SUM(Cast( vac.new_vaccinations as int)) OVER(Partition by dea.location Order By dea.location,dea.date)
as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   On dea.location=vac.location
   and dea.date=vac.date
   where dea.continent is not null
  -- order by 2,3

  select*
  From PercentPopulationVaccinated