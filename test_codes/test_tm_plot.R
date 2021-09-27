vaccine_data <- readr::read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/country_data/Nepal.csv")



vaccine_data %>% separate(, remove = F)
  

View(data)

theme <- theme_classic() +
  theme(
    axis.line.y = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank(),
    legend.position = "bottom"
  )


Merkel

ggplot(data, aes(x = date, y = number, col = event, label = milestone)) +
  geom_hline(yintercept = 0, color = "black", size = 0.3) +
  geom_segment(
    aes(
      y = position,
      yend = 0, xend = date
    ),
    color = "black", size = 0.2
  ) +
  geom_point(aes(y = position), size = 3) +
  geom_text(
    aes(
      x = date,
      y = -0.15, 
      label = format(date, '%b') 
    ),
    size = 3.5, vjust = 0.5, 
    hjust = -1, color = "black", angle = 90
  ) +
  theme
