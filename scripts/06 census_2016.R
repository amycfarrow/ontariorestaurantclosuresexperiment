#### Preamble ####
# Purpose: Get demographic & food service employment data of Ontario Public Health Regions from Statistics Canada
# Author: Lala K. Sondjaja
# Date: Sys.date()
# Contact: k.sondjaja@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

### Install packages ###
#install.packages("tidyverse")
#install.packages("jsonlite")
#install.packages("here")

### Load packages ###
library(tidyverse)
library(here)
library(janitor)

### Load census dataset by Health Regions ###
### Download link: https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=058 ###
### GEO_CODE indicates public health regions, taken from Census 2016 links:
### https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/search-recherche/lst/results-resultats.cfm?Lang=E&TABID=1&G=1&Geo1=&Code1=&Geo2=&Code2=&GEOCODE=35&type=0

census_2016 <- read.csv(here("inputs", "data", "98-401-X2016058_English_CSV_data.csv"))
census_2016 <- janitor::clean_names(census_2016)

names(census_2016)


### Select demographic data to include, relating to employment, income, immigration status, minority groups, commute, etc. ###

demographic_info <- c(1, 6, 8:33, 60:67, 100:104, 661:663, 694:707, 724:726, 1135:1136, 1139, 1140:1150, 1157, 1158, 1170, 1188, 1198, 1216, 1287, 1289:1292, 1324:1337, 1683:1697, 1884:1929)


### Function to retrieve data from specific regions and rows ###

get_region_data <- function(x, y){
  x <- census_2016 %>%
    filter(geo_code_por == y,
           member_id_profile_of_health_regions_2247 %in% demographic_info) %>%
    select(dim_profile_of_health_regions_2247, member_id_profile_of_health_regions_2247, dim_sex_3_member_id_1_total_sex, dim_sex_3_member_id_2_male, dim_sex_3_member_id_3_female)
}

### Retrieve data from the following Health Regions ###

brant <- get_region_data(brant, 3527)
chatham <- get_region_data(chatham, 3540)
hamilton <- get_region_data(hamilton, 3537)
peel <- get_region_data(peel, 3553)
sudbury <- get_region_data(sudbury, 3561)
southwestern <- get_region_data(southwestern, 3502)

### Write to separate .csv files ###

write_csv(brant, here("inputs", "data", "brant_census_2016.csv"))
write_csv(chatham, here("inputs", "data", "chatham_census_2016.csv"))
write_csv(hamilton, here("inputs", "data", "hamilton_census_2016.csv"))
write_csv(peel, here("inputs", "data", "peel_census_2016.csv"))
write_csv(sudbury, here("inputs", "data", "sudbury_census_2016.csv"))
write_csv(southwestern, here("inputs", "data", "southwestern_census_2016.csv"))
