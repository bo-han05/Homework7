## Write your API endpoints in this file

library(tidyverse)
library(lubridate)
library(plumber2)
library(jsonlite)

load("model.RData")

clean_data = function(df){
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
#* @parser json
#* @serializer json
function(body){
  body = as.data.frame(body)
  data = clean_data(body)
  prob = predict(model, newdata=data, type="response")
  as.numeric(prob)
}

#* Predict no-show class
#* @post /predict_class
#* @parser json
#* @serializer json
function(body){
  body = as.data.frame(body)
  data = clean_data(body)
  prob = predict(model, newdata=data, type="response")
  class = ifelse(prob >= 0.5, 1, 0)
  as.numeric(class)
}
