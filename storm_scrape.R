storm = read.csv("2019_storm_data.csv")

storm[,"BEGIN_DATE"] = as.character(as.Date(storm$BEGIN_DATE, format ="%m/%d/%Y"))

types_of_events <- function(){
  return ( storm %>% distinct(EVENT_TYPE) )
}


days_of_events <- function(event){
  event = as.character(event)
  return ( storm[storm$EVENT_TYPE == event,])
}

# Given an event (in vector form), a dataframe (df) to search from, an airport to search for,
# and whether or not we are looking at departures or arrivals (for departures, origin = TRUE), 
# this function gives all flights that happened when those events happened
on_day_of_event <- function(event, df, airport, origin = TRUE){
  
  for (i in (1:length(event))){
    event[i] = as.character(event[i])
  }
  
  event_days = storm$BEGIN_DATE[storm$EVENT_TYPE %in% event]
  if (origin){
    return (df[(df$FL_DATE %in% event_days) & (df$ORIGIN_AIRPORT_ID == airport),])
  }
  else {
    return (df[(df$FL_DATE %in% event_days) & (df$DEST_AIRPORT_ID == airport),])
  }
  
}