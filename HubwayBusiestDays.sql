/*
  Top 10 Busiest Day of the year - origins
  
  	Date, Number of Starts
  	"2016-08-09";6949
	"2016-07-19";6905
	"2016-09-13";6870
	"2016-07-20";6858
	"2016-09-15";6785
	"2016-08-03";6713
	"2016-06-23";6676
	"2016-09-22";6659
	"2016-09-21";6659
	"2016-07-12";6617


  
 
*/ 

select  cast(a.starttime as date) as DateVal,
	count(*) as TotalUses
from public.hubway_alltips_2016 a
group by cast(a.starttime as date)
order by count(*) desc
limit 10;


/*
  Top 10 Busiest Day of the year - destinations
  
 	Date, Number of Stops
	"2016-08-09";6947
	"2016-07-19";6901
	"2016-09-13";6875
	"2016-07-20";6868
	"2016-09-15";6784
	"2016-08-03";6700
	"2016-06-23";6675
	"2016-09-22";6657
	"2016-09-21";6653
	"2016-07-12";6611


  
*/
select  cast(a.stoptime as date) as DateVal,
	count(*) as TotalUses
from public.hubway_alltips_2016 a
group by cast(a.stoptime as date)
order by count(*) desc
limit 10;
