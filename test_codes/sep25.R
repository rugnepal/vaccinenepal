


data <- pdf[[1]] %>%
  filter(row_number() > 5 & row_number() < 13) %>% 
  setNames(c("province")) %>% 
  mutate(values = str_replace_all(province, c("Province 1" = "", 
                                                "Province 2" = "", 
                                                "Bagmati" = "", 
                                                "Gandaki" = "", 
                                                "Lumbini" = "", 
                                                "Karnali" = "", 
                                                "Sudurpaschim" = ""
  )), 
  province = c("Province 1", 
               "Province 2", 
               "Bagmati", 
               "Gandaki", 
               "Lumbini", 
               "Karnali", 
               "Sudurpaschim")
  )  %>% 
  mutate(values = str_replace_all(values, "\\(|\\)", " "), 
         values = str_squish(values))



data_2 <- data %>%
  # mutate(date = data |> pull(2) |> tail(1) |> substring(7, 18) |> dmy()) %>%
  # slice(-n(), -(n() - 1)) %>%
  separate(
    col = 2,
    into = c(
      "1. First dose__covishield",
      "1. First dose 24 hrs__covishield",
      "2. Second dose__covishield",
      "2. Second dose 24 hrs__covishield",
      "1. First dose__verocell",
      "1. First dose 24 hrs__verocell",
      "2. Second dose__verocell",
      "2. Second dose 24 hrs__verocell",
      "3. Full dose__johnson",
      "3. Full dose 24 hrs__johnson"
    ),
    sep = " "
  ) |> 
  pivot_longer(
    col = 2:11,
    names_to = "vaccine",
    values_to = "number"
  ) %>%
  separate(
    col = vaccine,
    into = c("dose", "vaccine_brand"),
    sep = "__"
  ) %>%
  mutate(
    number = number |> as.numeric(),
    province = forcats::fct_reorder(province, number, .desc = F)
  )


saveRDS(data_2, "C:/Users/m1s1n/Documents/R/webinaRs/2021-09-25/province_wise_vaccinated.rds")

