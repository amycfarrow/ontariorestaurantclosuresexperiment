#### Preamble ####
# Purpose: Stratify health units by population and select a treatment and control from each strata. 
# Author: Amy Farrow
# Date: 2021-01-10
# Contact: amy.farrow@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have run 01, 03, and 03 scripts


#### Workspace setup ####
library(tidyverse)
library(here)

### Get data ###

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

write_csv(all_units_data, here("outputs/data/all_units_data.csv"))

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
  mutate(verify = str_sub(address, -3, -1)) %>%
  mutate(ID = pull(tibble(sample(seq(1, first(count(table_for_surveys)), by = 1), size = first(count(table_for_surveys)), replace = FALSE)))) %>%
  select(-surveyed)

write_csv(table_for_surveys, here::here("outputs/table_for_surveys.csv"))