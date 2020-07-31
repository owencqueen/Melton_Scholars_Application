# Melton Scholar Application
Application for Melton Scholarship in UTK Business Analytics and Statistics Department. <br/>
Owen Queen, email: owencqueen@hotmail.com <br/>
If you want to view the final report, see [melton_scholar_report.pdf](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/melton_scholar_report.pdf). </br>
To view the problem statement for this project, click [here](https://haslam.utk.edu/sites/default/files/AirplaneDelayMiniCase.pdf). 

**Note: I withdrew my application for this scholarship in May 2020 based on conflicts with other research schedules.**

## Running the code
To view and run the code I used to write my report, follow these steps:

1. Clone the Git repository onto your local machine, and make sure that all the data is included.
2. Make sure to comment out any areas  that set the working directory to my local directory.
3. Build the full year dataset that I used in my analysis by running build_year_data.R against all of the files in data_by_month. I do warn that this file takes a long time to build (it took my machine about an hour). You must call this dataset [year_flights.R](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/year_analysis.R).
4. Knit the file [airport_delay_minicase_writeup.Rmd](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/airport_delay_minicase_writeup.Rmd). This file will source all of the other files in the repo and run all of the graphs that I outputted in the report.

## Documentation (briefly):

#### 1. [by_month_data](https://github.com/owencqueen/Melton_Scholars_Application/tree/master/data_by_month)
- Monthly data of flights from transtats.bts.gov that was included in the writeup
 
#### 2. [2019_storm_data.csv](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/2019_storm_data.csv)
- Data on storm events in Cook County, IL (Chicago's county) </br>

#### 3. [2019_weather_data.csv](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/2019_weather_data.csv)
- Data on weather in Cook County, IL

#### 4. README.md
- This document

#### 5. [airport_delay_minicase_writeup.RMD](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/airport_delay_minicase_writeup.Rmd)
- R Markdown file that was used to create the docx (Word) version of the report.

#### 6. [airport_delay_minicase_writeup_final.docx](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/airport_delay_minicase_writeup_final.docx)
- Microsoft Word version of the final report.

#### 7. [build_year_data.R](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/build_year_data.R)
- Concatenates the data from every month into one giant dataframe 
- Dataframe consisted of 518 MB, far exceeding Github's 100 MB file limit 
- Changes some columns to satisfy conditions for using R's functions for dataframes.

#### 8. [five_func.R](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/five_func.R)
- One of my proudest data engineering accomplishments in this project
- Consists of two main functions that use a recursive procedure (specifically a technique called breadth-first search) to gather flights percolating out five flights from ORD (or any selected airport)
- Then concatenates them into one dataframe - The functions with the suffix "_rec.R" are the recursive functions that visit either arrivals or departures for a specified airport
- Returns a data frame of flight data for visited airports in the search \newline

#### 9. [melton_scholar_report.pdf](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/melton_scholar_report.pdf)
- PDF version of the final report.

#### 10. [storm_scrape.R](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/storm_scrape.R)
- Loads in the storm data set 
- Contains functions that tell you some basic properties about the data (needed for my analysis) 
- Made accessing this data set easier when I later needed to analyze specific events and when these events occurred\newline

#### 11. [weather_scrape.R](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/weather_scrape.R)
- Does some more menial work cleaning oddities in the weather data 
- Gathering daily weather data

#### 12. [year_analysis.R](https://github.com/owencqueen/Melton_Scholars_Application/blob/master/year_analysis.R)
- Driver program of the RMD file that produced the final report


