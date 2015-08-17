# aim: download data used in the challenge

install.packages("googlesheets")

library(googlesheets)
library(magrittr)

gs_gap() %>%
  gs_copy(to = "Gapminder")
## or, if you don't use pipes
gs_copy(gs_gap(), to = "Gapminder")

gs_ls()

gs1 <- googlesheets::gs_url("https://docs.google.com/spreadsheets/d/1vwEFSpq-NraENZNxzmS1MMf4PyXsUz93p9pjCKe02do/edit#gid=0")
df <- googlesheets::gs_read(gs1)
head(df)