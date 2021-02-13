#### Preamble ####
# Purpose: Compile restaurant and takeout data by health unit
# Author: Lorena Almaraz De La Garza
# Date: Sys.date()
# Contact: l.almaraz@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


# Setup

# install packages if needed
library(here)
library(janitor)
library(tidyverse)

# Read in data

brantford_r <- read_csv("inputs/data/brant_restaurants.csv") %>% 
  add_column(type = "restaurant")
brantford_to <- read_csv("inputs/data/brant_takeout.csv") %>% 
  add_column(type = "takeout")

brantford_data <- rbind(brantford_r, brantford_to) %>% 
  clean_names() %>%
  rename(name = facility_name,
         address = site_address) %>% 
  select(!last_inspection_date)

# Save
write_csv(brantford_data,"outputs/data/brantford_data.csv")

