## Write your client test code here

library(httr)
library(jsonlite)

input_df = data.frame(
  appt_time = c("2023-07-01 13:00:00", "2023-07-02 09:30:00"),
  appt_made = c("2023-06-25", "2023-06-20")
)

# Serialize the data frame into JSON
json_input <- toJSON(input_df, dataframe = "rows")

# Test 1: predict_prob endpoint
prob_response <- POST(
  url = "http://127.0.0.1:8080/predict_prob",
  body = json_input,
  encode = "json",            # tells httr to send JSON
  content_type_json()         # sets correct header: application/json
)

# Unserialize / parse the returned JSON into R
prob_values <- fromJSON(content(prob_response, "text"))

cat("== Predicted Probabilities ==\n")
print(prob_values)

# Test 2: predict_class endpoint
class_response <- POST(
  url = "http://127.0.0.1:8080/predict_class",
  body = json_input,
  encode = "json",
  content_type_json()
)

# Unserialize the returned JSON
class_values <- fromJSON(content(class_response, "text"))

cat("\n== Predicted Classes ==\n")
print(class_values)
