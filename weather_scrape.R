setwd("C:/Users/owenc/OneDrive/Desktop/melton_scholarship")

weather  = read.csv('2019_weather_data.csv')
# Scrapes data from weather dataframe

do_it_all <- function(dfname){
  dfname = remove_T(dfname)
  dfname = daily_stats(dfname)
  dfname = convert_time(dfname)
  return (dfname)
}
# Data scraping framework:
#   We want to be able to access our weather delays quickly

# Guide:
# 1. remove_T(df_name)
#     Converts 'T' in HourlyPrecipitation col to 0
#     Returns your data frame with edits

# 2. daily_stats(df_name, instance_of_SOD)
#     Build a dataframe of daily stats
#     Returns this new data frame

# 3. Converts date format to same as flight data format
#    Creates column for time of day

# 4. Creates HOURLY_SNOWFALL_INCHES column


# 1. Convert "T" and NA in HourlyPrecipitation to 0
#    T is "trace" amount of precipitation
#    Returns new data frame
remove_T <- function(weather, col_name){
  
  for (i in 1:nrow(weather)){
    if (weather[i, col_name] == 'T'){
      weather[i, col_name] = 0
    }
    if ( is.na(weather[i, col_name])){
      weather[i, col_name] = 0
    }
  }

  return (weather)
}

# 2. Build a dataframe of daily stats
#    df_name = name of data frame
#    instance_of_SOD = first instance where you see "SOD", the indicator of a daily report
#        Default is 46 b/c that's what it is in Chicago's df
daily_stats <- function(weather, instance_of_SOD = 46){
  #weather = read.csv( as.character(df_name) )
  level_for_dp  = weather[instance_of_SOD, "REPORT_TYPE"]
  daily_weather = subset(weather, REPORT_TYPE == level_for_dp)
  return (daily_weather)
}

weather_by_day = daily_stats(weather)
weather_by_day = convert_time(weather_by_day)

# Creating a snow column in weather
# Val: amount of precipitation if that was snow (less than 33 degrees F)

# 3. Converts date format to same as flight data format (yyyy-mm-dd)
#    Creates column for time of day (hhmm)

convert_time <- function(weather){
  #weather = read.csv( as.character(df_name) )
  time  = c()
  dates = weather[,"DATE"]
  d_chars = c()

  for (i in 1:length(dates)){
    date = dates[i]
    date = as.character(date)
  
    t    = substr(date, 12, (nchar(date) - 3))
  
    hour = substr(t, 1, 2)
    mins = substr(t, 4, 5)
  
    ti = paste(hour,mins,sep = "")
  
    time = c(time, paste(hour,mins,sep = ""))
  
    date = substr(date, 1, 10)
  
    d_chars = c(d_chars, date)
  }

  weather$DAY = d_chars
  weather$TIME = time

  return (weather)
}

# 4. Creates HOURLY_SNOWFALL_INCHES column

# Cars[Cars$cyl %in% c(4,6),]
# Gets all rows that meet the condition

#     Removes the 's' from the back of data in HourlyPrecipitation
for (i in 1:nrow(weather)){
  if (is.na(weather$HourlyPrecipitation[i])){
    weather$HourlyPrecipitation[i] =  0
    next
  }
  
  c_spot = as.character(weather$HourlyPrecipitation[i])

  if ((substr(c_spot,nchar(c_spot), nchar(c_spot))) == "s"){
    weather$HourlyPrecipitation[i] = substr(c_spot, 1, nchar(c_spot) - 1)
  }
}

#     Removes the 's' from the back of data in HourlyDryBulbTemperature
for (i in 1:nrow(weather)){
  if (is.na(weather$HourlyDryBulbTemperature[i])){
    weather$HourlyDryBulbTemperature[i] =  0
    next
  }
  
  c_spot = as.character(weather$HourlyDryBulbTemperature[i])
  
  if ((substr(c_spot,nchar(c_spot), nchar(c_spot))) == "s"){
    weather$HourlyDryBulbTemperature[i] = substr(c_spot, 1, nchar(c_spot) - 1)
  }
}

#        Actually creating the snow column after data is cleaned
snow = c()

for (i in 1:nrow(weather)){
  
  s4hour = as.character(weather$HourlyPrecipitation[i])
  s4hour = as.double(s4hour)
  
  t4hour = as.character(weather$HourlyDryBulbTemperature[i])
  if (t4hour == "" || is.na(t4hour)){
    snow[i] = 0
    next
  }
  t4hour = as.integer(t4hour)
  
  if (t4hour < 33){
    snow[i] = s4hour 
  }
  else {
    snow[i] = 0
  }
}

do_it_all <- function(dfname){
  dfname = remove_T(dfname)
  dfname = daily_stats(dfname)
  dfname = convert_time(dfname)
  return (dfname)
}





