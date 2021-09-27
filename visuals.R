

lk <- \(x) {
  number_format(
    accuracy = 1,
    # prefix = "",
    scale = 0.00001,
    suffix = " Lakh",
    big.mark = ","
  )(x)
}


received_filter |>
  ggplot(aes(
    x = date, y = dose, shape = via, color = name,
    size = dose 
  ),
  # shape = via_sym,
  width = 0.5
  ) +
  geom_point() +
  labs(title = "Covid-19 Vaccine Received by Nepal") +
  # geom_text(aes(label=via_sym),family='fontawesome-webfont', size=6)+
  scale_y_continuous(
    labels = lk,
    expand = c(.1, .1),
    breaks = c(0, 1000000, 2000000, 3000000, 4000000)
  ) +
  scale_x_date(
    date_breaks = "1 month", date_minor_breaks = "1 day",
    date_labels = "%b"
  ) +
  # scale_shape_manual(values = c(3, 5)) +
  coord_flip() +
  bbplot::bbc_style() +
  theme(
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    legend.position = "bottom",
    legend.box = "vertical",
    legend.margin = margin(),
    legend.text = element_text(
      size = 14,
      # family=c('fontawesome-webfont', 'Arial')
    ),
    # legend.key.size = unit(4),
    axis.text.x = element_text(size = 17)
  ) +
   guides(color = guide_legend(override.aes = list(size=3)),
          shape = guide_legend(override.aes = list(size=3))
          ) +
  scale_size(guide = "none") -> received_plot


received_plot

bbplot::finalise_plot(
  plot_name = received_plot,
  source = paste("Source: mohp.gov.np | ", "Date: July 22, 2021",  " | By: Nepal Vaccine Tracker (@vaccinenepal)"),
  save_filepath = paste0("July 22, 2021", "-covid-vaccine-received.png"),
  width_pixels = 720,
  height_pixels = 400
  # logo_image_path = "nm-vertical-logo.png"
)


available_data |> 
  ggplot(aes(
    x = name, y = dose, fill = via
  ),
  # shape = via_sym,
  width = 0.5
  ) +
  labs(title = "Nepal's Covid-19 Vaccine (Arrival on Sep-Oct 2021)")+
  scale_y_continuous(
    labels = lk,
    # expand = c(.1, .1),
    breaks = c(0,  2000000,  4000000,  6000000, 8000000)
  ) +
  geom_col() +
  coord_flip() +
  bbplot::bbc_style() +
  theme(
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    legend.position = "bottom",
    legend.text = element_text(
      size = 14,
      # family=c('fontawesome-webfont', 'Arial')
    ),
    # legend.key.size = unit(4),
    axis.text.x = element_text(size = 17)
  )  -> arrival_plot
  



bbplot::finalise_plot(
  plot_name = arrival_plot,
  source = paste("Source: mohp.gov.np | ", "Date: July 22, 2021"),
  save_filepath = paste0("July 22, 2021", "-covid-vaccine-arrival.png"),
  width_pixels = 720,
  height_pixels = 400
  # logo_image_path = "nm-vertical-logo.png"
)






