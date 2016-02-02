library(shiny)
library(leaflet)
library(rCharts)
library(dygraphs)
library(ggplot2)
library(zoo)
library(rHighcharts)
library(png)
library(xts)
library(plotly)
# Define server logic for the display of data
shinyServer(function(input, output) {

  path <- c("~/R/Sensebox/data")
  df <- read.csv(paste(path,"/Data.csv",sep = ""))
  mys <- df[df$Humidity>80 & df$Temperature>4 & df$Temperature<8,]
  ser <- df[df$Soundvalue<100 & df$Windspeed<1,]
  dra <- df[df$Windspeed>0.2 & df$Lux<1000,]
  
  #Read the locations where the data was recorded and display on the map
  output$map <- renderLeaflet({
    
    lng = df$Longitude
    lat = df$Latitude
    map <- leaflet(width = 400, height = 1500) %>% 
           setView(7.575488,51.97512, zoom = 16) %>%
           addTiles() %>%
           addMarkers(lng = lng, lat = lat,popup = "Gievenbeck")
    map
  })

  # Generate image corresponding to a scene in the locations marked on the map
  output$pic <- renderImage({
    if (input$time == "Morning" && input$scene == "Mysterious")
    {
      return(list(
        src = "www/mystic1.jpg",
        contentType = "image/jpg",
        alt = "mystic1"
      ))
    }
    else if (input$time == "Afternoon" && input$scene == "Mysterious")
    {
      return(list(
        src = "www/mystic2.jpg",
        contentType = "image/jpg",
        alt = "mystic2"
      ))
    }
    else if (input$time == "Evening" && input$scene == "Mysterious")
      return(list(
        src = "www/mystic3.jpg",
        contentType = "image/jpg",
        alt = "mystic3"
      ))
    
    else if (input$time == "Morning" && input$scene == "Dramatic")
      return(list(
        src = "www/dramatic1.jpg",
        contentType = "image/jpg",
        alt = "dramatic1"
      ))
    
    else if (input$time == "Afternoon" && input$scene == "Dramatic")
      return(list(
        src = "www/dramatic2.jpg",
        contentType = "image/jpg",
        alt = "dramatic2"
      ))
    
    else if (input$time == "Evening" && input$scene == "Dramatic")
      return(list(
        src = "www/dramatic3.jpg",
        contentType = "image/jpg",
        alt = "dramatic3"
      ))
    
    else if (input$time == "Morning" && input$scene == "Scenic")
      return(list(
        src = "www/scenic1.jpg",
        contentType = "image/jpg",
        alt = "scenic1"
      ))
    
    else if (input$time == "Afternoon" && input$scene == "Scenic")
      return(list(
        src = "www/scenic2.jpg",
        contentType = "image/jpg",
        alt = "scenic2"
      ))
    
    else if (input$time == "Evening" && input$scene == "Scenic")
      return(list(
        src = "www/scenic3.jpg",
        contentType = "image/jpg",
        alt = "scenic3"
      ))
    
    else if (input$time == "Morning" && input$scene == "Serene")
      return(list(
        src = "www/serene1.jpg",
        contentType = "image/jpg",
        alt = "serene1"
      ))
    
    else if (input$time == "Afternoon" && input$scene == "Serene")
      return(list(
        src = "www/serene2.jpg",
        contentType = "image/jpg",
        alt = "serene2"
      ))
    
    else if (input$time == "Evening" && input$scene == "Serene")
      return(list(
        src = "www/serene3.jpg",
        contentType = "image/jpg",
        alt = "serene3"
      ))
    
  },deleteFile = FALSE)
  
  # Generate a summary of the weather conditions that contribute to the scene
  
  output$Conditions <- renderImage({
    
    if(input$scene == "Mysterious")
      return(list(
        src = "www/mys_contrib.png",
        contentType = "image/png",
        alt = "contrib1"
      ))
    #if(input$scene == "Scenic")
    if(input$scene == "Serene")
      return(list(
        src = "www/ser_contrib.png",
        contentType = "image/png",
        alt = "contrib2"
      ))
    if(input$scene == "Dramatic")
      return(list(
        src = "www/drm_contrib.png",
        contentType = "image/png",
        alt = "contrib3"
      ))
#     bardata = data.frame(Conditions =
#                            factor(c("Fog", "Darkness", "Twilight"),
#                            levels = c("Fog", "Darkness", "Twilight")),
#                            Contribution = c(mean(df$Humidity/100), 
#                                             mean(df$Windspeed), 
#                                             mean(df$Distance/10, na.rm = TRUE)))

#     g1 <- ggplot(bardata,aes(Conditions,Contribution)) + 
#           geom_bar(stat = "identity") + xlab("Conditions") + 
#           ylab("Contribution")
#     g1
  },deleteFile = FALSE)
  
  output$timeseries <- renderDygraph({
      time_index <- seq(from = as.POSIXct("2016-01-23 06:00"), 
                      to = as.POSIXct("2016-01-23 18:00"), 
                      by = "hour")
      df$Humidity <- df$Humidity/100
      df$Temperature <- df$Temperature/10
      df$Lux <- NULL
      df$Longitude <- NULL
      df$Latitude <- NULL
      df$Soundvalue <- df$Soundvalue/100
      df$Distance <- df$Distance/10
      value <- df[12:24,2:6]
      plotdata <- xts(value, order.by = time_index)
      dygraph(plotdata)
  })
  
  # Generate an HTML table view of the data
  output$table <- renderDataTable({
    if(input$scene == "Mysterious")
      mys
    else if(input$scene == "Serene")
      ser
    else if(input$scene == "Dramatic")
      dra
  })
  

})
