library(shiny)
library(leaflet)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Hello Shiny!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(

      sliderInput("start_date",
        "Start date:",
        min = strptime("2008-01-01 UTC", format = "%Y-%m-%d", tz = "UTC"),
        max = strptime("2010-12-31 UTC", format = "%Y-%m-%d", tz = "UTC"),
        value = strptime("2008-01-01 UTC", format = "%Y-%m-%d", tz = "UTC"),
        timeFormat = "%F"),
    sliderInput("end_date",
      "End date:",
      min = strptime("2008-01-01 UTC", format = "%Y-%m-%d", tz = "UTC"),
      max = strptime("2010-12-31 UTC", format = "%Y-%m-%d", tz = "UTC"),
      value = strptime("2010-12-31 UTC", format = "%Y-%m-%d", tz = "UTC"),
      timeFormat = "%F"),
      plotOutput("distPlot")
  ),

    # Show a plot of the generated distribution
    mainPanel(
     leafletOutput(outputId = "map")
    )
  )
))