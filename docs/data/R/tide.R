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

getTideData <- function(){
 rtide::tide_height(
  "Casco Bay", #
  from = Sys.Date()-15, to = Sys.Date()+15,
  minutes = 10L, tz = "EST5EDT"
) %>%
  tidyr::separate(DateTime, c("date", "time"), sep = " ", remove = F) %>%
  mutate(date = ymd(date), time = hms(time), dateFactor = as.factor(date),
         ttip = ntt2_vec(DateTime))
}


getPlot <- function(selectedDat, tideDat){
  p =  ggplot(data = selectedDat, aes(x = time, y = TideHeight)) +
    geom_line(data = tideDat, alpha = 0.1) +
    stat_peaks(colour = "black") +
    stat_valleys(colour = "black") +
    geom_line() +
    scale_x_time(
      name = "Time",
      breaks=hours(seq(0,24,3)),
      labels=c("midnight","3am", "6am", "9am", "noon", "3pm", "6pm", "9am", "midnight")) +
    scale_y_continuous(name = "Tide Height (m)",
                       breaks = seq(-1, 4, 0.5),
                       labels = seq(-1, 4, 0.5)) +
    coord_cartesian(clip = 'off') +
    theme_minimal(base_size = 20) +
    theme(axis.text.x=element_text(angle=45, hjust=1))
  
  dat = ggplot_build(p)
  peak_dat = dat$data[[2]][,c("x", "y")] %>% rowwise() %>% mutate(label = ntt2(x))
  valley_dat = dat$data[[3]][,c("x", "y")] %>% rowwise() %>% mutate(label = ntt2(x))
  
  p_text = p + 
    annotate("text", size = 6,
             x = c(peak_dat$x,valley_dat$x),
             y = c(peak_dat$y+.15,valley_dat$y-.15),
             label = c(peak_dat$label, valley_dat$label))
  
  return(p_text)
}


# 
# rtide::tide_height(
#   "Casco Bay", #
#   from = Sys.Date()-60, to = Sys.Date()+60,
#   minutes = 10L, tz = "EST5EDT"
# ) %>%
#   tidyr::separate(DateTime, c("date", "time"), sep = " ", remove = F) %>%
#   mutate(date = ymd(date), time = hms(time), dateFactor = as.factor(date),
#          ttip = ntt2_vec(DateTime))
# 
# 
# t = harmonics
