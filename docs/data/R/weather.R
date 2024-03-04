ntt2 <- function(x){
  tmp = lubridate::seconds_to_period(x)
  hour = tmp@hour
  minute = tmp@minute
  if(hour>12){
    hour = hour-12
    ampm = "pm"
  } else if(hour==12){
    ampm = "pm"
  } else {
    ampm = "am"
  }
  
  label = paste(sprintf("%02d:%02d", hour, minute), ampm)
  if(hour<10){
    label = str_remove(label, pattern = "0")
  }
  return(label)
}

ntt2_vec <- Vectorize(ntt2)


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
