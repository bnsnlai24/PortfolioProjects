select*
from c19..CovidDeaths$
order by 3,4

--select*
--from c19..CovidVaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from c19..CovidDeaths$
order by 1,2

-- Looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from c19..CovidDeaths$
where location like '%states%'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as percentpopulationinfected
from c19..CovidDeaths$
where location like '%states%'
order by 1,2


-- looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as highestinfectioncount, max(total_cases/population)*100 as percentpopulationinfected
from c19..CovidDeaths$
--where location like '%states%'
group by location, population
order by percentpopulationinfected desc


-- showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as totaldeathcount
from c19..CovidDeaths$
where continent is not null
--where location like '%states%'
group by location
order by totaldeathcount desc

-- break things down by continent

select continent, max(cast(total_deaths as int)) as totaldeathcount
from c19..CovidDeaths$
where continent is not null
--where location like '%states%'
group by continent
order by totaldeathcount desc

-- showing continents with the highest death count per population

select location, max(cast(total_deaths as int)) as totaldeathcount
from c19..CovidDeaths$
where continent is not null
--where location like '%states%'
group by location
order by totaldeathcount desc


-- global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from c19..CovidDeaths$
where continent is not null
--group by date
order by 1,2


-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from c19..CovidDeaths$ dea
join c19..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from c19..CovidDeaths$ dea
join c19..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)

select *, (rollingpeoplevaccinated/population)*100
from PopvsVac
