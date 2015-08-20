# aim: download data used in the challenge

# install.packages("googlesheets")

library(googlesheets)
library(magrittr)

# setup
gs_gap() %>%
  gs_copy(to = "Gapminder")
#
# gs_ls()

gs1 <- googlesheets::gs_url("https://docs.google.com/spreadsheets/d/1vwEFSpq-NraENZNxzmS1MMf4PyXsUz93p9pjCKe02do/edit#gid=0")
df <- googlesheets::gs_read(gs1)
head(df)
dir.create("data")
write.csv(df, "data/df.csv")
