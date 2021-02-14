#### Preamble ####
# Purpose: Compile restaurant and takeout data by health unit
# Author: Lorena Almaraz De La Garza
# Date: 2021-02-13
# Contact: l.almaraz@mail.utoronto.ca
# License: MIT
# Pre-requisites: Needs CSVs with restaurant data per health unit, available here: https://github.com/amycfarrow/ontariorestaurantclosuresexperiment/tree/main/inputs/data
# TODO: split type into three (dine in, dine in and t-o, t-o only)

# Setup
# install packages if needed
library(here)
library(janitor)
library(tidyverse)

# Read in data

brant_r <- read_csv(here("inputs/data/brant_restaurants.csv")) %>% 
  add_column(type = "restaurant") 
brant_to <- read_csv(here("inputs/data/brant_takeout.csv")) %>% 
  add_column(type = "takeout") # TODO - split type into three (dine in, dine in and t-o, t-o only)

brant_data <- rbind(brant_r, brant_to) %>% 
  clean_names() %>%
  rename(name = facility_name,
         address = site_address) %>% 
  select(!last_inspection_date) %>% 
  add_column(unit = "brant") 
  

# Save
write_csv(brant_data, here("outputs/data/brant_data.csv"))

# Make a function to do same as above

clean_data <- function(unit, csv_r, csv_to, save_dir){
  unit_r <- read_csv(here(csv_r)) %>% 
    add_column(type = "restaurant") 
  unit_to <- read_csv(here(csv_to)) %>% 
    add_column(type = "takeout") # TODO - split type into three (dine in, dine in and t-o, t-o only)
  
 unit_data <- rbind(unit_r, unit_to) %>% 
    clean_names() %>%
    rename(name = facility_name,
           address = site_address) %>% 
    select(name, address, type) %>% 
    add_column(unit = unit) 
  
  write_csv(unit_data, here(save_dir))
}

# Use function for remaining health units

chatham_kent_data <- clean_data("chatham",
                                "inputs/data/chatham_kent_restaurants.csv",
                                "inputs/data/chatham_kent_takeout.csv",
                                "outputs/data/chatham_kent_data.csv")

hamilton_data <- clean_data("hamilton",
                            "inputs/data/hamilton_restaurants.csv",
                            "inputs/data/hamilton_takeout.csv",
                            "outputs/data/hamilton_data.csv")

peel_data <- clean_data("peel",
                            "inputs/data/peel_restaurants.csv",
                            "inputs/data/peel_takeout.csv",
                            "outputs/data/peel_data.csv")

southwestern_data <- clean_data("southwestern",
                        "inputs/data/southwestern_restaurants.csv",
                        "inputs/data/southwestern_takeout.csv",
                        "outputs/data/southwestern_data.csv")

sudbury_data <- clean_data("sudbury",
                                "inputs/data/sudbury_restaurants.csv",
                                "inputs/data/sudbury_takeout.csv",
                                "outputs/data/sudbury_data.csv")

# Compile info from all health units into main db

all_units_data <- rbind(brant_data, chatham_kent_data, hamilton_data, peel_data, southwestern_data, sudbury_data)

# Save

write_csv(all_units_data, here("outputs/data/all_units_data.csv"))
