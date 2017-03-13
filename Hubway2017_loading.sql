/*

	Script: Hubway2017_loading.sql

	Purpose: Script to load Hubway's trip data csv files into PostgreSQL database.

	Script first creates staging tables to load each table into general VARCHAR columns

	Instructions: Read the comments in code for instructions. Script does not contain any index generation. I will get to that.
 	


	Raw Trip Data CSV format

	"tripduration",			int
	"starttime","			datetime
	stoptime",			datetime
	"start station id",		INT
	"start station name",		varchar(255)
	"start station latitude", 	decimal(16,10)
	"start station longitude", 	decimal(16,10)
	"end station id",		INT
	"end station name",		varchar(255)
	"end station latitude",		decimal(16,10)
	"end station longitude",	decimal(16,10)
	"bikeid",			int
	"usertype",			varchar(25)
	"birth year",			int
	"gender"			int

*/

--CREATE table - For 2016, just change the year in the file name
create table public.hubway_alltips_2015_staging(
	tripduration Varchar(50),
	starttime Varchar(50),
	stoptime Varchar(50),
	ss_id varchar(15),
	ss_name varchar(255),
	ss_lat varchar(25),
	ss_lon varchar(25),
	es_id varchar(15),
	es_name varchar(255),
	es_lat varchar(25),
	es_lon varchar(25),	
	bikeid varchar(15),
	usertype varchar(15),
	birthyear varchar(15),
	gender varchar(10)
	);


--insert data from text file - 2015 example - for 2016 data, just update the table name and file paths for each month
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201501-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201502-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201503-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'CPATH TO FILE\201504-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201505-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201506-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201507-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201508-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201509-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201510-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'PATH TO FILE\201511-hubway-tripdata.csv' DELIMITER ',' CSV Header;
Copy public.hubway_alltips_2015_staging
from 'CPATH TO FILE\201512-hubway-tripdata.csv' DELIMITER ',' CSV Header;


-- Clean up \N values  - Values found by find distinct values in seperate process for each column - what doesn't make sense?
--2015
update public.hubway_alltips_2015_staging
set es_id = NULL
where es_id = '\N';

update public.hubway_alltips_2015_staging
set es_name = NULL
where es_name = '\N';

update public.hubway_alltips_2015_staging
set es_lat = NULL
where es_lat = '\N';

update public.hubway_alltips_2015_staging
set es_lon = NULL
where es_lon = '\N';

update public.hubway_alltips_2015_staging
set birthyear = NULL
where birthyear = '\N';

update public.hubway_alltips_2015_staging
set gender = NULL
where gender = '\N';

--2016 - Columns with \N value
update public.hubway_alltips_2016_staging
set birthyear = NULL
where birthyear = '\N';

update public.hubway_alltips_2016_staging
set gender = NULL
where gender = '\N';

--With staging tables cleas, load station data table into Postgres from staging table

--2015 Data
insert into public.hubway_alltips_2015 
select cast(tripduration as int),
	cast(starttime as timestamp),
	cast(stoptime as timestamp),
	cast(ss_id as int),
	cast(ss_name as varchar(255)),
	cast(ss_lat as decimal(16,10)),
	cast(ss_lon as decimal(16,10)),
	cast(es_id as int),
	cast(es_name as varchar(255)),
	cast(es_lat as decimal(16,10)),
	cast(es_lon as decimal(16,10)),
	cast(bikeid as int),
	cast(usertype as varchar(15)),
	cast(birthyear as int),
	cast(gender as int)
from public.hubway_alltips_2015_staging;

--ADD ID Column
alter table public.hubway_alltips_2015
add column IDVal SERIAL;

--Add start station Geometry Column
SELECT AddGeometryColumn ('public','hubway_alltips_2016','ss_geom',4326,'POINT',2);

--Update geometry column from lat and lon fields - start station
Update public.hubway_alltips_2015 set ss_geom = ST_SetSRID(ST_MakePoint(ss_lon, ss_lat),4326);

--Update geometry column from lat and lon fields - end station
Update public.hubway_alltips_2015 set ss_geom = ST_SetSRID(ST_MakePoint(es_lon, es_lat),4326);


--2016 Data
insert into public.hubway_alltips_2016 
select cast(tripduration as int),
	cast(starttime as timestamp),
	cast(stoptime as timestamp),
	cast(ss_id as int),
	cast(ss_name as varchar(255)),
	cast(ss_lat as decimal(16,10)),
	cast(ss_lon as decimal(16,10)),
	cast(es_id as int),
	cast(es_name as varchar(255)),
	cast(es_lat as decimal(16,10)),
	cast(es_lon as decimal(16,10)),
	cast(bikeid as int),
	cast(usertype as varchar(15)),
	cast(birthyear as int),
	cast(gender as int)
from public.hubway_alltips_2016_staging;

--Add ID Column
alter table public.hubway_alltips_2016
add column IDVal SERIAL;

--Add end station Geometry Column
SELECT AddGeometryColumn ('public','hubway_alltips_2016','es_geom',4326,'POINT',2);

--Update geometry column from lat and lon fields - start station
Update public.hubway_alltips_2016 set ss_geom = ST_SetSRID(ST_MakePoint(ss_lon, ss_lat),4326);

--Update geometry column from lat and lon fields - end station
Update public.hubway_alltips_2016 set ss_geom = ST_SetSRID(ST_MakePoint(es_lon, es_lat),4326);


--Load the station data
--Create table
create table public.hubway_stations_staging
(
	Station varchar(255),
	StationID varchar(255),
	Latitude varchar(255),
	Longitude varchar(255),
	Municipality varchar(255),
	NumofDocks varchar(255)
);

--Load data from CSV file
Copy public.hubway_stations_staging
from 'PATH TO FILE\Hubway_Stations_2011_2016.csv' DELIMITER ',' CSV Header;

--Check values in station table - repeat for all columns
--This is a clean dataset, but is good practices and will lead to fewer issues later on.

select distinct NumofDocks, count(*) 
from public.hubway_stations_staging
group by NumofDocks
order by NumofDocks;


--create final station table
create table public.hubway_stations
(
	Station varchar(255),
	StationID varchar(15),
	Latitude decimal(16,10),
	Longitude decimal(16,10),
	Municipality varchar(255),
	NumofDocks int
);

--Insert staging table into final table
insert into public.hubway_stations
select
	cast(Station as varchar(255)),
	cast(StationID as varchar(15)),
	cast(Latitude as decimal(16,10)),
	cast(Longitude as decimal(16,10)),
	cast(Municipality as varchar(255)),
	cast(NumofDocks as int)
from public.hubway_stations_staging;

--Add ID column
alter table public.hubway_stations
add column IDVal SERIAL;

--Add end station Geometry Column
SELECT AddGeometryColumn ('public','hubway_stations','geom',4326,'POINT',2);

--Update geometry column from lat and lon fields - start station
Update public.hubway_stations set geom = ST_SetSRID(ST_MakePoint(longitude, latitude),4326);
