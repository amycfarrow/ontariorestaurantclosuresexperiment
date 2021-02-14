#### Preamble ####
# Purpose: Stratify health units by population and select a treatment and control from each strata. 
# Author: Amy Farrow
# Date: 2021-01-10
# Contact: amy.farrow@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have run 01_scrape_health_depts.R


#### Workspace setup ####
library(tidyverse)
library(here)

### Get data ###
# Read in the list of health departments
all_depts <- read_csv(here::here("inputs/data/all_health_depts.csv"))


### Stratify health units by population ###

# Using the data here, from 2017:
# https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=1710012201
# We made a list of health departments by population, sorted from high to low, and split the list into 3 groups:
# Large populations (400,000+), Medium populations (150,000 - 400,000), and Small (< 150,000)
# Note that the most recently available data was from 2013
# Some health units amalgamated over 2017-2021, so their populations were added and entered for the amalgamated unit.

# This function applies labels based on which group the health unit falls into:
assign_size_group <- function (name) {
  if(name %in% c("Toronto",
                 "Region of Peel",
                 "York Region",
                 "Ottawa",
                 "Durham Region",
                 "Hamilton",
                 "Region of Waterloo",
                 "Simcoe Muskoka",
                 "Halton Region",
                 "Middlesex-London",
                 "Niagara Region")) {
    "A"
  }
  else if(name %in% c("Windsor-Essex County",
                      "Wellington-Dufferin-Guelph",
                      "Eastern Ontario",
                      "Sudbury and Districts",
                      "Southwestern Ontario",
                      "Kingston, Frontenac and Lennox and Addington",
                      "Haliburton, Kawartha, Pine Ridge District",
                      "Leeds, Grenville and Lanark District",
                      "Hastings and Prince Edward Counties",
                      "Grey Bruce",
                      "Thunder Bay District")) {
    "B"
  }
  else if(name %in% c("Brant County",
                      "Huron Perth County",
                      "Lambton County",
                      "North Bay Parry Sound",
                      "Algoma",
                      "Haldimand-Norfolk",
                      "Chatham-Kent",
                      "Renfrew County and District",
                      "Porcupine Health Unit",
                      "Northwestern Health",
                      "Timiskaming")) {
    "C"
  }
}

# Apply the function (using https://dcl-prog.stanford.edu/purrr-mutate.html)
all_depts <- all_depts %>%
  mutate(Size = map_chr(Name, assign_size_group))

# From each size group, randomly sampling one to be in the treatment group and one to be in the control.
set.seed(24)
treatment_control_groups <-
  tibble(Group = c("Treatment", "Control"),
         Large = pull(sample_n(all_depts %>% filter(Size == "A"), size = 2, replace = FALSE),  Name),
         Medium = pull(sample_n(all_depts %>% filter(Size == "B"), size = 2, replace = FALSE), Name),
         Small = pull(sample_n(all_depts %>% filter(Size == "C"), size = 2, replace = FALSE), Name)
  )

### Save sampling ###
write_csv(treatment_control_groups, here::here("outputs/treatment_control_groups.csv"))