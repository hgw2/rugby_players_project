library(ggmap)
source("~/credentials/api_key.R")

register_google(api_key)

full_data <- read_csv("4_clean_data/full_table.csv")

full_locations <- full_data %>% 
  select(cap_no, country, birth_location) %>% 
  filter(birth_location != "Not Available") %>% 
  mutate_geocode(birth_location) 
  

full_data %>% 
  left_join(full_locations) %>% 
  write_csv("5_geocode/complete_locations.csv")


