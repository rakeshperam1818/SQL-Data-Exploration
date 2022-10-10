--Selecting all the data from the table covidDeaths

select * from CovidDeaths$

--Selecting all the data from the table covidvaccinations

--select * from CovidVaccinations$

--selecting data from table that we are using

select location,date,population,total_cases,new_cases,total_deaths
from PortfolioProject1..CovidDeaths$
order by 1,2

--looking into the data total_cases vs total_deaths

select location,date,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths$
where total_deaths is not null
order by 1,2

--looking into the data total_cases vs total_deaths in US

select location,date,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths$
where location like '%states%' and total_deaths is not null
order by 1,2

--looking into the data total_cases vs population in US

select location,date,population,total_cases,(total_cases/population)*100 as Effectedpercentage
from PortfolioProject1..CovidDeaths$
where location like '%states%' and population is not null
order by 1,2

--looking at highest infectection rate in a country as per population	

select location,population,MAX(total_cases) as Infectionratecount,MAX((total_cases/population))*100 as Infectedpercentage
from PortfolioProject1..CovidDeaths$
group by location,population
order by Infectedpercentage desc

--showing countries with highest death count as per population

select location,MAX(cast(total_deaths as int)) as deathratecount
from PortfolioProject1..CovidDeaths$
where continent is not null
group by location
order by deathratecount desc

select location,MAX(cast(total_deaths as int)) as deathratecount
from PortfolioProject1..CovidDeaths$
where continent is null
group by location
order by deathratecount desc

--Global Numbers

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths$
where continent  is not null
--group by date
order by 1,2

--Looking into another table called Covidvaccinations

select * from PortfolioProject1..CovidVaccinations$

--Joining two tables together

select *
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vacc
on dea.location = vacc.location
and dea.date = vacc.date

--lokking at the total_population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeople_vaccination
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vacc
on dea.location = vacc.location
and dea.date = vacc.date
where dea.continent is not null
order by 2,3

--Shows Percentage of Population that has recieved at least one Covid Vaccine using CTE based on last query

with popvsvacc (continent,location,date,population,new_vaccinations,Rollingpeople_vaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeople_vaccination
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vacc
on dea.location = vacc.location
and dea.date = vacc.date
where dea.continent is not null
--order by 2,3
)
select * , (Rollingpeople_vaccination/population)*100 as rollingpeoplepercentage
from popvsvacc

--Temp Table

create table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeople_vaccination numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeople_vaccination
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vacc
on dea.location = vacc.location
and dea.date = vacc.date
where dea.continent is not null
--order by 2,3


select * , (Rollingpeople_vaccination/population)*100 as rollingpeoplepercentage
from #percentpopulationvaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeople_Vaccination
--, (Rollingpeople_vaccination/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null 


select * 
from #percentpopulationvaccinated



