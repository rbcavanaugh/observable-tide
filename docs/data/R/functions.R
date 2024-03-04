
lat = "43.6591"
lon = "-70.2568"
key = "191dbef06b4554059d0b0e17fec2e1d2"#Sys.getenv("WEATHER")
cnt = "2"
part = "hourly"
units = "imperial"

#print(nchar(key))

url <- glue("https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&units={units}&appid={key}")

weatherData <- fromJSON(url)

#weatherData <- readRDS(file = "weatherTest.rds")



ntt2 <- function(x){
  tmp = lubridate::seconds_to_period(x)
  hour = tmp@hour
  minute = tmp@minute
  if(isTRUE(hour>12)){
    hour = hour-12
    ampm = "pm"
  } else if(isTRUE(hour==12)){
    ampm = "pm"
  } else {
    ampm = "am"
  }
  
  label = paste(sprintf("%02d:%02d", hour, minute), ampm)
  if(isTRUE(hour<10)){
    label = str_remove(label, pattern = "0")
  }
  return(label)
}

ntt2_vec <- Vectorize(ntt2)

getTideData <- function(){
 rtide::tide_height(
  "Casco Bay", #
  from = Sys.Date()-15, to = Sys.Date()+15,
  minutes = 10L, tz = "EST5EDT"
) %>%
  tidyr::separate(DateTime, c("date", "time"), sep = " ", remove = F) %>%
  mutate(date = ymd(date),
         time = minutes(time),
         #time = hms(time),
         dateFactor = as.factor(date),
         ttip = ntt2_vec(DateTime))
}

degrees_to_compass = function(x) {
  breaks = c(0, 45, 90, 135, 180, 225, 270, 315, 360)
  labels = c("NNE", "ENE", "ESE", "SSE", "SSW", "WSW", "WNW", "NNW")
  cut(x, breaks, labels, include.lowest = TRUE)
}

getWeatherData <- function(){
  weatherData$daily %>%
    unnest(cols = c("temp", "weather")) %>%
    mutate(dt = as.Date(as_datetime(dt)),
           sunrise = format(as_datetime(sunrise, tz = "EST5EDT"), "%I:%M %p"),
           sunset = format(as_datetime(sunset, tz = "EST5EDT"), "%I:%M %p"),
           wind_avg = round(wind_speed, 0),
           wind_gust = round(wind_gust, 0),
           wind_dir = degrees_to_compass(wind_deg)) %>%
    rename(DateTime = dt, dayTemp = day, maxTemp = max) %>%
    select(-night, -eve, -morn) %>%
    unnest(cols = "feels_like") %>%
    select(DateTime, sunrise, sunset,
           dayTemp, maxTemp, feelsTemp = day,
           description, pop, wind_avg, wind_gust, wind_dir
    ) %>%
    mutate(dayTemp = paste0(round((dayTemp + maxTemp)/2, 0), " degrees"),
           feelsTemp = paste0(round(feelsTemp, 0), " degrees"),
           pop = ifelse(pop<0.05, "< 5%", pop)) %>%
    mutate(precip = ifelse(pop=="< 5%", pop, scales::percent(as.numeric(pop), accuracy = 1)))
}

getPlot <- function(selectedDat, tideDat){
  
  willard =
    tribble(
      ~time, ~start, ~end,
      "morning", hours(7), hours(9),
      "evening", hours(20), hours(21)
    )
  
  p =  ggplot(data = selectedDat, aes(x = time, y = TideHeight)) +
    geom_rect(inherit.aes = FALSE,data = willard,
              aes(xmin=hours(7), xmax=hours(9), ymin=-Inf, ymax=Inf), alpha = 0.1, fill = "#00C08B") +
    geom_rect(inherit.aes = FALSE,data = willard,
              aes(xmin=hours(20), xmax=hours(21), ymin=-Inf, ymax=Inf), alpha = 0.1, fill = "#00C08B") +
    geom_line(data = tideDat, alpha = 0.1) +
    stat_peaks(colour = "black") +
    stat_valleys(colour = "black") +
    geom_line() +
    
    scale_x_time(
      name = NULL,
      breaks=hours(seq(0,24,3)),
      labels=c("midnight","3am", "6am", "9am", "noon", "3pm", "6pm", "9pm", "midnight")) +
    scale_y_continuous(name = "Tide Height (m)",
                       breaks = seq(-1, 4, 0.5),
                       labels = seq(-1, 4, 0.5)) +
    coord_cartesian(clip = 'off') +
    theme_minimal(base_size = 20) +
    theme(axis.text.x=element_text(angle=45, hjust=1))
  
  dat = ggplot_build(p)
  peak_dat = dat$data[[4]][,c("x", "y")] %>% rowwise() %>% mutate(label = ntt2(x))
  valley_dat = dat$data[[5]][,c("x", "y")] %>% rowwise() %>% mutate(label = ntt2(x))
  
  p_text = p + 
    annotate("text", size = 6,
             x = c(peak_dat$x,valley_dat$x),
             y = c(peak_dat$y+.15,valley_dat$y-.15),
             label = c(peak_dat$label, valley_dat$label))
  
  return(p_text)
}

#getPlot(p1, tideData)

# 
# getPlotInt <- function(selectedDat, tideDat){
#   p = 
#     selectedDat %>% print %>%
#     ggplot(aes(x = time, y = TideHeight)) +
#     geom_line(data = tideDat, alpha = 0.1) +
#      stat_peaks(colour = "black") +
#      stat_valleys(colour = "black") +
#      geom_line() +
#     geom_point_interactive(aes(tooltip = ttip, data_id = ttip), alpha = 0.005) +
#      scale_x_time(
#        name = "Time",
#        breaks=hours(seq(0,24,3)),
#        labels=c("midnight","3am", "6am", "9am", "noon", "3pm", "6pm", "9am", "midnight")) +
#      scale_y_continuous(name = "Tide Height (m)",
#                         breaks = seq(-1, 4, 0.5),
#                         labels = seq(-1, 4, 0.5)) +
#      theme_minimal(base_size = 14) +
#      theme(axis.text.x=element_text(angle=45,hjust=1))
# 
#   dat = ggplot_build(p)
#   peak_dat = dat$data[[2]][,c("x", "y")] %>% rowwise() %>% mutate(label = ntt2(x))
#   valley_dat = dat$data[[3]][,c("x", "y")] %>% rowwise() %>% mutate(label = ntt2(x))
# 
#   p_text = p +
#     annotate("text",
#              x = c(peak_dat$x,valley_dat$x),
#              y = c(peak_dat$y+.15,valley_dat$y-.15),
#              label = c(peak_dat$label, valley_dat$label))
#   
#   return(p_text)
# }

getTextSummary <- function(dailyWeather, date){
  
  alert = weatherData$alerts$event
  
  if(is_empty(alert)){
    a = "None"
  } else {
    a = paste(alert, collapse = ", ")
  }
  
  sunrise = dailyWeather[which(dailyWeather$DateTime==date),]$sunrise
  sunset = dailyWeather[which(dailyWeather$DateTime==date),]$sunset
  probPrecip = dailyWeather[which(dailyWeather$DateTime==date),]$precip
  highTemp = dailyWeather[which(dailyWeather$DateTime==date),]$dayTemp
  feelsTemp = dailyWeather[which(dailyWeather$DateTime==date),]$feelsTemp
  description = dailyWeather[which(dailyWeather$DateTime==date),]$description
  wind = dailyWeather[which(dailyWeather$DateTime==date),]$wind_avg
  gust = dailyWeather[which(dailyWeather$DateTime==date),]$wind_gust
  dir = dailyWeather[which(dailyWeather$DateTime==date),]$wind_dir

  sunText = glue("Sunrise is at {tags$b(sunrise)} and sunset ends at {tags$b(sunset)}.")
  tempText = glue("The forecast for {tags$b(format(date, '%B %d'))} is for {tags$b(description)} with a high temperature around {tags$b(highTemp)} (feels like {tags$b(feelsTemp)}).")
  windText = glue("Winds will average {tags$b(wind)} {tags$b('mph')} {tags$b(dir)} with gusts up to {tags$b(gust)} {tags$b('mph')}.")
  rainText = glue("The chance of precipitation is {tags$b(probPrecip)}.")
  alertText = glue("Alerts: {tags$b(a)}")

  textOut = paste(sunText, tempText, windText, rainText, alertText)

  return(tags$p(HTML(textOut), class = "text"))
}

