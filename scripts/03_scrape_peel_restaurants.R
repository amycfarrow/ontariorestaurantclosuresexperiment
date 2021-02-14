#### Preamble ####
# Purpose: Get a tibble of all health units in Ontario
# Author: Amy Farrow
# Date: 2021-02-10
# Contact: amy.farrow@mail.utoronto.ca
# License: MIT
# Pre-requisites: None



######## TODO: (optional) write this script rather than copying the csvs the tables and saving.



#### Workspace setup ####
library(tidyverse)
library(RCurl)
library(here)
library(XML)


### Get raw data ###
peel_restaurants_raw <- getURL("http://rmop.hedgerowsoftware.com/Portal/Food/Table?SortMode=FacilityName&page=1&PageSize=100000",
                               cookiefile = )