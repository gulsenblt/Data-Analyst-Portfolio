	
<h2>CYCLISTIC BIKE-SHARE DATA EXPLORATION</h2>

**Author:** Gülsen Balta **Date:** 17-04-2023

<h4>Background information</h4>

This project is based on a case study from the Google Data Analytics Professional Certification Course. The case study focuses on Cyclistic, a bike-share company in Chicago. There are two categories of bike users: annual members and casual riders.  Casual rider are customers who purchase single-ride or full-day passes, while members are those who purchase annual memberships. The marketing director thinks the company should focus on getting more yearly members to grow.  The analyst team wants to understand how yearly members and casual riders use their bikes differently, so this will help the company make a new marketing plan. The goal of this project is to analyze the usage pattern of casual and annual members.

**Business question:** How do annual members and casual rider s use Cyclistic differently?

**Data Sourse:** This project used Cyclist's historical trip data from January 2023 to December 2023 tripdata. The data has been made available by Motivate International [Inc](https://divvy-tripdata.s3.amazonaws.com/index.html). under this [license](https://divvybikes.com/data-license-agreement). The data had been cleared of riders’ personally identifiable information for privacy concerns.


<h4>Tools Used:</h4>

SQL to process and clean data for further analysis ([code](https://github.com/gulsenblt/Data-Analyst-Portfolio/blob/1fa3131f9afc97ec134a2ff804d75025184317e3/Cyclistic%20bike-share/SQL%20data%20wrangling.sql))


Tableau to visualize data (click [here](https://public.tableau.com/views/CyclisticBikeShare_17131724330590/Dashboard1?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link) for interactive dashboard to see analysis result)

<h4>Summary of findings</h4>

<p>•	The average trip duration was 16 minutes, with a total duration of 1,022,919 hours. Annual members made up 64% of the entire rides. Summer is the peak season for cycling, with the highest rides taking place in August.</p>
<p>•	Compared to annual members, casual user trips typically last longer. Average cycling duration for members is 12 minutes, compared to 23 minutes for casual riders.</p>
<p>•	While casual members travelled more on weekends, annual members travelled more during the week.</p>
<p>•	During weekdays, the number of rides by members is highest in the morning (6, 7, 8 a.m.) and evening (4, 5, 6 p.m.). However, the number of rides by casual users increases during the day and starts to decrease in the late afternoon. Both user groups have similar weekend bike usage patterns, with a high number of trips made during the day, between 12:00 and 17:00.</p>
<p>•	 Both user categories indicate similar tendencies throughout the course of the year. For example, cycling trips increase greatly in the summer, accounting for 57% of all trips, from June to September.</p> 
<p>•	We examined where the trips began and ended. Commonly, casual users begin and end their trip near parks, museums, stadiums, or ports; member riders, on the other hand, typically start and end their trips near residential areas, schools, stations, or universities.</p>
<p>•	Both user categories have similar usage rate for electric and traditional bicycles, with 37% of casual riders and 36% of annual member using electric bike. Over the course of the year, members' overall usage of the two types of bicycles varied little, but for casual customers, the percentage of electric bike use increased during the winter and overtook that of classic bike use in March and April.</p>
<p>•	Moreover, when we examine the most frequently used route (from start to finish) for the two types of users, casual customers usually start and finish their journey at the same station, while members' trips usually start and end at different stations. We observe that the routes with the reversed starting and finishing stations are the ones that are most frequently taken. (For example, starting station A and ending station B was the most frequent route; starting station B and ending station was the second most frequent route). Members in this pattern can be seen cycling between fixed locations, like home and work or school.</p>

<h4>Conclusion can be drawn from analysis of data</h4>
 
1.	After examining the usage patterns of Cyclistic's two rider types—casual and annual members—we may infer that members are likely Chicago residents who travel by bicycle to work, school, or universities. This conclusion is based on the following analysis findings:
	<p>•	Increased Member cycling during typical business hours and weekdays.</p>
	<p>•	Members' most frequent trips are between the same stations, considering their starting and destination locations.</p>
2.	Most casual riders are either visitors or locals who ride bicycles for fun. The following results confirm this assumption:
	<p>•	An increase in daily trips on weekends and in the afternoon.</p> 
	<p>•	On weekends, both user categories displayed similar riding patterns.</p> 
	<p>•	Casual users spend more time cycling than annual members.</p>
3.	For both user types, cycling rates vary with season, perhaps because summer is peak tourism season and people prefer to ride bicycles in the warmer months.
	<p>•	Half of the total trips in a year were made during the summer season (June to September), this could be due to warmer weather.</p>
	<p>•	The number of trips made by casual users increases throughout the summer months, likely due to the tourist season.</p>

<h4>Recommendations</h4>

1.	Because the goal of a marketing strategy is to convert more casual customers into members, marketing efforts should first target casual travellers who are not tourists, as these are the potential customers who will purchase memberships. These consumers could be residents who don't work or don't want to bike to work or school.
2.	Various subscription options, such a seasonal pass or a cheaper membership for off-peak hours or the weekend, can be offered since rcasual users ride the bike more on weekends, after business hours, and during the summer. This might attract more customers to purchase memberships. 
3.	As casual users tend to ride for longer periods of time and use electric bikes more frequently in the winter and early spring, marketing strategists can take attention of this trend and create a subscription plan specifically for electric bikes in order attract in more casual riders buy subscription.

  
