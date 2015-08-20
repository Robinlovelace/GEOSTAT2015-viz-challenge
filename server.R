library(shiny)
library(leaflet)
library(sp)
library(lubridate)
library(dplyr)
library(raster)
library(gstat)
library(RColorBrewer)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  source("setup.R")
  source("R/krige-setup.R")

  dIn <- reactive({
    ptype <- switch(input$ptype, liquid = 4, solid = 8)
    sel <- d$time > input$end_date[[1]] & # times more than the start time and..
      d$time < input$end_date[[2]] & # times less than the end time
      d$precip_type == levels(df$precip_type)[ptype] &
      !is.na(d$precip_type == levels(df$precip_type)[ptype]) &
      d$altitude_m > input$alt[[1]] & d$altitude_m < input$alt[[2]]
    d[sel, ]
  })


  output$distPlot <- renderPlot({
    d <- dIn()
    d$dt <- round_date(d$time, unit = "month")
    group_by(d@data, dt) %>%
      summarise(Monthly_precip = mean(precip_mm)) ->
      dag
    lmod <- lm(Monthly_precip ~ dt, data = dag)
    par(bg='lightyellow')
    plot(dag,ylab='Monthly Precipitation',xlab='Date',type='b',ylim=c(0,25))
    abline(lmod,lty=2)
  })

  output$map <- renderLeaflet({
    d <- dIn()

    d_uniq <- group_by(d@data, rdb_id) %>%
      summarise(x = mean(lonWGS84),
        y = mean(latWGS84),
        Mean_precip = mean(precip_mm, na.rm = T))

    d_uniq <- as.data.frame(d_uniq)
    coordinates(d_uniq) <- ~x+y
    d_uniq <- d_uniq[!is.na(d_uniq$Mean_precip),] # remove na's

    # create raster layer
    m <- vgm(.59, "Sph", 874, .04)
    kr <- krige(formula = Mean_precip~ 1, locations = d_uniq, newdata = gddf)
    r <- raster(kr)
    proj4string(r) <- CRS("+init=epsg:4326")
    colfun <- function(x) colorRamp(brewer.pal(6,'YlOrRd'), interpolate='spline')(x^0.333)
    qpal <- colorNumeric(palette = colfun, domain = d_uniq$Mean_precip, na.color = "grey")
    qpal2 <- colorNumeric(palette = "YlOrRd", domain = values(r), na.color = "grey")

    if(input$dtype == "Points"){

      leaflet() %>%
        addProviderTiles("Esri.WorldTerrain") %>%
        addCircles(data = d_uniq, color = ~qpal(Mean_precip), opacity = 0.6, radius = 8, group = "Points") %>%
        addLegend(pal = qpal, values = d_uniq$Mean_precip, title = "mm/day")
    } else{
      leaflet() %>%
        addProviderTiles("Esri.WorldTerrain") %>%
        addRasterImage(r, opacity = 0.5, colors = qpal2(r@data@values), group = "Raster") %>%
        addLegend(pal = qpal2, values = values(r))
    }

    })

  output$text <- renderText(paste(input$end_date[[1]], input$end_date[[2]]))
})