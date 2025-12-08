## Write your API endpoints in this file

library(tidyverse)
library(lubridate)
library(plumber)
library(jsonlite)

load("model.RData")

preprocess_data = function(df) {
  df %>%
    mutate(
      appt_time = ymd_hms(appt_time, tz="UTC"),
      appt_date = as.Date(appt_time),
      appt_hour = hour(appt_time),
      appt_day = wday(appt_time, label=T, abbr=T),
      diff_time = as.numeric(difftime(appt_date, as.Date(appt_made), units="days"))
    )
}

#* Predict probability of no-shows
#* @post /predict_prob
function(req) {
  input_df <- jsonlite::fromJSON(req$postBody)
  if (!is.data.frame(input_df)) input_df <- as.data.frame(input_df)
  processed <- preprocess_data(input_df)
  preds <- predict(model, newdata = processed, type = "response")
  return(as.numeric(preds))
}

#* Predict no-show class
#* @post /predict_class
function(req) {
  input_df <- jsonlite::fromJSON(req$postBody)
  if (!is.data.frame(input_df)) input_df <- as.data.frame(input_df)
  processed <- preprocess_data(input_df)
  probs <- predict(model, newdata = processed, type = "response")
  classes <- ifelse(probs >= 0.5, 1, 0)
  return(as.numeric(classes))
}
