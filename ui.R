require(shiny)
require(leaflet)
require(dygraphs)
require(rCharts)
require(ggplot2)
require(rHighcharts)
require(leaflet)
library(shinydashboard)

# Define UI for random distribution application
shinyUI(fluidPage(

  # Application title
  titlePanel(img(src = "logo.png")),

    sidebarLayout(
    sidebarPanel(
        radioButtons("scene", "Scene Selection:",
                   c("Mysterious",
                     "Serene",
                     "Dramatic"
                     #"Scenic"
                     )),
      br(),

      selectInput("time",
                  "Time of the Day",
                   choices = c("Morning",
                               "Afternoon",
                               "Evening"))
    ),

    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(fluidPage(
      tabsetPanel(type = "tabs",
        tabPanel("Picture Map", leafletOutput("map"),
                 br(),
                 tags$div("_____________________________________________________________________________________________________________________"),
                 br(),
                 tags$h2("Sample Photograph"),
                 imageOutput("pic",height = "100px", width = "100px")
                 ),
                 
        tabPanel("Qualifying Conditions",imageOutput("Conditions")),
        
        tabPanel("Actual Atmospheric Conditions", 
                fluidRow(
                  box(dygraphOutput("timeseries"),width = 9),
                  box(textOutput("legendDivID"), title = "Legend", collapsible = TRUE, width=3)
                )
        ),
                 br(),
        
        tabPanel("DataSets", dataTableOutput("table"))
      )
    ))
  )
))
