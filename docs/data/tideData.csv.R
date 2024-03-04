library(lubridate)
library(ggplot2)
library(rtide)
library(dplyr)
library(readr)
library(ggpmisc)
library(stringr)
library(httr)
library(glue)
library(jsonlite)
library(tidyr)
library(purrr)
library(htmltools)
library(glue)

#source("R/key.R")
source("./docs/data/R/functions.R")
# saveRDS(weatherData, "wd.rds")
# saveRDS(tideData, "td.rds")
# 
# weatherData = readRDS("wd.rds")
# tideData = readRDS("td.rds")

tideData = rtide::tide_height(
  "Casco Bay", #
  from = Sys.Date()-15, to = Sys.Date()+15,
  minutes = 1L, tz =  "EST5EDT" # "UTC" #
) %>%
  tidyr::separate(DateTime, c("date", "time"), sep = " ", remove = F) %>%
  mutate(
         est_time = with_tz(DateTime, tzone="America/New_York"),
         est_date = as.Date(est_time),
         time = hms::as_hms(time),
         time = if_else(is.na(time), hms::hms(0, 0, 0), time),
         time = as.POSIXct(paste(Sys.Date(), time)),
         dateFactor = paste0("a",str_remove_all(as.character(date), "-"))#,
         #tideColor = TideHeight
         ) %>%
    filter(hour(time)> 2 & hour(time) < 21)


#getTideData()
#print(head(tideData))
cat(format_csv(tideData))

