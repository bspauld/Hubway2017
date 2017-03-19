/********************************************************************************

	Script: ByDayAnalysis.sql
	Purpose: Series of scripts that perform analysis on day-by-day data


********************************************************************************/

--percent used by day for each station
--Start Station
select 
	cast(a.starttime as date) as DateVal,
	a.ss_name,
        s.numofdocks,
        count(*) as TotalStarts,
        cast(cast(count(*) as decimal(10,6))/cast(s.numofdocks as decimal(10,6))*100 as decimal(10,6)) as PercentUsed
from public.hubway_alltips_2016 a
	inner join public.hubway_stations s on a.ss_name = s.Station
group by cast(a.starttime as date),a.ss_name,s.numofdocks
order by cast(a.starttime as date),a.ss_name;

--End Station
select 
	cast(a.starttime as date) as DateVal,
	a.es_name,
        s.numofdocks,
        count(*) as TotalStarts,
        cast(cast(count(*) as decimal(10,6))/cast(s.numofdocks as decimal(10,6))*100 as decimal(10,6)) as PercentUsed
from public.hubway_alltips_2016 a
	inner join public.hubway_stations s on a.es_name = s.Station

group by cast(a.starttime as date),a.es_name,s.numofdocks
having cast(cast(count(*) as decimal(10,6))/cast(s.numofdocks as decimal(10,6))*100 as decimal(10,6)) > 100
order by cast(a.starttime as date),a.es_name;


--Per day total systemwide
drop table public.dailyStarts;
create table public.dailyStarts
(
 DateVal date,
 TotalStarts int
);
insert into public.dailyStarts
select 
	cast(a.starttime as date) as DateVal,
        count(*) as TotalStarts
from public.hubway_alltips_2016 a
group by cast(a.starttime as date)
order by cast(a.starttime as date);
