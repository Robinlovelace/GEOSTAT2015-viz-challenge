library(shiny)
library(leaflet)
library(sp)
library(lubridate)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  source("setup.R")

  dIn <- reactive({
    d[d$time > input$start_date & d$time < input$end_date, ]
  })

  output$distPlot <- renderPlot({
    d <- dIn()
    d$dt <- round_date(d$time, unit = "month")
    dag <- group_by(d@data, dt) %>%
      summarise(Monthly_precip = mean(precip_mm))
    lmod <- lm(Monthly_precip ~ dt, data = dag)
    plot(dag)
    abline(lmod)
  })

  output$map <- renderLeaflet(leaflet() %>% addTiles() %>% addCircles(data = dIn(), opacity = 0.2))
})