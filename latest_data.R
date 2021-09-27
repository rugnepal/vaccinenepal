pdf_file <- here::here(paste0(Sys.Date(), "-siterep.pdf"))

pdf <- extract_text(
  file = pdf_file,
  pages = 1
)


raw_list <- as.list(unlist(strsplit(pdf, "\\\n")))
raw_results <- sapply(raw_list, toString)
raw_results <- gsub("[\r\n]", "", raw_results)

row_index <- \(data, str) {
  str_locate(data, c(str)) |>
    as.data.frame() |>
    tibble::rowid_to_column() |>
    filter(!is.na(start))
}

row_index(raw_results, str = "COVID-19 Updates") -> start_up

row_index(raw_results, str = "Active Case") -> end_up

row_index(raw_results, str = " 1st Dose | Fully Vaccinated") -> vaccine


raw_results |>
  as.data.frame() |>
  slice(start_up$rowid:end_up$rowid[2]) -> sum_update

sum_update |>
  slice(2:7) |>
  mutate(updates = str_replace_all(
    raw_results,
    "[:alpha:]|[:punct:]", ""
  ), 
  updates = format(as.numeric(updates), format="d", big.mark=",")) |> 
  as.list() -> covid

# 
# raw_results[vaccine$rowid + 1] |>
#   as.data.frame() |>
#   separate(
#     col = 1,
#     into = c("people_vaccinated", "people_fully_vaccinated"),
#     sep = " "
#   ) |>
#   mutate_if(is.character, as.numeric) -> vaccine_nepal



data.frame(
  first_total = raw_results[vaccine$rowid + 1] |> as.numeric(), 
  full_total = raw_results[vaccine$rowid + 3] |> as.numeric()
  # first_target_per = raw_results[vaccine$rowid + 2] |> str_replace_all("\\(|\\)", "") |> str_squish() , 
  # full_target_per = raw_results[vaccine$rowid + 4] |> str_replace_all("\\(|\\)", "") |> str_squish()
) -> vaccine_nepal



