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
  add_column(type = "") 
brant_to <- read_csv(here("inputs/data/brant_takeout.csv")) %>% 
  add_column(type = "") 

brant_data <- unique(rbind(brant_r, brant_to)) %>% 
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
    add_column(type = "") 
  unit_to <- read_csv(here(csv_to)) %>% 
    add_column(type = "") 
  
 unit_data <- unique(rbind(unit_r, unit_to)) %>% 
    clean_names() %>%
    rename(name = facility_name,
           address = site_address) %>% 
    select(name, address, type) %>% 
    add_column(unit = unit) 
  
  write_csv(unit_data, here(save_dir))
}

# Use function for remaining health units

#chatham_kent_data <- clean_data("chatham",
#                                "inputs/data/chatham_kent_restaurants.csv",
#                                "inputs/data/chatham_kent_takeout.csv",
#                                "outputs/data/chatham_kent_data.csv")

#peel_data <- clean_data("peel",
#                            "inputs/data/peel_restaurants.csv",
#                            "inputs/data/peel_takeout.csv",
#                            "outputs/data/peel_data.csv")

algoma_data <- clean_data("algoma",
                          "inputs/data/algoma_restaurants.csv",
                          "inputs/data/algoma_takeout.csv",
                          "outputs/data/algoma_data.csv")

durham_data <- clean_data("durham",
                           "inputs/data/durham_restaurants.csv",
                           "inputs/data/durham_takeout.csv",
                           "outputs/data/durham_data.csv")

northwestern_data <- clean_data("northwestern",
                          "inputs/data/northwestern_restaurants.csv",
                          "inputs/data/northwestern_takeout.csv",
                          "outputs/data/northwestern_data.csv")

simcoe_data <- clean_data("simcoe",
                                "inputs/data/simcoe_restaurants.csv",
                                "inputs/data/simcoe_takeout.csv",
                                "outputs/data/simcoe_data.csv")

southwestern_data <- clean_data("southwestern",
                        "inputs/data/southwestern_restaurants.csv",
                        "inputs/data/southwestern_takeout.csv",
                        "outputs/data/southwestern_data.csv")

sudbury_data <- clean_data("sudbury",
                                "inputs/data/sudbury_restaurants.csv",
                                "inputs/data/sudbury_takeout.csv",
                                "outputs/data/sudbury_data.csv")

timiskaming_data <- clean_data("timiskaming",
                          "inputs/data/timiskaming_restaurants.csv",
                          "inputs/data/timiskaming_takeout.csv",
                          "outputs/data/timiskaming_data.csv")

windsor_data <- clean_data("windsor",
                           "inputs/data/windsor_restaurants.csv",
                           "inputs/data/windsor_takeout.csv",
                           "outputs/data/windsor_data.csv")

waterloo_data <- clean_data("waterloo",
                          "inputs/data/waterloo_restaurants_and_takeout.csv",
                          "inputs/data/waterloo_restaurants_and_takeout.csv",
                          "outputs/data/waterloo_data.csv")

# Clean data further for Hamilton & Haliburton

hamilton_data <- clean_data("hamilton",
                            "inputs/data/hamilton_restaurants.csv",
                            "inputs/data/hamilton_takeout.csv",
                            "outputs/data/hamilton_data.csv") %>% 
                            filter(!grepl("grocery|convenience|variety|store|market|private club|bakery|
                            |foodmart|food mart|bulk barn|canadian tire|church|gas|dollar|esso|fortinos|
                            |giant tiger|school|college|shop|petro|pioneer|pharma|legion|drug|express", name, ignore.case=TRUE))

write_csv(hamilton_data, here("outputs/data/hamilton_data.csv"))


haliburton_data <- clean_data("hamilton",
                            "inputs/data/haliburton_restaurants.csv",
                            "inputs/data/haliburton_restaurants.csv",
                            "outputs/data/haliburton_data.csv") %>% 
                            filter(!grepl("grocery|convenience|variety|store|market|private club|bakery|
                            |foodmart|food mart|bulk barn|canadian tire|church|gas|dollar|esso|fortinos|
                            |giant tiger|school|college|shop|petro|pioneer|pharma|legion|drug|express", name, ignore.case=TRUE))

write_csv(haliburton_data, here("outputs/data/haliburton_data.csv"))

# Compile info from all health units into main db

all_units_data <- unique(rbind(algoma_data, brant_data, durham_data, hamilton_data, haliburton_data, northwestern_data, simcoe_data, southwestern_data, sudbury_data, timiskaming_data, windsor_data, waterloo_data))

# Save

write_csv(all_units_data, here("outputs/data/all_units_data.csv"))


