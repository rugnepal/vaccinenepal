# load library
if(!require(pacman)) {install.packages('pacman')}; 
pacman::p_load(here, rtweet, dplyr, tidyr, stringr, googledrive, tabulizer);

# library(ggplot2)

# print(getwd())

# call source file
# source("progressr.R")
source("pdf_download.R")
source("latest_data.R")
source("calculate.R")

# get twitter api and tokens / secrets
twitter_token <- create_token(
  app = Sys.getenv("APPNAME"),
  consumer_key = Sys.getenv("KEY"),
  consumer_secret = Sys.getenv("SECRET"),
  access_token = Sys.getenv("ACCESS_TOKEN"),
  access_secret = Sys.getenv("ACCESS_SECRET")
)

# post a tweet from R

post_tweet(
  paste0(
    "Fully Vaccinated: ", full$total_per, " %", "\t \t \t [", full$target_per, "%]*", 
    "\n", full$bar, "\n \n",
    "First Dose: ", first$total_per, " %", "\t \t \t [", first$target_per, "%)*", 
    "\n", first$bar, "\n \n",
    "Last Updated: ", format(Sys.Date(), "%b %d, %Y"), "\n \n",
    "Note: [%]* - Target (Eligible) Population (2,17,56,763)"
  )
)




