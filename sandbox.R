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

# Total views
total_views <- sum(metric_by_date$screenPageViews)

# Average duration
decimal_duration <- sum(
  metric_by_date$averageSessionDuration * metric_by_date$sessions
) /
  sum(metric_by_date$sessions) /
  60
duration_minutes <- floor(decimal_duration)
duration_seconds <- round((decimal_duration - duration_minutes) * 60)
duration_seconds <- ifelse(
  nchar(duration_seconds) == 1,
  paste0("0", duration_seconds),
  as.character(duration_seconds)
)
average_duration <- paste0(duration_minutes, ":", duration_seconds)

# Engaged session rate
engaged_session_rate <- sum(metric_by_date$engagedSessions) /
  sum(metric_by_date$sessions)
engaged_session_rate <- paste0(round(100 * engaged_session_rate, 1), "%")

## Views over time

# Make intermediate dataset
temp_views <-
  metric_by_date |>
  select(
    date,
    Users = totalUsers,
    Views = screenPageViews
  )

# Make graph
temp_views |>

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
    data = temp_views |>

      # Send down the rows
      pivot_longer(
        cols = -date,
        names_to = "Metric",
        values_to = "Value"
      ) |>

      # Indicate group
      add_column(Granularity = "Daily"),
    aes(
      y = Value * 20
    ),
    alpha = .25
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",
    legend.title = element_blank(),
    legend.text = element_text(size = 12)
  ) +
  scale_x_date(name = "Month", date_labels = "%b %y") +
  scale_y_continuous(
    name = "Monthly Count",
    sec.axis = sec_axis(~ . / 20, name = "Daily Count")
  ) +
  scale_color_manual(values = c("#c9b638", "#36637d"))

# Text
views_per_month <-
  temp_views |>

  # Get month
  mutate(date = floor_date(date, unit = "month")) |>

  # Aggregate
  summarize(
    Views = sum(Views),
    .by = date
  ) |>
  with(data = _, mean(Views))

## Top 5 pages
top_pages <-
  ga_data(
    propertyId = my_prop,
    metrics = "screenPageViews",
    dimensions = c("unifiedPagePathScreen", "unifiedScreenName"),
    date_range = c(date_start, date_end) |> as.character(),
    limit = -1
  )

top_pages |>

  # Filter to blog post
  filter(str_detect(unifiedPagePathScreen, "^[/]post[/]")) |>

  # Clean names
  mutate(
    Label = unifiedScreenName |>
      str_remove(pattern = " – Zajichek Stats")
  ) |>

  # Combine
  summarize(
    Views = sum(screenPageViews),
    .by = Label
  ) |>

  # Make rate
  mutate(
    Percent = Views / sum(Views)
  ) |>

  # Keep top 5 rows
  slice_max(
    order_by = Views,
    n = 5,
    with_ties = FALSE
  ) |>

  # Make a table
  gt() |>
  cols_label(
    Label = "Title",
    Percent = "% of Total Views"
  ) |>
  fmt_percent(
    columns = Percent,
    decimals = 1
  )
