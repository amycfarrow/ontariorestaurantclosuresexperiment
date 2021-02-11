library(tidyverse)
library(here)

set.seed(24)

all_depts <- read_csv(here::here("inputs/all_health_depts.csv"))

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


all_depts <- all_depts %>%
  mutate(Size = map_chr(Name, assign_size_group))
# https://dcl-prog.stanford.edu/purrr-mutate.html





group_A <- all_depts %>% filter(Size == "A")
group_B <- all_depts %>% filter(Size == "B")
group_C <- all_depts %>% filter(Size == "C")

treatment_control_groups <-
  tibble(Group = c("Treatment", "Control"),
         Large = pull(sample_n(group_A, size = 2, replace = FALSE),  Name),
         Medium = pull(sample_n(group_B, size = 2, replace = FALSE), Name),
         Small = pull(sample_n(group_C, size = 2, replace = FALSE), Name)
  )