library(tidyverse)
library(lubridate)
library(janitor)
library(miceadds)
source.all("functions/")

dir.create("4_clean_data/temp")

# Home Nations
countries <- c("england", "scotland", "wales", "ireland")

for (i in 1:length(countries)){

  country <- countries[i]
  
  file_path <- paste("2_raw_data/", country, ".csv", sep  = "")
  
  country_data <- read_csv(file_path)
  
  clean_data <- clean_rugby_data(country_data) %>% 
    mutate(country = str_to_title(country)) %>% 
    fix_home_nation_location()
  
  dir_path <- paste("4_clean_data/", country, sep ="")
  
  dir.create(dir_path)
  
  
  clean_file_path <- paste("4_clean_data/",country, "/", country, "_clean", ".csv", sep  = "")
  clean_data %>% 
    write_csv(clean_file_path)
  
  clean_file_path <- paste("4_clean_data/temp/", country, ".csv", sep  = "")
  clean_data %>% 
    write_csv(clean_file_path)
}

# Clean France Data

france <- read_csv("2_raw_data/france.csv")

clean_data <- clean_rugby_data(france) %>% 
  mutate(country = "France") %>% 
  fix_france_location()

dir_path <- paste("4_clean_data/france")

dir.create(dir_path)



clean_data %>% 
  write_csv("4_clean_data/france/france_clean.csv")


clean_data %>% 
  write_csv("4_clean_data/temp/france_clean.csv")


italy <- read_csv("2_raw_data/italy.csv")

clean_data <- clean_rugby_data(italy) %>% 
  mutate(country = "Italy") %>% 
  fix_italy_location()

dir_path <- paste("4_clean_data/italy")

dir.create(dir_path)



clean_data %>% 
  write_csv("4_clean_data/italy/italy_clean.csv")


clean_data %>% 
  write_csv("4_clean_data/temp/italy_clean.csv")


files <- c()

for (file in list.files("4_clean_data/temp")){
  file_path <- paste("4_clean_data/temp/", file, sep = "")
  files <- c(files, file_path)
}

complete_data <- NULL

for (file in files){
  part_data <- read_csv(file)
  complete_data <-bind_rows(complete_data, part_data)
  
}

complete_data %>% 
  relocate(country, .before = cap_no) %>% 
  write_csv("4_clean_data/full_table.csv")

unlink("4_clean_data/temp/", recursive = TRUE)