## Write your client test code here

library(httr)
library(jsonlite)

input_df = data.frame(
  appt_time = c("2025-11-01 20:00:00",
                "2025-12-06 12:30:00",
                "2025-02-12 10:00:00"),
  appt_made = c("2025-08-21",
                "2025-10-18",
                "2024-12-25")
)

json_input = toJSON(input_df, dataframe="rows")

####
prob_result = POST(
  url = "http://127.0.0.1:8080/predict_prob",
  body = json_input,
  encode = "json",
  content_type_json()
)

prob_vector = fromJSON(content(prob_result, "text", encoding="UTF-8"))

cat("Predicted Probabilities:\n")
print(prob_vector)

####
class_result = POST(
  url = "http://127.0.0.1:8080/predict_class",
  body = json_input,
  encode = "json",
  content_type_json()
)

class_vector = fromJSON(content(class_result, "text", encoding="UTF-8"))

cat("\nPredicted Classes:\n")
print(class_vector)
