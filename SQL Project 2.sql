select * from Portfolioproject2..Data1

select * from Portfolioproject2..Data2

--count of rows in a table

select COUNT(*)
from Portfolioproject2..Data1

select COUNT(*)
from Portfolioproject2..Data2

--selecting data only for 'Andhra Pradesh' and 'Karnataka'

select *
from Portfolioproject2..Data1
where State in ('Andhra Pradesh' , 'Karnataka')
order by District

--Knowing about total population of India using Data2

select SUM(population) as total_population from Portfolioproject2..Data2 

---Average Growth in India

select AVG(growth)*100 as Avg_Growth from Portfolioproject2..Data1

--Average growth percentage in India showing by state

select State,AVG(growth)*100 as Avg_Growth from Portfolioproject2..Data1
group by State

--Average Sex Ratio by State

select State,AVG(Sex_Ratio) as Avg_Sex_Ratio from Portfolioproject2..Data1
group by State order by Avg_Sex_Ratio desc

--Average Literacy by State using Having

select State,AVG(Literacy) as Avg_Literacy from Portfolioproject2..Data1
group by State having AVG(Literacy) > 85 order by Avg_Literacy desc 

--Pulling top 3 in data with avg growth percentage

select top 3 State,AVG(growth)*100 as Avg_Growth from Portfolioproject2..Data1
group by State order by Avg_Growth desc

select State,AVG(growth)*100 as Avg_Growth from Portfolioproject2..Data1
group by State order by Avg_Growth desc limit 3;

--Pulling bottom 3 in data with avg growth percentage


select top 3 State,AVG(growth)*100 as Avg_Growth from Portfolioproject2..Data1
group by State order by Avg_Growth asc

---Selecting top 3 and bottom 3 states from data

Drop table #topstates
Create table #topstates
(state nvarchar(255),
 topstate float

)

insert into #topstates
select State,AVG(Literacy) as Avg_Literacy from Portfolioproject2..Data1
group by State order by Avg_Literacy desc;

select * from #topstates order by #topstates.topstate desc

Create table #bottomstates
(state nvarchar(255),
bottomstate float

)

insert into #bottomstates
select State,AVG(Literacy) as Avg_Literacy from Portfolioproject2..Data1
group by State order by Avg_Literacy asc;

select  top 3 * from #bottomstates order by #bottomstates.bottomstate asc

----Combining two table together using UNION

select * from (select top 3 * from #topstates order by #topstates.topstate desc) a

union

select * from (select top 3 * from #bottomstates order by #bottomstates.bottomstate asc) b

--- Filtering the data where State name starts with Letter 'A'

select distinct(State)
from Portfolioproject2..Data1
where State like 'a%' or state like 'b%'


select distinct(State), SUM(Growth)
from Portfolioproject2..Data1
where State like 'a%'  and State like '%m'
group by State

--- Joining both tables

select a.District ,a.State,a.Sex_Ratio,b.Population
from PortfolioProject1..Data2$ as b
join Portfolioproject2..Data1 as a
on a.District = b.District

---Calculating Males and Females using Population

select d.state,sum(d.males) as totalmales,SUM(d.females) as totalfemales from 
(select  c.District,c.State,round(c.Population/(c.Sex_Ratio+1),0) as males,round((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) as females from 
(select a.District ,a.State,a.Sex_Ratio,b.Population
from PortfolioProject1..Data2$ b
join Portfolioproject2..Data1 a on a.District = b.District) c) d
group by d.State

---Calculating Literacy Rate and Illeterate people rate using Literacy Ratio

select d.State,sum(d.Literacy_Rate) ,sum(d.illeterate_people)  from
(select c.District,c.State,round((c.Literacy_Ratio*c.Population),0) as Literacy_Rate,round((1-c.Literacy_Ratio)*c.Population,0) as illeterate_people from
(select a.District,a.State,(a.Literacy/100) as Literacy_Ratio,b.Population
from Portfolioproject2..Data1 a
join PortfolioProject1..Data2$ b
on a.District = b.District) c) d
group by d.State


---Calculating sum for Previous census population and Current Census using current population

select d.State,SUM(d.previous_population) as TotalsumPreviousCensus,SUM(d.current_population) as totalcurrentcensus from
(select c.District,c.State,ROUND(c.Population/(1+c.Growth),0) as Previous_population,c.population as current_population from
(select a.District,a.State,a.Growth as Growth,b.Population
from Portfolioproject2..Data1 a
join PortfolioProject1..Data2$ b
on a.District = b.District) c) d
group by d.State

---Calculating AVG for Previous census population and Current Census using current population

select d.State,Avg(d.previous_population) as TotalsumPreviousCensus,avg(d.current_population) as totalcurrentcensus from
(select c.District,c.State,ROUND(c.Population/(1+c.Growth),0) as Previous_population,c.population as current_population from
(select a.District,a.State,a.Growth as Growth,b.Population
from Portfolioproject2..Data1 a
join PortfolioProject1..Data2$ b
on a.District = b.District) c) d
group by d.State

---Using Window Functions
select a.* from
(select District,State,Literacy, RANK() over (partition by state order by literacy desc) as Rank from Portfolioproject2..Data1) a
where a.Rank in (1,2,3)
order by a.State


