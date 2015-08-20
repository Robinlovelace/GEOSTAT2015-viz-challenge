library(shiny)
library(leaflet)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Hello Shiny!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(

      selectInput("dtype", "Display", c("Points", "Raster cells", "Hexbins")),

    sliderInput("end_date", dragRange = TRUE,
      "End date:",
      min = strptime("2008-01-01 UTC", format = "%Y-%m-%d", tz = "UTC"),
      max = strptime("2010-12-31 UTC", format = "%Y-%m-%d", tz = "UTC"),
      value = c(strptime("2008-01-01 UTC", format = "%Y-%m-%d", tz = "UTC"),
        strptime("2010-12-31 UTC", format = "%Y-%m-%d", tz = "UTC")),
      timeFormat = "%F"),
      selectInput("ptype", "Precipitation type:", choices = c("liquid","solid")),
      plotOutput("distPlot"),
      textOutput("text")

  ),

    # Show a plot of the generated distribution
    mainPanel(
     leafletOutput(outputId = "map")
    )
  )
))