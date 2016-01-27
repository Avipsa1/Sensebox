library(shiny)
library(leaflet)
library(dygraphs)
library(rCharts)
library(ggplot2)
library(rHighcharts)

# Define UI for random distribution application
shinyUI(fluidPage(

  # Application title
  titlePanel("Scene Selection"),

    sidebarLayout(
    sidebarPanel(
      radioButtons("scene", "Select a Scene:",
                   c("Mysterious",
                     "Serene",
                     "Dramatic",
                     "Scenic")),
      br(),

      selectInput("time",
                  "Time of the Day",
                   choices = c("Morning",
                               "Afternoon",
                               "Evening"))
    ),

    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel("OpenPICMap", leafletOutput("map"),
                 br(),
                 tags$div("_____________________________________________________________________________________________________________________"),
                 br(),
                 tags$h6("Sample Photograph"),
                 imageOutput("pic",height = "200px", width = "400px")),
                 #img(src = 'Mysterious.jpg', height = 200, width = 400)),
        tabPanel("Qualifying Conditions",plotOutput("Bar")),
        tabPanel("Actual Atmospheric Conditions", dygraphOutput("timeseries")),
                 br(),
                 #plotOutput("Bar")),
        tabPanel("DataSets", tableOutput("table"))
      )
    )
  )
))
