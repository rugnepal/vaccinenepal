
# load library
if(!require(pacman)) {install.packages('pacman')}; 
pacman::p_load(here, rtweet, dplyr, tidyr, stringr, googledrive, tabulizer);

# library(ggplot2)

# print(getwd())

# call source file
source("pdf_download.R")
source("latest_data.R")

# get twitter api and tokens / secrets
twitter_token <- create_token(
  app = Sys.getenv("APPNAME"),
  consumer_key = Sys.getenv("KEY"),
  consumer_secret = Sys.getenv("SECRET"),
  access_token = Sys.getenv("ACCESS_TOKEN"),
  access_secret = Sys.getenv("ACCESS_SECRET")
)

# emoji <- c('🔬','🏥','💚','💉','💀','🛌', '🗓')

emoji <- c('☑')

post_tweet(
paste0(
  
  "Covid19 Nepal Update - Last 24 hrs \n\n",
  # emoji[1], " Sample Tested: ", covid$updates[1], "\n",
  emoji, " New Cases: ", covid$updates[2], " (incl. Antigen) \n",
  emoji, " Recovered: ", covid$updates[3], "\n",
  emoji, " Vaccinated: ", covid$updates[4], "\n",
  emoji, " Deaths: ", covid$updates[5], "\n",
  emoji, " Active Cases: ", covid$updates[6], "\n\n",
  emoji, " Last Updated: ", format(Sys.Date(), "%b %d, %Y"), "\n\n",
  
  "#Covid19 #Nepal"
)
)
