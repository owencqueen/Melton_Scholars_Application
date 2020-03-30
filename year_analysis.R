library(tidyverse)
library(ggplot2)
source(file = "weather_scrape.R")
source(file = "five_func.R")
source(file = "storm_scrape.R")
load(file = "year_flights.Rdata")
# Build Chicago datasets
ord_name      = 13930
ord_departs  = year_flights[year_flights$ORIGIN_AIRPORT_ID == ord_name,]  # Departures from ORD
ord_arrivals   = year_flights[year_flights$DEST_AIRPORT_ID == ord_name,]  # Arrivals to ORD

# Chicago arrivals delayed
ord_a_delayed = ord_arrivals[!is.na(ord_arrivals$WEATHER_DELAY),] 
ord_a_delayed = ord_a_delayed[ord_a_delayed$WEATHER_DELAY > 0, ]  
# Arrivals to ORD which are delayed

# Chicago departures delayed
ord_d_delayed = ord_departs[!is.na(ord_departs$WEATHER_DELAY),] 
ord_d_delayed = ord_d_delayed[ord_d_delayed$WEATHER_DELAY > 0, ]  
# Arrivals to ORD which are delayed

###################################################################

# Alterations to create weather_by_day dataframe
weather_by_day = daily_stats(weather)
weather_by_day = convert_time(weather_by_day)
weather_by_day = subset(weather_by_day, as.Date(weather_by_day$DAY) < as.Date("2019-12-01"))
weather_by_day = remove_T(weather_by_day, "DailySnowfall")
weather_by_day = remove_T(weather_by_day, "DailyPrecipitation")

# Changing data types of columns to analyze
weather_by_day$DailySnowfall = as.numeric( as.character(weather_by_day$DailySnowfall) )
weather_by_day$DailyPrecipitation = as.numeric( as.character(weather_by_day$DailyPrecipitation) )

###################################################################

# Creating vector for frequencies of delayed flights
freq_dates = table(unlist(as.Date(ord_d_delayed$FL_DATE)))
fd_df  = as.data.frame(freq_dates)
d_fd   = fd_df[,"Var1"]
all_dates = seq(as.Date("2019-01-01"), as.Date("2019-11-30"), by="days")

not_in_fd = subset(all_dates, !(all_dates %in% as.Date(d_fd)))
not_in_fd_df = as.data.frame(cbind(as.character(not_in_fd), Freq = rep(0, length(not_in_fd))))
not_in_fd_df  = not_in_fd_df %>% rename(Var1 = V1)
fd_df = rbind(fd_df, not_in_fd_df)

fd_df[,"Var1"] = fd_df[order(as.Date(fd_df[,"Var1"])),"Var1"]
of_interest_wbd_snow = weather_by_day$DailySnowfall[(as.Date(weather_by_day$DAY) < as.Date("2019-12-01"))]
of_interest_wbd_prec = weather_by_day$DailyPrecipitation[(as.Date(weather_by_day$DAY) < as.Date("2019-12-01"))]

plot(fd_df[,"Freq"] ~ of_interest_wbd_snow)
plot(fd_df[,"Freq"] ~ of_interest_wbd_prec)

plot(as.numeric(fd_df[,"Freq"]) ~ as.Date(fd_df[,"Var1"]))

###################################################################

# Frequency of weather delayed flights through the year
plot(freq_dates, xlab = "Date", ylab = "Number of delayed flights")

plot(ord_d_delayed$WEATHER_DELAY ~ as.Date(ord_d_delayed$FL_DATE), ylab = "Weather Delay Length (min)", xlab = "Date")

###################################################################

# Generate median values of delays for every day:

dates_delayed = as.character(d_fd)

median_delays = as.data.frame(x = seq(as.Date("2019-01-01"), as.Date("2019-11-30"), by = "day"))
median_delays = cbind(median_delays, Median_Delay = rep(0, nrow(median_delays)))
colnames(median_delays) = c("Date", "Median_Delay")
for (i in (1:length(all_dates))){
  if (as.character(all_dates[i]) %in% dates_delayed){
    median_delays[as.character(median_delays$Date) == as.character(all_dates[i]),"Median_Delay"] = as.numeric(median(ord_d_delayed$WEATHER_DELAY[as.character(ord_d_delayed$FL_DATE) == as.character(all_dates[i])]))
  }
  if (is.na(median_delays[as.character(median_delays$Date) == as.character(all_dates[i]),"Median_Delay"])) {
    median_delays[as.character(median_delays$Date) == as.character(all_dates[i]),"Median_Delay"] = 0
  }
}
median_delays = cbind(median_delays, Precipitation = rep(0, nrow(median_delays)))
median_delays = cbind(median_delays, Snow = rep(0, nrow(median_delays)))
for (i in (1:nrow(median_delays))){
  median_delays$Precipitation[i] = as.numeric(as.character(weather_by_day$DailyPrecipitation[weather_by_day$DAY == median_delays$Date[i]]))
  median_delays$Snow[i] = as.numeric(as.character(weather_by_day$DailySnowfall[weather_by_day$DAY == median_delays$Date[i]]))
  if (is.na(median_delays$Precipitation[i])){
    median_delays$Precipitation[i] = 0
  }
  if (is.na(median_delays$Snow[i])){
    median_delays$Snow[i] = 0
  }
}

# Linear models predicting delay from precipitation and snow
model_d_v_prec = lm(median_delays$Median_Delay ~ median_delays$Precipitation)
model_d_v_snow = lm(median_delays$Median_Delay ~ median_delays$Snow)

summary(model_d_v_prec)
summary(model_d_v_snow)

###################################################################

#Snowfall per day throughout year (w/o 0 values)

snowfall_not_0 = subset(as.numeric(weather_by_day$DailySnowfall), as.numeric(weather_by_day$DailySnowfall) > 0)
day_for_sf_not_0 = subset(as.Date(weather_by_day$DAY), as.numeric(weather_by_day$DailySnowfall) > 0)
plot(snowfall_not_0 ~ day_for_sf_not_0)

###################################################################

#Rainfall per day throughout year (w/o 0 values)

rainfall_not_0 = subset(as.numeric(weather_by_day$DailyPrecipitation), as.numeric(weather_by_day$DailyPrecipitation) > 0)
day_for_rf_not_0 = subset(as.Date(weather_by_day$DAY), as.numeric(weather_by_day$DailyPrecipitation) > 0)
plot(rainfall_not_0 ~ day_for_rf_not_0)
#w/ 0 values:
plot(as.numeric(weather_by_day$DailyPrecipitation) ~ as.Date(weather_by_day$DAY))

###################################################################

# Significance of storms on delay times
#    Build all storms vector

all_storms_flights  = on_day_of_event(c("Winter Storm", "Thunderstorm Wind", "Heavy Rain"), df = year_flights, airport = ord_name, origin = TRUE)
yes_no_storm        = ord_departs$FL_DATE %in% all_storms_flights$FL_DATE

num_flights_delayed = nrow(ord_d_delayed)
pct_delayed_whole   = num_flights_delayed / nrow(ord_departs)

num_f_delay_storm   = length(all_storms_flights$WEATHER_DELAY[all_storms_flights$WEATHER_DELAY > 0])
pct_delayed_storm   = num_f_delay_storm / nrow(all_storms_flights)

ord_departs$WEATHER_DELAY[is.na(ord_departs$WEATHER_DELAY)] = 0

boxplot((all_storms_flights$WEATHER_DELAY[all_storms_flights$WEATHER_DELAY > 0]), horizontal = TRUE)

plot(ord_departs$WEATHER_DELAY ~ yes_no_storm)

###################################################################

#1. Winter Storms

#Departures:
winter_storm_days = on_day_of_event("Winter Storm", year_flights, ord_name, TRUE)
days_ws           = winter_storm_days %>% distinct(FL_DATE)
fo_wsd            = five_out(as.character(days_ws[1,1]), year_flights, winter_storm_days)
fo_wsd_delayed    = fo_wsd[(fo_wsd$WEATHER_DELAY > 0) & !(is.na(fo_wsd$WEATHER_DELAY)),]
boxplot(log10(as.numeric(fo_wsd$WEATHER_DELAY)) ~ as.integer(fo_wsd$DEPTH))
boxplot(log2(as.numeric(fo_wsd_delayed$WEATHER_DELAY)) ~ as.integer(fo_wsd_delayed$DEPTH), xlab = "Steps out from ORD", ylab = "Delay in minutes (scaled by log2)")

#Arrivals
winter_storm_days_a = on_day_of_event("Winter Storm", year_flights, ord_name, FALSE)
days_ws_a           = winter_storm_days_a %>% distinct(FL_DATE)
fo_wsd_a            = five_out(as.character(days_ws_a[1,1]), year_flights, winter_storm_days_a)
fo_wsd_delayed_a    = fo_wsd_a[(fo_wsd_a$WEATHER_DELAY > 0) & !(is.na(fo_wsd_a$WEATHER_DELAY)),]
boxplot(log2(as.numeric(fo_wsd_delayed_a$WEATHER_DELAY)) ~ as.integer(fo_wsd_delayed_a$DEPTH))

#2. Thunderstorm Wind
tstorm_days       = on_day_of_event("Thunderstorm Wind", year_flights, ord_name, TRUE)
days_ts           = tstorm_days %>% distinct(FL_DATE)
fo_tsd            = five_out(as.character(days_ts[1,1]), year_flights, tstorm_days)
fo_tsd_delayed    = fo_tsd[(fo_tsd$WEATHER_DELAY > 0) & !(is.na(fo_tsd$WEATHER_DELAY)),]
boxplot(log2(as.numeric(fo_tsd_delayed$WEATHER_DELAY)) ~ as.integer(fo_tsd_delayed$DEPTH))

tstorm_days_a       = on_day_of_event("Thunderstorm Wind", year_flights, ord_name, FALSE)
days_ts_a           = tstorm_days %>% distinct(FL_DATE)
fo_tsd_a            = five_out(as.character(days_ts_a[1,1]), year_flights, tstorm_days_a)
fo_tsd_delayed_a    = fo_tsd_a[(fo_tsd_a$WEATHER_DELAY > 0) & !(is.na(fo_tsd_a$WEATHER_DELAY)),]
boxplot(log2(as.numeric(fo_tsd_delayed_a$WEATHER_DELAY)) ~ as.integer(fo_tsd_delayed_a$DEPTH))

#3. Heavy Rain
rstorm_days       = on_day_of_event("Heavy Rain", year_flights, ord_name, TRUE)
days_ra           = rstorm_days %>% distinct(FL_DATE)
fo_rad            = five_out(as.character(days_ra[1,1]), year_flights, rstorm_days)
fo_rad_delayed    = fo_rad[(fo_rad$WEATHER_DELAY > 0) & !(is.na(fo_rad$WEATHER_DELAY)),]
boxplot(log2(as.numeric(fo_rad_delayed$WEATHER_DELAY)) ~ as.integer(fo_rad_delayed$DEPTH))

