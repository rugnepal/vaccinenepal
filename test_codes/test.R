library(ggplot2)
library(tidyverse)


# latest_vac_data <- data.frame(population =  29710722,
#                               people_fully_vaccinated = 1745903, 
#                               people_vaccinated = 3936724, 
#                               full_vac_per = 0, 
#                               partial_vac_per = 0, 
#                               date = Sys.Date() - 1
#                               )
# library(dplyr)
# 
# latest_vac_data <- latest_vac_data |> mutate(full_vac_per = round(people_fully_vaccinated / population * 100, 2) , 
#                           partial_vac_per = round(people_vaccinated / population * 100, 2)
#                           
# )










# read file for data
readr::read_csv("https://bit.ly/trackvacnepal", 
                col_types = readr::cols()) -> vaccine_nepal


 lk <- \(x) {
  number_format(
    accuracy = 1,
    # prefix = "",
    scale = 0.00001,
    suffix = " Lakh",
    big.mark = ","
  )(x)
}

library(scales)

vaccine_nepal |> 
  janitor::clean_names() |> 
  pivot_longer(col = 5:7, 
               names_to = "status", 
               values_to = "number") |> 
  group_by(status) |> 
  mutate(daily_num = number - lag(number, default = 0)) |>
  filter(status != "total_vaccinations") |> 
  ggplot(aes(x = date, y = number, color = status)) +
  geom_line() +
  scale_y_continuous(breaks = c(0, 500000, 1000000, 1500000, 2000000), labels = lk) +
  # coord_flip() +
  bbplot::bbc_style() +
  theme(
    # axis.text.x= element_text(size = 0.6),
    legend.position = "bottom", plot.margin = unit(c(1, 1, 1, 1), "cm")) +
  # facet_grid(~dose) +
  labs(title = paste0("Nepal Covid-19 Vaccines Number in Lakh (Grants & Purchases)")) +
  scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))
# geom_text(aes(label= lk(number)), position=position_dodge(width=0.9), hjust = 1, vjust=0.25)



names(vaccine_nepal)
