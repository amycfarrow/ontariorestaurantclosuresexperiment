#install.packages("tidyverse")
#install.packages("jsonlite")
#install.packages("here")

library(tidyverse)
library(jsonlite)
library(here)


### load yelp dataset .json file ###
# Yelp dataset is not uploaded in inputs/data folder in github repository because the file is too large
# But the dataset can be downloaded from https://www.yelp.com/dataset/download

path <- here("inputs", "data", "yelp_academic_dataset_business.json")
yelp_business <-  stream_in(file(path))
yelp_business_df <- as.data.frame(yelp_business)


### Make all attributes  sub-columns into regular columns ###
yelp_attributes <- yelp_business_df$attributes
yelp_business_df <- subset(yelp_business_df, select=-c(attributes))
yelp_business_df <- cbind(yelp_business_df, yelp_attributes)
names(yelp_business_df)


### Put all businesses in Ontario into a dataframe ###
yelp_business_on <- yelp_business_df[yelp_business_df$state == 'ON',] %>%
  select(name,
         address,
         city,
         postal_code,
         latitude,
         longitude,
         stars,
         is_open,
         RestaurantsPriceRange2,
         RestaurantsTakeOut,
         RestaurantsDelivery,
         OutdoorSeating,
         categories,
         business_id
         )


### Get only Restaurants & Cafes businesses
yelp_restaurants_on <- yelp_business_on[grepl("Restaurants|Cafes|Bars", yelp_business_on$categories),]

nrow(yelp_restaurants_on)


### Write into a .csv file ###
write_csv(yelp_restaurants_on, here("inputs", "data", "yelp_restaurants_ontario.csv"))