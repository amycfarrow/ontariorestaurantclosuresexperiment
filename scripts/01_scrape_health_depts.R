#### Preamble ####
# Purpose: Get a tibble of all health units in Ontario
# Data Toronto
# Author: Amy Farrow
# Date: 2021-02-10
# Contact: amy.farrow@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(httr)
library(tidyverse)
library(rvest)
library(here)


### Get raw data ###
# This is a Government of Canada webpage about food inspections that lists all health units in Ontario
health_depts <- read_html("https://www.inspection.gc.ca/food-safety-for-industry/information-for-consumers/report-a-concern/restaurants-and-food-services/eng/1323139279504/1323140830752")

# Save the data
write_html(health_depts, here::here("inputs/data/raw_health_depts.html"))

# To get all the URLs we need a flat version of the page
flat_page <- readLines(con = "https://www.inspection.gc.ca/food-safety-for-industry/information-for-consumers/report-a-concern/restaurants-and-food-services/eng/1323139279504/1323140830752")

# Save the raw data.
write_lines (flat_page, here::here("inputs/data/flat_page_health_depts.txt"))


### Clean the results into a tibble
# Filtering through the html tags to get to the relevant part of the page.
text_data <- health_depts %>%
  html_nodes('body') %>%
  html_nodes('main') %>%
  html_nodes('div') %>%
  html_nodes('details') %>%
  html_nodes('p') %>%
  html_text()

# Making a tibble
all_depts <- tibble(dept = text_data)

# Only lines 9 through 41 talk about Ontario health units
all_depts <-
  all_depts %>%
  slice(9:41)

# Separating out columns for name and areas covered
all_depts <- all_depts %>%
  separate(col = "dept",
           into = c("Name", "Areas"),
           sep = " \\(",
           remove = TRUE) %>%
  mutate(Areas = str_remove(Areas, "\\)"))



# Making a vector that has all the health unit URLs in order. 
depts = all_depts$Name
urls = c()
for (i in 1:length(depts))
{
  # Finding the line position that the dept name first appears in
  pos = as.numeric(grep(pattern = depts[i], x = flat_page)[1])
  # Take that line and the six following line, and compress into one string
  # from https://stackoverflow.com/questions/36882470/in-r-how-to-filter-lines-containing-substring
  url = str_c(flat_page[pos:(pos+6)], sep = "  ", collapse = TRUE)
  urls = append(urls, url)
}

# Attach the vector of URLs to the tibble
all_depts <- bind_cols(all_depts, urls)

# Clean up the tibble
all_depts <- all_depts %>%
  rename("urls" = "...3")
all_depts <- all_depts %>%
  separate(col = "urls",
           into = c("Before", "Target"),
           sep = "a href=",
           remove = TRUE)
all_depts <-
  all_depts %>%
  separate(col = "Target",
           into = c("Before2", "URL"),
           sep = '"',
           remove = TRUE) %>%
  select(-Before, - Before2)

### Save data ###
# Save the tibble that lists all health departments, areas, and URLs.
write_csv(all_depts, here::here("inputs/data/all_health_depts.csv"))