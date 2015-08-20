df <- read.csv("data/df.csv")
head(df$date)
library(lubridate)
df$time <- dmy(df$date)