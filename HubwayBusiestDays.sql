/*
  Top 10 Busiest Day of the year - origins
  
  Date, Number of Starts
  "2016-08-09";6932
  "2016-07-19";6880
  "2016-09-13";6861
  "2016-07-20";6838
  "2016-09-15";6768
  "2016-08-03";6685
  "2016-06-23";6657
  "2016-09-21";6642
  "2016-09-22";6641
  "2016-07-12";6595

  
 
*/ 

select  cast(a.starttime as date) as DateVal,
	count(*) as TotalUses
from public.hubway_alltips_2016 a
group by cast(a.starttime as date),
	 extract(doy from a.stoptime)
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
group by cast(a.stoptime as date),
	 extract(doy from a.stoptime)
order by count(*) desc
limit 10;
