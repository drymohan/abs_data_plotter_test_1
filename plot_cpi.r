## testing the readabs package to plot CPI data
library(tidyverse)
library(janitor)
library(ggplot2)
library(readabs)
library(plotly)

cpi_raw <- readabs::read_abs("6401.0", tables = 1)

cpi_clean <- cpi_raw |>
    readabs::separate_series() |>
    filter(series_1 == "Index Numbers",
           series_2 == "All groups CPI") |>
    select(date, location = series_3, value)|>
    mutate(date = as.Date(date),
              value = as.numeric(value))

## checks
cpi_clean |> distinct(series_1)
cpi_clean |> distinct(table_no)

## plot the various series

cpi_plot <- cpi_clean |> 
filter(date > "2019-01-01") |>
    ggplot(aes(x = date, y = value, color = location)) +
    geom_line(size = 1) +
    labs(title = "CPI All Groups Index Numbers",
         x = "Date",
         y = "Index Number")+
    theme_minimal()+
    theme(legend.position = "bottom")

ggplotly(cpi_plot)
