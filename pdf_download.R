## googledrive::drive_deauth()

drive_auth(cache = ".secrets", email = "bjungbogati@gmail.com")

link <- as_id('1OcGKoZxTqdTWw6h0MfrEeXwg0PXaBaWa')
paths <- drive_ls(path = link)
# latest_folder <- as_id(paths$id[1])

latest_folder  <- paths |> 
  filter(stringr::str_detect(name, paste(format(Sys.Date(), "%d-%m-%Y")) )) |> 
  as_id()

latest_file <- drive_ls(path = latest_folder) |> 
  filter(stringr::str_detect(name, "EN" )) |> as_id()
  

drive_download(latest_file, 
               path = here::here(paste0(Sys.Date(), "-siterep.pdf")), 
               overwrite = T)



