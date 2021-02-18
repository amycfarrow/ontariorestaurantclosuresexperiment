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

census_2016 <- read.csv(here("inputs", "data", "census_2016.csv"))
census_2016 <- janitor::clean_names(census_2016)

names(census_2016)


### Select demographic data to include, relating to employment, income, immigration status, minority groups, commute, etc. ###
# Many categories
# demographic_info <- c(1, 6, 8:33, 60:67, 100:104, 661:663, 694:707, 724:726, 1135:1136, 1139, 1140:1150, 1157, 1158, 1170, 1188, 1198, 1216, 1287, 1289:1292, 1324:1337, 1683:1697, 1884:1929)

# Narrowed down categories
demographic_info <- c(1, 8, 1324, 1290, 1917)


### Function to get data from specific regions and rows ###

get_region_data <- function(y){
  census_2016 %>%
    filter(geo_code_por == y,
           member_id_profile_of_health_regions_2247 %in% demographic_info) %>%
    select(dim_profile_of_health_regions_2247, member_id_profile_of_health_regions_2247, dim_sex_3_member_id_1_total_sex, dim_sex_3_member_id_2_male, dim_sex_3_member_id_3_female)
}

### Get data from the randomly selected Health Regions ###

ontario <- get_region_data(35)

haliburton <- get_region_data(3535)
hamilton <- get_region_data(3537)
algoma <- get_region_data(3526)
simcoe_muskoka <- get_region_data(3560)
timiskaming <- get_region_data(3563)
windsor_essex <- get_region_data(3568)

northwest <- get_region_data(3549)
# southwestern <- get_region_data(3502)
# Southwestern is a newer health unit. it was created by almagamating oxford and elgin-st. thomas units:
oxford <- get_region_data(3552)
elgin <- get_region_data(3531)
waterloo <- get_region_data(3565)
durham <- get_region_data(3530)
sudbury <- get_region_data(3561)
brant <- get_region_data(3527)


### Put together demographic info in one table ###

populationss <- c("Total_Population", "Indigenous_Population_25%_sample", "Visible_Minority_25%_sample", "Accommodation_and_Food_Services_25%_sample", "Total_Population_Women")

get_pop_info <- function(x){
  c(as.numeric(x$dim_sex_3_member_id_1_total_sex[x$dim_profile_of_health_regions_2247 == "Population, 2016"]),
    as.numeric(x$dim_sex_3_member_id_1_total_sex[x$dim_profile_of_health_regions_2247 == "Aboriginal identity"]),
    as.numeric(x$dim_sex_3_member_id_1_total_sex[x$dim_profile_of_health_regions_2247 == "Total visible minority population"]),
    as.numeric(x$dim_sex_3_member_id_1_total_sex[x$dim_profile_of_health_regions_2247 == "72 Accommodation and food services"]),
    as.numeric(x$dim_sex_3_member_id_3_female[x$dim_profile_of_health_regions_2247 == "Total - Age groups and average age of the population - 100% data"]))
}

ontario_pop <- get_pop_info(ontario)

haliburton_pop <- get_pop_info(haliburton)
algoma_pop <- get_pop_info(algoma)
hamilton_pop <- get_pop_info(hamilton)
windsor_essex_pop <- get_pop_info(windsor_essex)
simcoe_muskoka_pop <- get_pop_info(simcoe_muskoka)
timiskaming_pop <- get_pop_info(timiskaming)

brant_pop <- get_pop_info(brant)
sudbury_pop <- get_pop_info(sudbury)
#southwestern_pop <- get_pop_info(southwestern)
oxford_pop <- get_pop_info(oxford)
elgin_pop <- get_pop_info(elgin)
northwest_pop <- get_pop_info(northwest)
waterloo_pop <- get_pop_info(waterloo)
durham_pop <- get_pop_info(durham)





populations <- bind_cols(populationss, ontario_pop, haliburton_pop, algoma_pop, hamilton_pop, windsor_essex_pop, simcoe_muskoka_pop, timiskaming_pop, brant_pop, sudbury_pop, oxford_pop, elgin_pop, northwest_pop, waterloo_pop, durham_pop)

colnames(populations) <- c("Info", "Ontario", "Haliburton", "Algoma", "Hamilton", "Windsor_Essex", "Simcoe_Muskoka", "Timiskaming",
                           "Brant", "Sudbury", "Oxford", "Elgin", "Northwest", "Waterloo", "Durham")

populations <- populations %>%
  mutate(Southwestern = Oxford + Elgin) %>%
  mutate(total_treat = Haliburton + Algoma + Hamilton + Windsor_Essex + Simcoe_Muskoka + Timiskaming,
         total_control = Brant + Sudbury + Northwest + Waterloo + Durham + Southwestern) %>%
  select(-Oxford, -Elgin)
  


populations_percentage <- tibble(
  c("Ontario", "Haliburton", "Algoma", "Hamilton", "Windsor_Essex", "Simcoe_Muskoka", "Timiskaming", 
    "Brant", "Sudbury", "Northwest", "Waterloo", "Durham", "Southwestern",
    "Total_Treat", "Total_Control"),
  as.numeric(populations %>% select(-Info) %>% slice(1)),
  as.numeric(populations %>% select(-Info) %>% slice(2)),
  as.numeric(populations %>% select(-Info) %>% slice(3)),
 as.numeric(populations %>% select(-Info) %>% slice(5))
)
colnames(populations_percentage) <-   c("area", "total_population", "indigenous_percentage", "visible_minority_percentage", "women_percentage")

populations_percentage <- populations_percentage %>%
  mutate(indigenous_percentage = indigenous_percentage / total_population,
         visible_minority_percentage = visible_minority_percentage / total_population,
         women_percentage = women_percentage / total_population)
  
write_csv(populations_percentage, here("outputs", "data", "demographic_percentage.csv"))


populations_split <- matrix(ncol=4, nrow=5)
populations_split[,1] <- c("Total_Population", "Indigenous_Population_25%_sample", "Visible_Minority_25%_sample", "Accommodation_and_Food_Services_25%_sample", "Total_Population_Women")
populations_split[,2] <- ontario_pop

total_pop_treatment <- sum(populations[1,c(3:8)])
indigenous_treatment <- sum(populations[2,c(3:8)])
minority_treatment <- sum(populations[3,c(3:8)])
food_services_treatment <- sum(populations[4,c(3:8)])
women_treatment <- sum(populations[5,c(3:8)])

treatment <- c(total_pop_treatment, indigenous_treatment, minority_treatment, food_services_treatment, women_treatment)
populations_split[,3] <- treatment

total_pop_control <- sum(populations[1,c(9:14)])
indigenous_control <- sum(populations[2,c(9:14)])
minority_control <- sum(populations[3,c(9:14)])
food_services_control <- sum(populations[4,c(9:14)])
women_control <- sum(populations[5,c(9:14)])

control <- c(total_pop_control, indigenous_control, minority_control, food_services_control, women_control)
populations_split[,4] <- control

populations_split <- as.data.frame(populations_split)
colnames(populations_split) <- c("Info", "Ontario", "Treatment", "Control")

populations_split



### Get percentage proportions of demographic groups of interest ###

populations_split_percentage <- matrix(ncol=4, nrow=5)

for(i in 2:length(populations_split)){
  for(j in 1:5){
    populations_split_percentage[j,i] <- round(as.numeric(populations_split[j,i])/as.numeric(populations_split[1,i]), digits=3)
  }
}

#populations_percentage[1, 2:4] <- c(1, 1, 1)
populations_split_percentage[,1] <- c("Total_Population", "Indigenous_Population_25%_sample", "Visible_Minority_25%_sample", "Accommodation_and_Food_Services_25%_sample", "Total_Population_Women")

populations_split_percentage <- as.data.frame(populations_split_percentage)
colnames(populations_split_percentage) <- c("Info", "Ontario", "Treatment", "Control")


### Write to separate .csv files ###

#write_csv(populations_split, here("inputs", "data", "demographic_split_number.csv"))
write_csv(populations_split_percentage, here("outputs", "data", "demographic_split_percentage.csv"))
