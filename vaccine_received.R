

library(tabulizer)
library(tidyverse)
library(lubridate)
library(scales)

# readr::read_csv("https://bit.ly/trackvacnepal", col_types = readr::cols()) |>
#   slice(n()) |> pull(4) -> pdf_file


pdf_file <- "siterep.pdf"

pdf <- extract_tables(
  file = pdf_file,
  # method = "decide",
  # output = "data.frame",
  pages = 3
)

row_index <- \(data, str) {
  str_locate(data, c(str)) |>
    as.data.frame() |>
    tibble::rowid_to_column() |>
    filter(!is.na(start))
}

row_index(pdf[[1]], "Total") -> covid_up

pdf[[1]] |>
  as.data.frame() |>
  slice(1:covid_up$rowid[1]) -> received

pdf[[1]] |>
  as.data.frame() |>
  slice(covid_up$rowid[1]:covid_up$rowid[2]) -> available

pdf[[1]] |>
  as.data.frame() |>
  slice(covid_up$rowid[2]:covid_up$rowid[3]) -> estimated

data <- received |>
  filter(row_number() > 5) |>
  select(name = V1, values = V3)

data |>
  separate(
    col = values,
    into = c("dose", "country"),
    sep = "Lakh"
  ) |>
  mutate(country = str_trim(country, side = "both")) -> new


new |> separate(
  col = "country",
  into = c("country", "date", "via", "txt1", "txt2", "txt3", "txt4"),
  sep = " "
) -> new2

new2 |> filter(date != "NA") -> new2

new2 |>
  filter(name != "") |>
  mutate(via = case_when(
    txt4 == "Aid" ~ "Aid",
    txt2 == "Aid" ~ "Aid",
    is.na(txt4) ~ "Procured",
    is.na(txt2) ~ "Procured"
  )) -> new3

new3 |>
  mutate(
    name = str_replace_all(name, "[:digit:]", ""),
    name = if_else(row_number() == 2, "COVISHIELD (Nepal Army)", str_trim(name)),
    country = if_else(country == "GAVI", "Covax", country),
    dose = as.numeric(dose) * 100000,
    n = c(rep(1, 7), 5)
  ) -> new4
# slice(rep(8, each = 3)) |> View()
# purrr::map_dfr(slice(rep(8, each = 3)), ~new2) |>  View()

new4 |> View()

new4 |>
  tidyr::uncount(n) |>
  mutate(date = case_when(
    row_number() == 8 ~ "9-Jul-21",
    row_number() == 9 ~ "22-Jul-21",
    row_number() == 10 ~ "23-Jul-21",
    row_number() == 11 ~ "25-Jul-21",
    row_number() == 12 ~ "30-Jul-21",
    date == "Aid" ~ "21-Jan-21",
    TRUE ~ date
  ) |> as.Date(format = "%d-%b-%y")) |>
  select(1:5) -> received_vol

# received_vol |>
#   mutate( dose = if_else(via == "Procured" & name == "VEROCELL",
#                          800000, dose)) -> received_3


received_vol |> filter(!row_number() %in% 8:11) -> received_filter


# money <- fontawesome('fa-money')
# aid <- fontawesome('fa-plus')
# 
# received_filter |>
#   mutate(via_sym = if_else(via == "Aid", aid,  money
#          ) ) -> received_filter

received_filter |> View()


available |> View()


available |> slice(c(3,4,5), 7) |> select(name = V1, 3) |> 
  mutate(V3 = str_trim(V3)) |> 
  separate(col = 2, 
      into = c("dose", "country", "via"),
      sep = "Lakh") |> 
  mutate(via = if_else(str_detect(country, "Aid"), "Aid", "Procured"), 
         country = str_extract(country, "[^ ]+"), 
         name = str_replace_all(name, "[:digit:]", ""), 
         dose = as.numeric(dose) * 100000, 
         country = str_replace_all(country, "Sinopharm,", "China"),
         )  -> available_data


estimated |> 
  filter(row_number() > 2, !V1 %in% c("", "Total")) |>
  select(name = V1, values = V3) |> 
  mutate(name = str_replace_all(name, "[:digit:]", ""), 
         name = str_trim(name),
         name = if_else(row_number() %in% 2:3, "Moderna", name)) |> 
  separate(col = 2, 
           into = c("dose", "country", "via"), 
           sep = "Lakh") |> 
  separate(col = country, 
           into = c("c2", "country", "via"), 
           sep = " ") |> 
  mutate(country = str_replace_all(country, ",", ""), 
         dose = as.numeric(dose) * 100000,
         via = case_when(
           
           via == "Reimbursement" ~ "Reimburse by World Bank",
           via == "Expense" ~ "Expense Sharing", 
           via == "Government" ~ "Procurement", 
           TRUE ~ via
         )) |> 
  select(-c2) -> estimated_data

estimated_data


