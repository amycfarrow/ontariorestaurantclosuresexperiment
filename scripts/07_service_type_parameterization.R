#### Preamble ####
# Purpose: Use Yelp data to parameterize type of service (dine in/ dine in & takeout/takeout) for generating data
# Author: Lorena Almaraz De La Garza
# Date: 2021-02-15
# Contact: l.almaraz@mail.utoronto.ca
# License: MIT
# Pre-requisites: Needs CSV with Yelp restaurant data, available here: https://github.com/amycfarrow/ontariorestaurantclosuresexperiment/blob/main/inputs/data/yelp_restaurants_ontario.csv
# TODO: 

# Setup
# install packages if needed
library(ggplot2)
library(here)
library(tidyverse)

# Read in data

yelp_data <- read_csv(here("inputs/data/yelp_restaurants_ontario.csv"))

# Check proportion of RestaurantsTakeOut

takeout <- yelp_data %>% 
  select(RestaurantsTakeOut)
summary(takeout) # FALSE:834    TRUE :12972   NA's :3266    NONE: 7
count(takeout) # COUNT: 17072

takeout_percentage <- takeout %>%
  group_by(RestaurantsTakeOut) %>% 
  summarize(count = n()) %>%
  mutate(percentage = count/sum(count))

# Graph

ggplot(takeout_percentage, aes(RestaurantsTakeOut, percentage, fill = RestaurantsTakeOut)) + 
  geom_bar(stat='identity') + 
  geom_text(aes(label=scales::percent(percentage)))+
  scale_y_continuous(labels = scales::percent)
