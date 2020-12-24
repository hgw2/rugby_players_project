library(tidyverse)
library(lubridate)
library(janitor)
library(ggmap)
source("functions/get_rugby_data.R")
source("~/credentials/api_key.R")

register_google(api_key)


countries <- c("england", "scotland", "wales", "ireland", "france", "italy")

for (i in 1:length(countries)){

  country <- countries[i]
  
  file_path <- paste("2_raw_data/", country, ".csv", sep  = "")
  
  country_data <- read_csv(file_path)
  
  clean_data <- clean_rugby_data(country_data) %>% 
    mutate(country = str_to_title(country)) %>% 
    mutate_geocode(birth_location)
  
  
  clean_file_path <- paste("4_clean_data/", country, "_clean", ".csv", sep  = "")
  clean_data %>% 
    write_csv(clean_file_path)
}