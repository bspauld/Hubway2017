/*
	Script:  OriginsbyMonth_Hubway2016.sql
	Purpose: Script to generate table that stores the origins by day for each hubway station
		 for 2016
	
		 To improve visualization, a case statement bins the origin totals.
	Date: 	 March 2017

*/

drop table public.originsbymonth_2016;
create table public.originsbymonth_2016
(
	MonthTEXT varchar(25),
	DayTEXT varchar(25),
	DayofYear int,
	Station varchar(255),
	TotalStarts int,
	StartCat int
);


--Add start station Geometry Column
SELECT AddGeometryColumn ('public','originsbymonth_2016','geom',4326,'MULTIPOINT',2);


insert into public.originsbymonth_2016
select  to_char(cast(a.starttime as date), 'MONTH') as MonthTEXT,
	to_char(cast(a.starttime as date), 'DAY') as DayTEXT,
	extract(doy from a.starttime) as DayofYear,
	s.Station,
	count(*) as TotalStarts,
	case 
		when count(*) = 0 then 0
		when count(*) between 1 and 10 then 1
		when count(*) between 11 and 25 then 2
		when count(*) between 26 and 50 then 3
		when count(*) between 51 and 75 then 4
		when count(*) between 76 and 100 then 5
		when count(*) between 101 and 150 then 6
		when count(*) >150 then 7
		else 0
	end as StartCat,
	ST_Collect(s.geom) as geom
from public.hubway_alltips_2016 a
	inner join public.hubway_stations s on a.es_name = s.station
group by to_char(cast(a.starttime as date), 'MONTH'),
	 to_char(cast(a.starttime as date), 'DAY'),
	 extract(doy from a.starttime),
	 s.station
	 
order by extract(doy from a.starttime), 
	 s.Station;
