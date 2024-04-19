
-- DATA ANALYSIS OF CYCLISTIC BIKE SHARE(2023)

-- Case study 1 from the Google Data Analytics Professional Certification Course
----------------------------------------------------------------------------
-- DATA DESCRIPTION
-- Data sets consist of 13 columns, and the data type and explanation of each field are listed below.
	--ride_id: string, 
    --rideable_type: string
    --started_at: date-time, starting time of the ride data format is YYYY-MM-DD HH:MM:SS
    --ended_at:	date-time, ending time of the ride data format is YYYY-MM-DD HH:MM:SS
    --start_station_name: string, station where the bike trip started
    --start_station_id: string, id of the station where the bike trip started
    --end_station_name: string, station where the bike trip ended
    --end_station_id: string, id of the station where the bike trip ended
    --start_lat: float, this include latitude of starting station, measures how far north or south a location is from the equator
    --start_lng: float, this include longitude  of starting station,measures how far east or west a location is from the Prime Meridian, both latitude and longitude data use to identfy location of the station on map
    --end_lat: float, this include Latitude of ending station,
    --end_lng:float,  this include longitude  of ending station
    --member_casual, string, indicate two categories of bike user: annual members and casual riders 
  
--STEP 1: Import Data
-----------------------------------------------------------------------------
	-- All riding data for 2023 is divided by month, 12 excel data tables imported manually, 

----------------------------------------------------------------------------
--STEP 2:REDUCE DATA AND COMBINE INTO A SINGLE FILE
-----------------------------------------------------------------------------

-- There are inconsistencies in some data types between datasets, so all data must be converted to the same type before they can be combined into a large data file
ALTER TABLE trips_2023_03
ALTER COLUMN start_station_id NVARCHAR(255)

ALTER TABLE trips_2023_05
ALTER COLUMN start_station_id NVARCHAR(255)
ALTER TABLE trips_2023_05
ALTER COLUMN end_station_id NVARCHAR(255)



--Stack individual data sets into one big data set

Select* into Cyclistic_Bike_trips_23
From trips_2023_01 Union All
Select* From trips_2023_02 Union All
Select* From trips_2023_03 Union All
Select* From trips_2023_04 Union All
Select* From trips_2023_05 Union All
Select* From trips_2023_06 Union All
Select* From trips_2023_07 Union All
Select* From trips_2023_08 Union All
Select* From trips_2023_09 Union All
Select* From trips_2023_10 Union All
Select* From trips_2023_11 Union All
Select* From trips_2023_12

select count(1)
from Cyclistic_Bike_trips_23 -- 5.719.877 raw in total
----------------------------------------------------------------------------
--STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
-----------------------------------------------------------------------------

--# Add columns that list the date, month, day, and year of each ride  This will allow us to aggregate ride data for each month, day, or year 
--Add a "ride_length" calculation to all_trips (in seconds)

Alter table Cyclistic_Bike_trips_23
Add ride_length_min float,ride_length_hour float,ride_length_sec float, ride_hour nvarchar(255), ride_day nvarchar(255),ride_month nvarchar(255), ride_year nvarchar(255)

Update Cyclistic_Bike_trips_23
Set ride_length_sec = DATEDIFF(second, started_at, ended_at),
	ride_length_min = DATEDIFF(minute, started_at, ended_at),
	ride_length_hour = DATEDIFF(hour, started_at, ended_at),
	ride_hour = datename(hour, started_at),
	ride_day = datename(W, started_at),
	ride_month = datename(M, started_at),
	ride_year = Year(started_at);



-- Remove "bad" data The dataframe includes a few hundred entries when bikes were taken out of docks and
--checked for quality by Divvy or ride_length was negative
--- 

select*  
into Cyclistic_Bike_trips_23_clean
from (select* 
	  from (select* 
			from (select* from Cyclistic_Bike_trips_23 where end_station_name is not null and end_station_id is not null) a
			where a.start_station_name is not null and a.start_station_id is not null) b 
	  where b.ride_length_sec >= 0) as c
where c.start_station_name != 'HQ QR'


----Added new columns for number of day, number of month (so we can sort the data by day and month )
Alter table Cyclistic_Bike_trips_23_clean
Add day_nr int, month_nr int

Update Cyclistic_Bike_trips_23_clean
Set day_nr = case ride_day
	  when 'Monday' then 1
	  when 'Tuesday' then 2
	  when 'Wednesday' then 3
	  when 'Thursday' then 4
	  when 'Friday' then 5
	  when 'Saturday' then 6
	  when 'Sunday' then 7
	  end , 
	  month_nr = case ride_month
	  when 'January' then 1
	  when 'February' then 2
	  when 'March' then 3
	  when 'April' then 4
	  when 'May' then 5
	  when 'June' then 6
	  when 'July' then 7
	  when 'August' then 8
	  when 'September' then 9
	  when 'October' then 10
	  when 'November' then 11
	  when 'December' then 12
	  end

----rename the columns member_casual to usertype and rideable_type to biketype
sp_rename 'Cyclistic_Bike_trips_23_clean.[member_casual]', 'usertype', 'COLUMN';
sp_rename 'Cyclistic_Bike_trips_23_clean.[rideable_type]', 'biketype', 'COLUMN';
----------------------------------------------------------------------------
--STEP 4:  CONDUCT ANALYSIS
-----------------------------------------------------------------------------
-- Summary table

select 'total',sum(ride_length_min) as ride_duration_minutes from Cyclistic_Bike_trips_23_clean
union
select 'average', avg(ride_length_min) from Cyclistic_Bike_trips_23_clean
union
select 'min', min(ride_length_min) from Cyclistic_Bike_trips_23_clean
union
select 'max', max(ride_length_min) from Cyclistic_Bike_trips_23_clean


-- Members vs Casual users

Select usertype, sum(ride_length_min) as total_ride_duration, AVG(ride_length_min) as avg_ride_duration, Min(ride_length_min) min_ride_duration, Max(ride_length_min) max_ride_duration 
from Cyclistic_Bike_trips_23_clean
Group by usertype

-- The average ride time by day for members vs casual users

Select  usertype, ride_day,day_nr, AVG(ride_length_min) as avg_ride_duration
from Cyclistic_Bike_trips_23_clean
group by usertype, ride_day, day_nr 
order by day_nr, usertype

-- Number of Rides by usertype and days

Select  usertype, ride_day, day_nr, AVG(ride_length_min) as avg_ride_duration, count(1) as num_ride
from Cyclistic_Bike_trips_23_clean
group by usertype, ride_day,day_nr
order by usertype, day_nr


-- hourly ride by usertype

Select usertype, convert(int, ride_hour) as ride_hour, AVG(ride_length_min) as avg_ride_duration, count(1) as num_of_ride
from Cyclistic_Bike_trips_23_clean
group by usertype,ride_hour
order by usertype,num_of_ride Desc


--  rides by usertype in week
Select usertype, ride_day, AVG(ride_length_min) as avg_ride_duration, count(1) as num_of_ride
from Cyclistic_Bike_trips_23_clean
group by usertype, ride_day, day_nr
order by usertype, day_nr

----  duration and number of ride by usertype and months

select usertype, ride_month, ride_year, AVG(ride_length_min) as avg_ride_duration, count(1) as num_of_ride
from Cyclistic_Bike_trips_23_clean
Group by usertype, ride_month, month_nr, ride_year
order by usertype, month_nr


---percentage of ride and average duration by usertype and biketype
select usertype, biketype, AVG(ride_length_min) as avg_ride_duration, round(count(*)*100.0 /sum(count(*)) over(), 4) as num_of_ride
from Cyclistic_Bike_trips_23_clean_x
--where usertype = 'casual' --'member' -- can also check separatly for each user type
group by usertype, biketype
order by usertype, biketype

---percentage of ride by usertype and biketype through the year
select usertype, biketype, ride_month, AVG(ride_length_min) as avg_ride_duration, count(*) as num_of_ride
from Cyclistic_Bike_trips_23_clean_x
where usertype = 'casual' --'casual' --'member' -- can also check separatly for each user type
group by usertype, biketype, ride_month,month_nr
order by usertype, biketype, month_nr

----  Top 10 stations from start
select top (10) usertype, start_station_name, count(1) as num_of_ride
from Cyclistic_Bike_trips_23_clean
where usertype = 'Casual'
Group by usertype, start_station_name
order by usertype, num_of_ride desc

select top (10) usertype, start_station_name, count(1) as num_of_ride
from Cyclistic_Bike_trips_23_clean
where usertype = 'Member'
Group by usertype, start_station_name
order by usertype, num_of_ride desc


--Most frequently used routes (starting and arriving) by usertype 

Alter table Cyclistic_Bike_trips_23_clean
Add station_start_end nvarchar(255)

Update Cyclistic_Bike_trips_23_clean
set station_start_end= concat(start_station_id, end_station_id)

Select distinct station_start_end   
from (select start_station_id, end_station_id, station_start_end
				 from Cyclistic_Bike_trips_23_clean) a

select top(20) start_station_name, end_station_name,usertype, count(1) as numb
from (select* from Cyclistic_Bike_trips_23_clean where end_station_name is not null and end_station_id is not null) a
where usertype = 'casual'
Group by a.start_station_name, a.end_station_name,usertype, a.station_start_end
order by numb desc

select top(20)start_station_name, end_station_name,usertype, count(1) as numb
from (select* from Cyclistic_Bike_trips_23_clean where end_station_name is not null and end_station_id is not null) a
where usertype = 'member'
Group by a.start_station_name, a.end_station_name,usertype, a.station_start_end
order by numb desc

--Most frequently used routes (starting and arriving) accourding to weekday and bussines hour

select top(20) start_station_name, end_station_name,usertype, count(1) as numb
from (select* from Cyclistic_Bike_trips_23_clean_x where month_nr between 6 and 9 and day_nr between 1 and 5) a
where usertype = 'member' 
Group by a.start_station_name, a.end_station_name,usertype, a.station_start_end
order by numb desc

select top(20) start_station_name, end_station_name,usertype, count(1) as numb
from (select* from Cyclistic_Bike_trips_23_clean_x where month_nr between 6 and 9 and day_nr between 1 and 5) a
where usertype = 'casual' 
Group by a.start_station_name, a.end_station_name,usertype, a.station_start_end
order by numb desc

