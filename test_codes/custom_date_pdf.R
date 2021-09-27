## googledrive::drive_deauth()

drive_auth(cache = ".secrets", email = "bjungbogati@gmail.com")

link <- as_id("1OcGKoZxTqdTWw6h0MfrEeXwg0PXaBaWa")
paths <- drive_ls(path = link)
# latest_folder <- as_id(paths$id[1])

latest_folder <- paths |>
  filter(stringr::str_detect(
    name,
    paste(format(
      as.Date("2021-08-02"),
      "%d-%m-%Y"
    ))
  )) |>
  as_id()

latest_file <- drive_ls(path = latest_folder) |>
  filter(stringr::str_detect(name, "EN")) |>
  as_id()


drive_download(latest_file,
  path = here::here("siterep.pdf"),
  overwrite = T
)
