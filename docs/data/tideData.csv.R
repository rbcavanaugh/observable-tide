library(lubridate)
library(ggplot2)
library(rtide)
library(dplyr)
library(readr)
library(stringr)
library(glue)
library(tidyr)
library(purrr)
library(htmltools)

tideData = rtide::tide_height(
  "Casco Bay", #
  from = Sys.Date()-15, to = Sys.Date()+75,
  minutes = 10L, tz =  "EST5EDT" # "UTC" #
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

cat(format_csv(tideData))

