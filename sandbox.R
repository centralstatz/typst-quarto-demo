# Load packages
library(tidyverse)
library(googleAnalyticsR)
library(reactable)

# Connect to GA
ga_auth(json_file = "credentials.json")

# Extract property info
my_account <- ga_account_list("ga4")

# Extract the property I want
my_prop <- my_account |>
  filter(property_name == "zajichekstats") |>
  pull("propertyId")

# Set date range
date_end <- Sys.Date()
date_start <- date_end - years(1)

# ga_meta(propertyId = my_prop, version = "data") |> View()

# Extract metrics by calendar date
metric_by_date <-
  ga_data(
    propertyId = my_prop,
    metrics = c(
      "totalUsers",
      "screenPageViews",
      "sessions",
      "engagedSessions",
      "averageSessionDuration"
    ),
    dimensions = "date",
    date_range = c(date_start, date_end) |> as.character(),
    limit = -1
  )

# Show metric KPI's across top (total views, engaged session rate, avg. duration)

# Show time series of monthly views across page (views and users separate lines)

# Side by side showing top 5 pages by views; map by location
