library(httr)
library(tidyverse)
library(rvest)
library(here)


health_depts <- read_html("https://www.inspection.gc.ca/food-safety-for-industry/information-for-consumers/report-a-concern/restaurants-and-food-services/eng/1323139279504/1323140830752")


write_html(health_depts, here::here("inputs/raw_health_depts.html"))


text_data <- health_depts %>%
  html_nodes('body') %>%
  html_nodes('main') %>%
  html_nodes('div') %>%
  html_nodes('details') %>%
  html_nodes('p') %>%
  html_text()

all_depts <- tibble(dept = text_data)

all_depts <-
  all_depts %>%
  slice(9:41)

all_depts <- all_depts %>%
  separate(col = "dept",
           into = c("Name", "Areas"),
           sep = " \\(",
           remove = TRUE) %>%
  mutate(Areas = str_remove(Areas, "\\)"))


flat_page <- readLines(con = "https://www.inspection.gc.ca/food-safety-for-industry/information-for-consumers/report-a-concern/restaurants-and-food-services/eng/1323139279504/1323140830752")

write_lines (flat_page, here::here("inputs/flat_page_health_depts.txt"))


depts = all_depts$Name
urls = c()
for (i in 1:length(depts))
{
  # the line position that the dept name first appears in
  pos = as.numeric(grep(pattern = depts[i], x = flat_page)[1])
  # we take that line and the six following line, and compress into one string
  # from https://stackoverflow.com/questions/36882470/in-r-how-to-filter-lines-containing-substring
  url = str_c(flat_page[pos:(pos+6)], sep = "  ", collapse = TRUE)
  urls = append(urls, url)
}

all_depts <- bind_cols(all_depts, urls)

all_depts <- all_depts %>%
  rename("urls" = "...3")

all_depts <- all_depts %>%
  separate(col = "urls",
           into = c("Before", "Target"),
           sep = "a href=",
           remove = TRUE)

all_depts <-
  all_depts %>%
  separate(col = "Target",
           into = c("Before2", "URL"),
           sep = '"',
           remove = TRUE) %>%
  select(-Before, - Before2)

write_csv(all_depts, here::here("inputs/all_health_depts.csv"))