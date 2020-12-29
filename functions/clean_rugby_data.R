clean_rugby_data <- function(data){
  
  players_names <- data %>% 
  mutate(surname = str_extract(name,
                               "[A-z-']+$"), .after = name) %>% 
  mutate(first_names = str_remove(name," [A-z-']+$"), .after = name) %>% 
  mutate(surname = ifelse(str_detect(first_names,"van der"), paste("van der", surname), surname)) %>% 
  mutate(first_names = str_remove(first_names, "van der")) %>% 
  mutate(surname = ifelse(str_detect(first_names,"du"), paste("du", surname), surname)) %>% 
  mutate(first_names = str_remove(first_names,"du")) %>% 
  mutate(surname = ifelse(str_detect(first_names,"di"), paste("di", surname), surname)) %>% 
  mutate(first_names = str_remove(first_names,"di")) %>% 
  select(-name)

players_births <- players_names %>% 
  mutate(born = str_remove_all(born,"\n")) %>% 
  # Extract Brith loctaion
  mutate(birth_location = 
           str_extract(born, "[^,0-9)][A-z-& ]*[ A-z'-.?&]+$"), .after = born) %>%
  # Extract Birth Date
  mutate(born_temp = 
           str_extract(born, "^[A-z0-9', ]*[0-9]{4}"), .after = born) %>% 
  # Flag if exact Birth date is unknown if there is just a year
  mutate(approx_brithdate = str_detect(born_temp, "circa") | 
           str_detect(born_temp, "[A-z]+ [0-9]{4}"), .after = born_temp) %>% 
  mutate(born_temp = str_remove(born_temp, "circa ")) %>% 
  
  # Get Birth dates if there is only month and year
  mutate(birth_date = case_when(
    str_detect(born_temp, "[A-z0-9 ]+, [0-9]{4}") ~ mdy(born_temp),
    str_detect(born_temp, "[A-z]+ [0-9]{4}") ~ myd(born_temp, truncated = 1),
    TRUE ~ ymd(born_temp, truncated = 2)), .after = born 
  )

# Get Birthdates
players_births <- players_births %>% 
  mutate(birth_location = coalesce(birth_location,"Not Available")) %>%
  mutate(birth_location = str_replace(birth_location, "[^a-z]\\?", "Not Available")) %>% 
  mutate(approx_birth_location = str_detect(birth_location, "\\?"), .after = birth_location) %>% 
  mutate(birth_location = str_remove(birth_location, "\\?")) %>% 
  mutate(birth_location = str_remove(birth_location, "date unknown,")) %>%
  mutate(birth_location =str_squish(birth_location)) %>% 
  
  select(-born, -born_temp)



players_debut <- players_births %>% 
  mutate(debut_date = str_extract(debut, "[A-z 0-9]+, [0-9]{4}"), .after = debut) %>% 
  mutate(debut_date = mdy(debut_date)) %>% 
  mutate(debut_match = str_extract(debut, "^[A-z -]+"), .after = debut) %>% 
  separate(debut_match, into = c("debut_match", "debut_location"), sep = " at ") %>% 
  select(-debut) %>% 
  rowid_to_column("cap_no") 


players_stats <- players_debut %>% 
  mutate(stats = str_remove_all(stats, "'")) %>% 
  mutate(matches_played = str_extract(stats, "Mat: [0-9]*")) %>% 
  mutate(matches_played = str_remove(matches_played, "Mat: ")) %>% 
  mutate(match_starts = str_extract(stats, "Start: [0-9]*")) %>% 
  mutate(match_starts= str_remove(match_starts, "Start: ")) %>% 
  mutate(sub_starts = str_extract(stats, "Sub: [0-9]*")) %>% 
  mutate(sub_starts= str_remove(sub_starts, "Sub: ")) %>%
  mutate(points = ifelse(
    str_detect(stats, "Goals:"), 
    str_extract(stats, "Goals: [0-9]*"), 
    str_extract(stats, "Pts: [0-9]*")
  )) %>% 
  mutate(points = ifelse(
    str_detect(points, "Goals:"), 
    str_remove(points, "Goals: "), 
    str_remove(points, "Pts: ")
  )) %>% 
  mutate(tries = str_extract(stats, "Tries: [0-9]*")) %>% 
  mutate(tries = str_remove(tries, "Tries: ")) %>%
  mutate(converstions = str_extract(stats, "Conv: [0-9]*")) %>% 
  mutate(converstions = str_remove(converstions, "Conv: ")) %>%
  mutate(penalties = str_extract(stats, "Pens: [0-9]*")) %>% 
  mutate(penalties = str_remove(penalties, "Pens: ")) %>%
  mutate(drop_goals = str_extract(stats, "Drop: [0-9]*")) %>% 
  mutate(drop_goals = str_remove(drop_goals, "Drop: ")) %>%
  mutate(goals_from_mark = str_extract(stats, "GfM: [0-9]*")) %>% 
  mutate(goals_from_mark = str_remove(goals_from_mark, "GfM: ")) %>%
  mutate(won = str_extract(stats, "Won: [0-9]*")) %>% 
  mutate(won = str_remove(won, "Won: ")) %>%
  mutate(lost = str_extract(stats, "Lost: [0-9]*")) %>% 
  mutate(lost = str_remove(lost, "Lost: ")) %>%
  mutate(draw = str_extract(stats, "Draw: [0-9]*")) %>% 
  mutate(draw= str_remove(draw, "Draw: ")) %>% 
  mutate(across(matches_played:draw, as.numeric)) %>% 
  select(-stats) %>% 
  mutate(win_rate = won/matches_played)

return(players_stats)
}

