source(file = "weather_scrape.R")

format_dates <- function(df){
  
  df[, "FL_DATE"] = as.character(df[, "FL_DATE"])
  
  for (i in (1:nrow(df))) {
    print(i)
    da = as.character(df[i, "FL_DATE"])
    one = as.Date(da, "%m/%d/%Y")
    df[i, "FL_DATE"] = as.character(one)
  }
  
  return (df)
}

jan = read.csv('data_by_month/2019_jan_data.csv')
feb = read.csv('data_by_month/2019_feb_data.csv')
mar = read.csv('data_by_month/2019_mar_data.csv')
apr = read.csv('data_by_month/2019_apr_data.csv')
may = read.csv('data_by_month/2019_may_data.csv')
jun = read.csv('data_by_month/2019_june_data.csv')
jul = read.csv('data_by_month/2019_july_data.csv')
aug = read.csv('data_by_month/2019_aug_data.csv')
sep = read.csv('data_by_month/2019_sep_data.csv')
oct = read.csv('data_by_month/2019_oct_data.csv')
nov = read.csv('data_by_month/2019_nov_data.csv')
dec = read.csv('data_by_month/2019_dec_data.csv')

jan = jan %>% rename(DEP_DELAY_NEW = DEP_DELAY)
jan = jan %>% rename(ARR_DELAY_NEW = ARR_DELAY)
feb = feb %>% rename(DEP_DELAY_NEW = DEP_DELAY)
feb = feb %>% rename(ARR_DELAY_NEW = ARR_DELAY)

may = cbind(may, X = rep(NA, nrow(may)))
nov = cbind(nov, X = rep(NA, nrow(nov)))

may = format_dates(may)
nov = format_dates(nov)

year_flights = rbind(jan, feb)
year_flights = rbind(year_flights, mar)
year_flights = rbind(year_flights, apr)
year_flights = rbind(year_flights, may)
year_flights = rbind(year_flights, jun)
year_flights = rbind(year_flights, jul)
year_flights = rbind(year_flights, aug)
year_flights = rbind(year_flights, sep)
year_flights = rbind(year_flights, oct)
year_flights = rbind(year_flights, nov)
#year_flights = rbind(year_flights, dec)

year_flights = subset(year_flights, select = -c(X))
