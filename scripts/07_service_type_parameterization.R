#### Preamble ####
# Purpose: Use Yelp data to parameterize type of service (dine in/ takeout / both) for generating data
# Author: Lorena Almaraz De La Garza
# Date: 2021-02-15
# Contact: l.almaraz@mail.utoronto.ca
# License: MIT
# Pre-requisites: Needs CSV with Yelp restaurant data, available here: https://github.com/amycfarrow/ontariorestaurantclosuresexperiment/blob/main/inputs/data/yelp_restaurants_ontario.csv
# TODO: Ask KSondjaja for Yelp data citation


# Setup
# install packages if needed
library(ggplot2)
library(here)
library(tidyverse)

# Read in data
yelp_data <- read_csv(here("inputs/data/yelp_restaurants_ontario.csv")) %>% 
  na.omit() # Remove all NAs
total_restaurants <- count(yelp_data)




# Check proportion of RestaurantsTakeOut
takeout <- yelp_data %>% 
  select(RestaurantsTakeOut)
summary(takeout) # FALSE:276, TRUE :4120

takeout_percentage <- takeout %>%
  group_by(RestaurantsTakeOut) %>% 
  summarize(count = n()) %>%
  mutate(percentage = count/sum(count))

# Graph RestaurantsTakeOut
ggplot(takeout_percentage, aes(RestaurantsTakeOut, percentage, fill = RestaurantsTakeOut)) + 
  geom_bar(stat='identity') + 
  geom_text(aes(label=scales::percent(percentage)))+
  scale_y_continuous(labels = scales::percent)




# Check proportion of RestaurantsTableService
tableserv <- yelp_data %>% 
  select(RestaurantsTableService)
summary(tableserv) #  FALSE:1448, TRUE :2948 

tableserv_percentage <- tableserv %>%
  group_by(RestaurantsTableService) %>% 
  summarize(count = n()) %>%
  mutate(percentage = count/sum(count))

# Graph RestaurantsTableService
ggplot(tableserv_percentage, aes(RestaurantsTableService, percentage, fill = RestaurantsTableService)) + 
  geom_bar(stat='identity') + 
  geom_text(aes(label=scales::percent(percentage)))+
  scale_y_continuous(labels = scales::percent)





# Calculate invalid responses (neither dine-in nor takeout)
invalid <- yelp_data %>% 
  filter(RestaurantsTableService == FALSE & RestaurantsTakeOut == FALSE) %>% 
  count()

valid_restaurants <- total_restaurants-invalid

# Calculate service type percentages
takeout_only <- yelp_data %>% 
  filter(RestaurantsTableService == FALSE & RestaurantsTakeOut == TRUE) %>% 
  count()/valid_restaurants

dinein_only <- yelp_data %>% 
  filter(RestaurantsTableService == TRUE & RestaurantsTakeOut == FALSE) %>% 
  count()/valid_restaurants

both <- yelp_data %>% 
  filter(RestaurantsTableService == TRUE & RestaurantsTakeOut == TRUE) %>% 
  count()/valid_restaurants

service_percentage<- data.frame(
  service = c("takeout", "dinein", "both"),
  percentage = c(takeout_only$n, dinein_only$n, both$n), options(digits = 2)
)

# Graph service type percentages
 ggplot(service_percentage, aes(service, percentage, fill = service)) + 
   geom_bar(stat='identity') + 
   geom_text(aes(label=scales::percent(percentage)))+
   scale_y_continuous(labels = scales::percent)

# According to Ontario restaurant data from Yelp (cite, KSondjaja source), approximately 6% of restaurants
# offer dine in service, 32.5% offer takeout, and 61.5% offer both.