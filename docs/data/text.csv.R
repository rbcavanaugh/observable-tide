library(lubridate)
library(ggplot2)
library(rtide)
library(dplyr)
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
dailyWeather = getWeatherData()

y = as.Date(Sys.time(), tz = "EST5EDT")-1
getTextSummary(dailyWeather = dailyWeather, date = y)

t = as.Date(Sys.time(), tz = "EST5EDT")
getTextSummary(dailyWeather = dailyWeather, date = t)

tm = as.Date(Sys.time(), tz = "EST5EDT")+1
getTextSummary(dailyWeather = dailyWeather, date = tm)

