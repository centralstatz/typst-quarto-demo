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

day_range <- 0:365
temp_dat <-
  tibble(
    date = Sys.Date() - days(day_range),
    Users = sample(1:100, size = length(day_range), replace = TRUE),
    Views = sample(25:200, size = length(day_range), replace = TRUE)
  )

temp_dat |>

  # Send down the rows
  pivot_longer(
    cols = -date,
    names_to = "Metric",
    values_to = "Value"
  ) |>

  # Get month
  mutate(date = floor_date(date, unit = "month")) |>

  # Aggregate
  summarize(
    Value = sum(Value),
    .by = c(
      date,
      Metric
    )
  ) |>

  # Add group
  add_column(Granularity = "Monthly") |>

  # Make a plot
  ggplot(
    aes(
      x = date,
      y = Value,
      color = Metric
    )
  ) +
  geom_line() +
  geom_point() +
  geom_line(
    data = temp_dat |>

      # Send down the rows
      pivot_longer(
        cols = -date,
        names_to = "Metric",
        values_to = "Value"
      ) |>

      # Indicate group
      add_column(Granularity = "Daily"),
    aes(
      y = Value * 30
    ),
    alpha = .15
  ) +
  theme_minimal() +
  theme(
    legend.position = "top",
    legend.title = element_blank()
  ) +
  scale_x_date(name = "Month", date_labels = "%b %y") +
  ylab("Count") +
  scale_color_manual(values = c("#c9b638", "#36637d"))
