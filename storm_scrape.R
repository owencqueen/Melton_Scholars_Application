storm = read.csv("2019_storm_data.csv")

storm[,"BEGIN_DATE"] = as.character(as.Date(storm$BEGIN_DATE, format ="%m/%d/%Y"))

types_of_events <- function(){
  return ( storm %>% distinct(EVENT_TYPE) )
}

days_of_events <- function(event){
  event = as.character(event)
  return ( storm[storm$EVENT_TYPE == event,])
}

on_day_of_event <- function(event, df, airport, origin = TRUE){
  
  event = as.character(event)
  
  event_days = storm$BEGIN_DATE[storm$EVENT_TYPE == event]
  if (origin){
    return (df[(df$FL_DATE %in% event_days) & (df$ORIGIN_AIRPORT_ID == airport),])
  }
  else {
    return (df[(df$FL_DATE %in% event_days) & (df$DEST_AIRPORT_ID == airport),])
  }
  
}