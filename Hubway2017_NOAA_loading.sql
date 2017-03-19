/*


	Script: LoadNOAADaily.sql

	Purpose: Script to create table for Daily NOAA weather data and to load from CSV

	Online Data Documentation - https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/GHCND_documentation.pdf

	Observations

		PRCP -- Precipitation (mm or inches as per user preference, inches to hundredths on Daily Form pdf file)
		SNWD -- Snow depth (mm or inches as per user preference, inches on Daily Form pdf file)
		SNOW -- Snowfall (mm or inches as per user preference, inches to tenths on Daily Form pdf file)
		TAVG -- Average Temp
		TMAX -- Maximum temperature (Fahrenheit or Celsius as per user preference, Fahrenheit to tenths on Daily Form pdf file
		TMIN -- Minimum temperature
		AWND -- Average daily wind speed (meters per second or miles per hour as per user preference)
		WDF2 -- Direction of fastest 2-minute wind (degrees)
		WDF5 -- Direction of fastest 5-second wind (degrees)
		WSF2 -- Fastest 2-minute wind speed (miles per hour or meters per second as per user preference)
		WSF5 -- Fastest 5-second wind speed (miles per hour or meters per second as per user preference)
		PGTM -- Peak gust time (hours and minutes, i.e., HHMM)
		WT09 -- Weather Type where ** has one of the following values:  - 09 BLOWWING SNOW
		WT01 -- Fog, ice fog, or freezing fog (may include heavy fog)
		WT06 -- Glaze or rime 
		WT05 -- Hail (may include small hail)
		WT02 -- Heavy fog or heaving freezing fog (not always distinguished from fog)
		WT04 -- Ice pellets, sleet, snow pellets, or small hail 
		WT08 -- Smoke or haze
		WT03 -- Thunder

	MF - Measure Flag

		 Blank = no measurement information applicable
		 A = value in precipitation or snow is a multi-day total, accumulated since last measurement
		 (used on Daily Form pdf file)
		 B = precipitation total formed from two twelve-hour totals
		 D = precipitation total formed from four six-hour totals
		 H = represents highest or lowest hourly temperature (TMAX or TMIN)
		 or average of hourly values (TAVG)
		 K = converted from knots
		 L = temperature appears to be lagged with respect to reported
		 hour of observation
		 O = converted from oktas
		 P = identified as "missing presumed zero" in DSI 3200 and 3206
		 T = trace of precipitation, snowfall, or snow depth
		 W = converted from 16-point WBAN code (for wind direction)

	QF - Quality Flag

		 Blank = did not fail any quality assurance check
		 D = failed duplicate check
		 G = failed gap check
		 I = failed internal consistency check
		 K = failed streak/frequent-value check
		 L = failed check on length of multiday period
		 M = failed mega-consistency check
		 N = failed naught check
		 O = failed climatological outlier check
		 R = failed lagged range check
		 S = failed spatial consistency check
		 T = failed temporal consistency check
		 W = temperature too warm for snow
		 X = failed bounds check
		 Z = flagged as a result of an official Datzilla investigation 

	SF - Source Flag
		Blank = No source (i.e., data value missing)
		 0 = U.S. Cooperative Summary of the Day (NCDC DSI-3200)
		 6 = CDMP Cooperative Summary of the Day (NCDC DSI-3206)
		 7 = U.S. Cooperative Summary of the Day -- Transmitted
		 via WxCoder3 (NCDC DSI-3207)
		 A = U.S. Automated Surface Observing System (ASOS)
		 real-time data (since January 1, 2006)
		 a = Australian data from the Australian Bureau of Meteorology
		 B = U.S. ASOS data for October 2000-December 2005 (NCDC DSI-3211)
		 b = Belarus update
		 C = Environment Canada
		 E = European Climate Assessment and Dataset (Klein Tank et al., 2002)
		 F = U.S. Fort data
		 G = Official Global Climate Observing System (GCOS) or other government-supplied data
		 H = High Plains Regional Climate Center real-time data
		 I = International collection (non U.S. data received through personal contacts)
		 K = U.S. Cooperative Summary of the Day data digitized from paper observer forms
		 (from 2011 to present)
		 M = Monthly METAR Extract (additional ASOS data)
		 N = Community Collaborative Rain, Hail,and Snow (CoCoRaHS)
		 Q = Data from several African countries that had been "quarantined", that is, withheld from
		 public release until permission was granted from the respective meteorological services
		 R = NCDC Reference Network Database (Climate Reference Network
		 and Historical Climatology Network-Modernized)
		 r = All-Russian Research Institute of Hydrometeorological Information-World Data Center
		 S = Global Summary of the Day (NCDC DSI-9618)
		 NOTE: "S" values are derived from hourly synoptic reports
		 exchanged on the Global Telecommunications System (GTS).
		 Daily values derived in this fashion may differ significantly
		 from "true" daily data, particularly for precipitation(i.e., use with caution).
		 s = China Meteorological Administration/National Meteorological Information Center/
		 Climate Data Center (http://cdc.cma.gov.cn)
		 T = SNOwpack TELemtry (SNOTEL) data obtained from the Western Regional Climate Center
		 U = Remote Automatic Weather Station (RAWS) data obtained from the Western
		 Regional Climate Center
		 u = Ukraine update
		 W = WBAN/ASOS Summary of the Day from NCDC's Integrated Surface Data (ISD).
		 X = U.S. First-Order Summary of the Day (NCDC DSI-3210)
		 Z = Datzilla official additions or replacements
		 z = Uzbekistan update


	TO - Time of observation is the (2 digit hour, 2 digit minute) 24 hour clock time of the observation given as
		the local time at the station of record. 	


*/

create table public.NOAA_BostonDailyWeather_2016
(

	STATION varchar(17),
	STATION_NAME varchar(50),
	ELEVATION decimal(16,6),
	LATITUDE decimal(16,6),
	LONGITUDE decimal(16,6),
	DATEVal varchar(8),
	PRCP varchar(8),
	PRCP_MF varchar(4),
	PRCP_QF varchar(4),
	PRCP_SF varchar(4),
	PRCP_TO varchar(6),
	SNWD varchar(8),
	SNWD_MF varchar(4),
	SNWD_QF varchar(4),
	SNWD_SF varchar(4),
	SNWD_TO varchar(6),
	SNOW varchar(8),
	SNOW_MF varchar(4),
	SNOW_QF varchar(4),
	SNOW_SF varchar(4),
	SNOW_TO varchar(6),
	TAVG varchar(8),
	TAVG_MF varchar(4),
	TAVG_QF varchar(4),
	TAVG_SF varchar(4),
	TAVG_TO varchar(6),
	TMAX varchar(8),
	TMAX_MF varchar(4),
	TMAX_QF varchar(4),
	TMAX_SF varchar(4),
	TMAX_TO varchar(6),
	TMIN varchar(8),
	TMIN_MF varchar(4),
	TMIN_QF varchar(4),
	TMIN_SF varchar(4),
	TMIN_TO varchar(6),
	AWND varchar(8),
	AWND_MF varchar(4),
	AWND_QF varchar(4),
	AWND_SF varchar(4),
	AWND_TO varchar(6),
	WDF2 varchar(8),
	WDF2_MF varchar(4),
	WDF2_QF varchar(4),
	WDF2_SF varchar(4),
	WDF2_TO varchar(6),
	WDF5 varchar(8),
	WDF5_MF varchar(4),
	WDF5_QF varchar(4),
	WDF5_SF varchar(4),
	WDF5_TO varchar(6),
	WSF2 varchar(8),
	WSF2_MF varchar(4),
	WSF2_QF varchar(4),
	WSF2_SF varchar(4),
	WSF2_TO varchar(6),
	WSF5 varchar(8),
	WSF5_MF varchar(4),
	WSF5_QF varchar(4),
	WSF5_SF varchar(4),
	WSF5_TO varchar(6),
	PGTM varchar(8),
	PGTM_MF varchar(4),
	PGTM_QF varchar(4),
	PGTM_SF varchar(4),
	PGTM_TO varchar(6),
	WT09 varchar(8),
	WT09_MF varchar(4),
	WT09_QF varchar(4),
	WT09_SF varchar(4),
	WT09_TO varchar(6),
	WT01 varchar(8),
	WT01_MF varchar(4),
	WT01_QF varchar(4),
	WT01_SF varchar(4),
	WT01_TO varchar(6),
	WT06 varchar(8),
	WT06_MF varchar(4),
	WT06_QF varchar(4),
	WT06_SF varchar(4),
	WT06_TO varchar(6),
	WT05 varchar(8),
	WT05_MF varchar(4),
	WT05_QF varchar(4),
	WT05_SF varchar(4),
	WT05_TO varchar(6),
	WT02 varchar(8),
	WT02_MF varchar(4),
	WT02_QF varchar(4),
	WT02_SF varchar(4),
	WT02_TO varchar(6),
	WT04 varchar(8),
	WT04_MF varchar(4),
	WT04_QF varchar(4),
	WT04_SF varchar(4),
	WT04_TO varchar(6),
	WT08 varchar(8),
	WT08_MF varchar(4),
	WT08_QF varchar(4),
	WT08_SF varchar(4),
	WT08_TO varchar(6),
	WT03 varchar(8),
	WT03_MF varchar(4),
	WT03_QF varchar(4),
	WT03_SF varchar(4),
	WT03_TO varchar(6)
);

Copy public.NOAA_BostonDailyWeather_2016
from 'C:\Work\Projects\Hubway2017\OrgData\NOAAWeather\BostonDailyNOAAWeather.csv' DELIMITER ',' CSV Header;
