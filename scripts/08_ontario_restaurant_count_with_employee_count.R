#### Preamble ####
# Purpose: Get number of Ontario restaurants by number of restaurant employees from previous semi-annual reports
# Author: Lala K. Sondjaja
# Date: Sys.date()
# Contact: k.sondjaja@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

### Install packages ###
#devtools::install_github("warint/statcanR")
#install.packages("tidyverse")

### Load packages ###
library(statcanR)
library(tidyverse)

### Get datasets from Statistics Canada ###
### From 'Canadian Business Counts, with employees' from various dates ###

#"Mobile food services [722330]"

industry <- c("Special food services [7223]", "Drinking places (alcoholic beverages) [7224]", "Full-service restaurants and limited-service eating places [7225]")

ontario <- statcan_data("33-10-0222-01", "eng") %>% filter(GEO=='Ontario')

businesses_dec_2019 <- janitor::clean_names(statcan_data("33-10-0222-01", "eng") %>% filter(GEO=='Ontario', `North American Industry Classification System (NAICS)`%in% industry))
businesses_june_2020 <- janitor::clean_names(statcan_data("33-10-0267-01", "eng") %>% filter(GEO=='Ontario', `North American Industry Classification System (NAICS)`%in% industry))
businesses_dec_2020 <- janitor::clean_names(statcan_data("33-10-0304-01", "eng") %>% filter(GEO=='Ontario', `North American Industry Classification System (NAICS)`%in% industry))

restaurants_by_employees <- function(x){
  one_to_four <- sum(x$value[x$employment_size == "1 to 4 employees"])
  five_to_nine <- sum(x$value[x$employment_size == "5 to 9 employees"])
  ten_to_nineteen <- sum(x$value[x$employment_size == "10 to 19 employees"])
  twenty_to_fortynine <- sum(x$value[x$employment_size == "20 to 49 employees"])
  fifty_to_ninetynine <- sum(x$value[x$employment_size == "50 to 99 employees"])
  hundred_to_199 <- sum(x$value[x$employment_size == "100 to 199 employees"])
  twohundred_to_499 <- sum(x$value[x$employment_size == "200 to 499 employees"])
  over_500 <- sum(x$value[x$employment_size == "500 plus employees"])
  
  return(c(one_to_four, five_to_nine, ten_to_nineteen, twenty_to_fortynine, fifty_to_ninetynine, hundred_to_199, twohundred_to_499, over_500))
}

dec_2019 <- restaurants_by_employees(businesses_dec_2019)
june_2020 <- restaurants_by_employees(businesses_june_2020)
dec_2020 <- restaurants_by_employees(businesses_dec_2020)