# Gets flights five airports out from ORD (or selected airport)
five_out <- function(date, df, ret_df){

  if (date == 0){
    date_range = as.character(seq(as.Date("2019-01-01"), as.Date("2019-12-01"), by = "days"))
  }
  
  else {
    date_range = dr(date)
  }
  
  ret_df = cbind(ret_df, DEPTH = rep(0, nrow(ret_df)))
  
  ret_df = ret_df[ret_df$FL_DATE %in% date_range,]
  
  # Begin recursive call
  new_df = five_out_rec(date_range, df, ret_df, 1)
  
  new_df = new_df %>% distinct(FL_DATE, OP_UNIQUE_CARRIER, ORIGIN_AIRPORT_ID, DEST_AIRPORT_ID, CRS_DEP_TIME, DEP_TIME, DEP_DELAY_NEW, DEP_DEL15, CRS_ARR_TIME, ARR_TIME, ARR_DELAY_NEW, ARR_DEL15, CANCELLED, WEATHER_DELAY, .keep_all = TRUE)
  
  return (new_df)
}

# Recursive procedure for five_out
five_out_rec <- function(date_range, df, ret_df, depth){
  
  # Base case: we've gone through this recursion 5 times
  if (depth == 6){
    return (NULL)  
  }
  
  # Performing BFS on whole data frame
  new_df = df[(df$FL_DATE %in% date_range) & (df$ORIGIN_AIRPORT_ID %in% ret_df$DEST_AIRPORT_ID), ]
  new_df = cbind(new_df, DEPTH = rep(depth, nrow(new_df))) 
  #   Assign how far we are from Chicago
  
  # Recursive procedure
  extracted = five_out_rec(date_range, df, new_df, depth + 1)
  
  if (is.null(extracted)) {
    return (ret_df)
  }
  
  ret_df = rbind(ret_df, extracted) # Bind the rows together from each data frame
  
  return (ret_df)
}

# Gets date range around given date
dr <- function(date){
  # 3 dates - 1 before, 1 after, the date itself
  
  date = as.character(date)
  
  day_before = as.Date(date) - 1
  day_after  = as.Date(date) + 1
  
  ret = c(as.character(day_before), date, as.character(day_after))
  
  return (ret)
}

# For use for INCOMING flights, not outgoing
# Very similar to five_out
five_in <- function(date, df, ret_df){
  
  if (date == 0){
    date_range = as.character(seq(as.Date("2019-01-01"), as.Date("2019-12-01"), by = "days"))
  }
  
  else {
    date_range = dr(date)
  }
    
  ret_df = cbind(ret_df, DEPTH = rep(0, nrow(ret_df)))
  
  ret_df = ret_df[ret_df$FL_DATE %in% date_range,]
  
  new_df = five_in_rec(date_range, df, ret_df, 1)
  
  new_df = new_df %>% distinct(FL_DATE, OP_UNIQUE_CARRIER, ORIGIN_AIRPORT_ID, DEST_AIRPORT_ID, CRS_DEP_TIME, DEP_TIME, DEP_DELAY_NEW, DEP_DEL15, CRS_ARR_TIME, ARR_TIME, ARR_DELAY_NEW, ARR_DEL15, CANCELLED, WEATHER_DELAY, .keep_all = TRUE)
  
  return (new_df)
}

five_in_rec <- function(date_range, df, ret_df, depth){
  
  # Base case: we've gone through this recursion 5 times
  if (depth == 6){
    return (NULL)  
  }
  
  new_df = df[(df$FL_DATE %in% date_range) & (df$DEST_AIRPORT_ID %in% ret_df$ORIGIN_AIRPORT_ID), ]
  new_df = cbind(new_df, DEPTH = rep(depth, nrow(new_df))) 
  #   Assign how far we are from Chicago
  
  extracted = five_in_rec(date_range, df, new_df, depth + 1)
  
  if (is.null(extracted)) {
    return (ret_df)
  }
  
  ret_df = rbind(ret_df, extracted) # Bind the rows together from each data frame
  
  return (ret_df)
}