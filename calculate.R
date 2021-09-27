
# read file for data
# readr::read_csv("https://bit.ly/trackvacnepal", col_types = readr::cols()) -> vaccine_nepal


# calculate percent
vaccine_nepal |>
  # slice(n()) |>
  mutate(
    population = 29674920, # https://www.macrotrends.net/countries/NPL/nepal/population-growth-rate
    target_pop = 21756763, # target population above 18+ set by Gov. of Nepal
    full_total_per = round(full_total / population * 100, 1),
    first_total_per = round(first_total / population * 100, 1), 
    full_target_per = round(full_total / target_pop * 100, 1),
    first_target_per = round(first_total / target_pop * 100, 1),
  ) -> latest_vac_data




## create progressr
progressr <- c(
  "▱▱▱▱▱▱▱▱▱▱", 
  "▰▱▱▱▱▱▱▱▱▱",
  "▰▰▱▱▱▱▱▱▱▱", 
  "▰▰▰▱▱▱▱▱▱▱",
  "▰▰▰▰▱▱▱▱▱▱", 
  "▰▰▰▰▰▱▱▱▱▱", 
  "▰▰▰▰▰▰▱▱▱▱", 
  "▰▰▰▰▰▰▰▱▱▱", 
  "▰▰▰▰▰▰▰▰▱▱", 
  "▰▰▰▰▰▰▰▰▰▱", 
  "▰▰▰▰▰▰▰▰▰▰"
)

# create function to get progress
progress_vac_data <- \(data, var_name, col, col2, name) {
  data |>
    mutate(
      {{ var_name }} :=
        case_when(
          {{ col }} == 0 ~ progressr[1],
          between({{ col }}, 1, 10) ~ progressr[2],
          between({{ col }}, 10, 20) ~ progressr[3],
          between({{ col }}, 20, 30) ~ progressr[4],
          between({{ col }}, 30, 40) ~ progressr[5],
          between({{ col }}, 40, 50) ~ progressr[6],
          between({{ col }}, 50, 60) ~ progressr[7],
          between({{ col }}, 60, 70) ~ progressr[8],
          between({{ col }}, 70, 80) ~ progressr[9],
          between({{ col }}, 80, 90) ~ progressr[10],
          between({{ col }}, 90, 100) ~ progressr[11]
        )
    ) |>
    select({{ var_name }}, total_per = {{ col }}, target_per = {{ col2 }})
}

# call progress function and save it

progress_vac_data(latest_vac_data, bar, full_total_per, full_target_per) -> full
progress_vac_data(latest_vac_data, bar, first_total_per, first_target_per, ) -> first
