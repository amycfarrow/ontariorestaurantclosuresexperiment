#### Preamble ####
# Purpose: Stratify health units by population and select a treatment and control from each strata. 
# Author: Amy Farrow
# Date: 2021-01-10
# Contact: amy.farrow@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have run 01_scrape_health_depts


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

set.seed(19893)
treatment_control_groups <-
  tibble(Group = c("Treatment", "Treatment", "Control", "Control"),
         Large = pull(sample_n(all_depts %>% filter(Size == "A"), size = 4, replace = FALSE),  Name),
         Medium = pull(sample_n(all_depts %>% filter(Size == "B"), size = 4, replace = FALSE), Name),
         Small = pull(sample_n(all_depts %>% filter(Size == "C"), size = 4, replace = FALSE), Name)
  )



### Save sampling ###
write_csv(treatment_control_groups, here::here("outputs/treatment_control_groups.csv"))

all_units_data <- read_csv(here::here("outputs/data/all_units_data.csv"))
## assign groups on table of all treatment and control restaurants
all_units_data <- all_units_data %>%
  mutate(group = case_when(unit == "hamilton" ~ "treatment",
                           unit == "simcoe" ~ "treatment",
                           unit == "haliburton" ~ "treatment",
                           unit == "windsor" ~ "treatment",
                           unit == "algoma" ~ "treatment",
                           unit == "timiskaming" ~ "treatment",
                           unit == "durham" ~ "control",
                           unit == "waterloo" ~ "control",
                           unit == "southwestern" ~ "control",
                           unit == "sudbury" ~ "control",
                           unit == "brant" ~ "control",
                           unit == "northwestern" ~ "control"
  )) %>%
  select(-type)


# construct table to conduct the survey from.

all_treat <- all_units_data %>%
  filter(group == "treatment")

all_control <- all_units_data %>%
  filter(group == "control")


set.seed(19893)
table_for_surveys <- bind_rows(
  all_treat %>%
    mutate(surveyed = sample(x = c("yes", "no"),
                             size = first(count(all_treat)),
                             prob = c(0.15, 0.85),
                             replace = TRUE
    )) %>%
    filter(surveyed == "yes"),
  all_control %>%
    mutate(surveyed = sample(x = c("yes", "no"),
                             size = first(count(all_control)),
                             prob = c(0.15, 0.85),
                             replace = TRUE
    )) %>%
    filter(surveyed == "yes")
) 

set.seed(19893)
table_for_surveys <- table_for_surveys %>%
  mutate(verify = substr(address, -3, -1)) %>%
  mutate(ID = pull(tibble(sample(seq(1, first(count(table_for_surveys)), by = 1), size = first(count(table_for_surveys)), replace = FALSE)))) %>%
  select(-surveyed)

write_csv(table_for_surveys, here::here("outputs/table_for_surveys.csv"))
