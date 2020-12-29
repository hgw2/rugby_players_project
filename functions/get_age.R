get_age <- function(dob, date){
  interval_period <- interval(dob, date)
  full_years <- interval_period %/% years(1)
  full_days <- interval_period %% years(1) %/% days(1)
  paste(full_years, "years,", full_days, "days")
}