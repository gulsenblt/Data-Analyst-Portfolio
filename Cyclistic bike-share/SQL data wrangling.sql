--Exploratory analysis for data of a bike-share company in Chicago 
----------------------------------------------------------------------------
--STEP 1: Import Data
-----------------------------------------------------------------------------
	--Import 8 excel data tables  manually, which are Cyclistic’s historical trip data for 2018 and 2019
	-- We have 8 data sets for 2018 and 2019, each for a quarter of the year (Trips_18_Q1, Trips_18_Q2 ...., Trips_19_Q1, Trips_19_Q2...).

----------------------------------------------------------------------------
--STEP 2:REDUCE DATA AND COMBINE INTO A SINGLE FILE
-----------------------------------------------------------------------------
	--- Since the column names in the 2018_Q1 and 2019_Q2 are different from those in the other datasets, 
	----we rename the columns in these two datasets as in the others to ensure that all names are consistent
sp_rename 'Trips_18_Q1.[01 - Rental Details Rental ID]', 'trip_id', 'COLUMN';
Go
sp_rename 'Trips_18_Q1.[01 - Rental Details Bike ID]', 'bikeid', 'COLUMN';
Go
sp_rename 'Trips_18_Q1.[01 - Rental Details Local Start Time]', 'start_time', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[01 - Rental Details Local End Time]', 'end_time', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[01 - Rental Details Duration In Seconds Uncapped]', 'tripduration', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[03 - Rental Start Station Name]', 'from_station_name', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[03 - Rental Start Station ID]', 'from_station_id', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[02 - Rental End Station Name]', 'to_station_name', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[02 - Rental End Station ID]', 'to_station_id', 'COLUMN';
GO
sp_rename 'Trips_18_Q1.[User Type]', 'usertype', 'COLUMN';
GO



Select*
from Trips_18_Q1

--
sp_rename 'Trips_19_Q2.[01 - Rental Details Rental ID]', 'trip_id', 'COLUMN';
Go
sp_rename 'Trips_19_Q2.[01 - Rental Details Bike ID]', 'bikeid', 'COLUMN';
Go
sp_rename 'Trips_19_Q2.[01 - Rental Details Local Start Time]', 'start_time', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[01 - Rental Details Local End Time]', 'end_time', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[01 - Rental Details Duration In Seconds Uncapped]', 'tripduration', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[03 - Rental Start Station Name]', 'from_station_name', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[03 - Rental Start Station ID]', 'from_station_id', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[02 - Rental End Station Name]', 'to_station_name', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[02 - Rental End Station ID]', 'to_station_id', 'COLUMN';
GO
sp_rename 'Trips_19_Q2.[User Type]', 'usertype', 'COLUMN';
GO

Select*
from Trips_19_Q2

--Stack individual quarter's data frames into one big data frame

Create table Trips_18_19
(trip_id float, 
bikeid float, 
start_time datetime, 
end_time datetime, 
from_station_name NVARCHAR(255), 
from_station_id float, 
to_station_name NVARCHAR(255), 
to_station_id float, 
usertype NVARCHAR(255)
)


Insert into Trips_18_19
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_18_Q1
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_18_Q2
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_18_Q3
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_18_Q4
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_19_Q1
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_19_Q2
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_19_Q3
Union All
Select trip_id, bikeid, start_time, end_time, from_station_name, from_station_id, to_station_name, to_station_id, usertype
From Trips_19_Q4

----------------------------------------------------------------------------
--STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
-----------------------------------------------------------------------------


--# Add columns that list the date, month, day, and year of each ride  This will allow us to aggregate ride data for each month, day, or year 
--Add a "ride_length" calculation to all_trips (in seconds)

Alter table Trips_18_19
Add ride_length_min float,ride_length_hour float,ride_length_sec float, ride_hour nvarchar(255), ride_day nvarchar(255),ride_month nvarchar(255), ride_year nvarchar(255)

Update Trips_18_19
Set ride_length_sec = DATEDIFF(second, start_time, end_time),
	ride_length_min = DATEDIFF(minute, start_time, end_time),
	ride_length_hour = DATEDIFF(hour, start_time, end_time),
	ride_hour = datename(hour, start_time),
	ride_day = datename(W, start_time),
	ride_month = datename(M, start_time),
	ride_year = Year(start_time);

	

-- Remove "bad" data The dataframe includes a few hundred entries when bikes were taken out of docks and
--checked for quality by Divvy or ride_length was negative

select*  
into Trips_18_19_clean
from (select* from Trips_18_19 where ride_length_sec >= 0) as a
where a.from_station_name != 'HQ QR'

-- replace "Subscriber" with "member" and "Customer" with "casual"
Update Trips_18_19_clean
Set usertype = case
	when usertype = 'Subscriber' then 'Member'
	when usertype = 'Customer' then 'Casual'
	else usertype		
end



----Added new columns for number of day, number of month and rush hours (so we can sort the data by day and month (in sql) and compare by peak or off-peak hours.)
Alter table Trips_18_19_clean
Add day_nr int, month_nr int, rush_hour nvarchar(255)

Update Trips_18_19_clean
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
	  when 'October' then 10
	  when 'November' then 11
	  when 'December' then 12
	  end , 
	rush_hour = case
		when ride_day= 'Saturday' or ride_day= 'Sunday' Then 'Off_Peak'
	    when ride_day <> 'Saturday'  and ride_hour between 7 and 9 Then 'Peak'
		when ride_day <> 'Sunday'  and ride_hour between 7 and 9  Then 'Peak'
		when ride_day <> 'Saturday'  and ride_hour between 17 and 19 Then 'Peak'
		when ride_day <> 'Sunday'  and ride_hour between 17 and 19 Then 'Peak'
		else 'Off_Peak'
		end

		
----------------------------------------------------------------------------
--STEP 4:  CONDUCT ANALYSIS
-----------------------------------------------------------------------------
-- Summary table

select 'total',sum(ride_length_min) as ride_duration from Trips_18_19_clean
union
select 'average', avg(ride_length_min) from Trips_18_19_clean
union
select 'min', min(ride_length_min) from Trips_18_19_clean
union
select 'max', max(ride_length_min) from Trips_18_19_clean


-- Members vs Casual users

Select usertype, sum(ride_length_min) as total_ride_duration, AVG(ride_length_min) as avg_ride_duration, Min(ride_length_min) min_ride_duration, Max(ride_length_min) max_ride_duration 
from Trips_18_19_clean
Group by usertype

-- The average ride time by each day for members vs casual users

Select  usertype, ride_day,day_nr, AVG(ride_length_min) as avg_ride_duration
from Trips_18_19_clean
group by usertype, ride_day, day_nr 
order by day_nr, usertype

-- Number of Rides by usertype and days

Select  usertype, ride_day, day_nr, AVG(ride_length_min) as avg_ride_duration, count(1) as num_ride
from Trips_18_19_clean
group by usertype, ride_day,day_nr
order by day_nr, usertype


-- hourly ride by usertype

Select usertype, convert(int, ride_hour) as col_n, AVG(ride_length_min) as avg_ride_duration, count(1) as num_of_ride
from Trips_18_19_clean
group by usertype,ride_hour
order by usertype,num_of_ride Desc


-- analyze ridership data by usertype and peak time in week

Select usertype,rush_hour, AVG(ride_length_min) as avg_ride_duration, count(1) as num_of_ride
from Trips_18_19_clean
group by usertype,rush_hour
order by usertype, rush_hour

----  duration and num. of ride by usertype and months

select usertype, ride_month,month_nr, ride_year, AVG(ride_length_min) as avg_ride_duration, count(1) as num_of_ride
from Trips_18_19_clean
Group by usertype, ride_month, month_nr, ride_year
order by month_nr, usertype


----  Top 10 stations from start
select top (10) usertype, from_station_name, count(1) as num_of_ride
from Trips_18_19_clean
where usertype = 'Casual'
Group by usertype, from_station_name
order by usertype, num_of_ride desc

select top (10) usertype, from_station_name, count(1) as num_of_ride
from Trips_18_19_clean
where usertype = 'Member'
Group by usertype, from_station_name
order by usertype, num_of_ride desc

---- Long (>1 hour) and Short (<1 hour) trip by usertype
select usertype, count(1) as num_of_ride
from Trips_18_19_clean
where ride_length_hour <= 1
Group by usertype
order by usertype

select usertype, count(1) as num_of_ride
from Trips_18_19_clean
where ride_length_hour > 1
Group by usertype
order by usertype



