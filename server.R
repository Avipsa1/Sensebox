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

  #path <- c("~/R/Sensebox/data")
  df <- read.csv("Data.csv")
  mys <- df[df$Humidity>80 & df$Temperature>4 & df$Temperature<8,c(2,10,3:9)]
  ser <- df[df$Soundvalue<100 & df$Windspeed<1,c(2,10,3:9)]
  dra <- df[df$Windspeed>0.2 & df$Lux<1000,c(2,10,3:9)]
  
  #Read the locations where the data was recorded and display on the map
  output$map <- renderLeaflet({
    
    if(input$scene == "Mysterious")
    {
    lng = df$Longitude
    lat = df$Latitude
    leafIcons <- icons(iconUrl = "http://leafletjs.com/docs/images/leaf-green.png",
                       iconWidth = 38, iconHeight = 95,
                       iconAnchorX = 22, iconAnchorY = 94,
                       shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
                       shadowWidth = 50, shadowHeight = 64,
                       shadowAnchorX = 4, shadowAnchorY = 62)
    map <- leaflet(width = 400, height = 1500) %>% 
           setView(7.575488,51.97512, zoom = 12) %>%
           addTiles() %>%
           addMarkers(lng = lng, lat = lat,icon = leafIcons)
    }
    else if (input$scene == "Serene")
    {
      lng = df$Longitude
      lat = df$Latitude
      leafIcons <- icons(iconUrl = "http://leafletjs.com/docs/images/leaf-red.png",
                         iconWidth = 38, iconHeight = 95,
                         iconAnchorX = 22, iconAnchorY = 94,
                         shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
                         shadowWidth = 50, shadowHeight = 64,
                         shadowAnchorX = 4, shadowAnchorY = 62)
      map <- leaflet(width = 400, height = 1500) %>% 
        setView(7.575488,51.97512, zoom = 12) %>%
        addTiles() %>%
        addMarkers(lng = lng, lat = lat,icon = leafIcons)
    }
    else if (input$scene == "Dramatic")
    {
      lng = df$Longitude
      lat = df$Latitude
      leafIcons <- icons(iconUrl = "http://leafletjs.com/docs/images/leaf-orange.png",
                         iconWidth = 38, iconHeight = 95,
                         iconAnchorX = 22, iconAnchorY = 94,
                         shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
                         shadowWidth = 50, shadowHeight = 64,
                         shadowAnchorX = 4, shadowAnchorY = 62)
      map <- leaflet(width = 400, height = 1500) %>% 
        setView(7.575488,51.97512, zoom = 12) %>%
        addTiles() %>%
        addMarkers(lng = lng, lat = lat,icon = leafIcons)
    }
    map
  })

  # Generate image corresponding to a scene in the locations marked on the map
  output$pic <- renderImage({
    if (input$time == "Morning" && input$scene == "Mysterious")
    {
      return(list(
        src = "mystic1.jpg",
        contentType = "image/jpg",
        alt = "mystic1"
      ))
    }
    else if (input$time == "Afternoon" && input$scene == "Mysterious")
    {
      return(list(
        src = "mystic2.jpg",
        contentType = "image/jpg",
        alt = "mystic2"
      ))
    }
    else if (input$time == "Evening" && input$scene == "Mysterious")
      return(list(
        src = "mystic3.jpg",
        contentType = "image/jpg",
        alt = "mystic3"
      ))
    
    else if (input$time == "Morning" && input$scene == "Dramatic")
      return(list(
        src = "dramatic1.jpg",
        contentType = "image/jpg",
        alt = "dramatic1"
      ))
    
    else if (input$time == "Afternoon" && input$scene == "Dramatic")
      return(list(
        src = "dramatic2.jpg",
        contentType = "image/jpg",
        alt = "dramatic2"
      ))
    
    else if (input$time == "Evening" && input$scene == "Dramatic")
      return(list(
        src = "dramatic3.jpg",
        contentType = "image/jpg",
        alt = "dramatic3"
      ))
    
    else if (input$time == "Morning" && input$scene == "Scenic")
      return(list(
        src = "scenic1.jpg",
        contentType = "image/jpg",
        alt = "scenic1"
      ))
    
    else if (input$time == "Afternoon" && input$scene == "Scenic")
      return(list(
        src = "scenic2.jpg",
        contentType = "image/jpg",
        alt = "scenic2"
      ))
    
    else if (input$time == "Evening" && input$scene == "Scenic")
      return(list(
        src = "scenic3.jpg",
        contentType = "image/jpg",
        alt = "scenic3"
      ))
    
    else if (input$time == "Morning" && input$scene == "Serene")
      return(list(
        src = "serene1.jpg",
        contentType = "image/jpg",
        alt = "serene1"
      ))
    
    else if (input$time == "Afternoon" && input$scene == "Serene")
      return(list(
        src = "serene2.jpg",
        contentType = "image/jpg",
        alt = "serene2"
      ))
    
    else if (input$time == "Evening" && input$scene == "Serene")
      return(list(
        src = "serene3.jpg",
        contentType = "image/jpg",
        alt = "serene3"
      ))
    
  },deleteFile = FALSE)
  
  # Generate a summary of the weather conditions that contribute to the scene
  
  output$Conditions <- renderImage({
    
    if(input$scene == "Mysterious")
      return(list(
        src = "mys_contrib.png",
        contentType = "image/png",
        alt = "contrib1"
      ))
    
    if(input$scene == "Serene")
      return(list(
        src = "ser_contrib.png",
        contentType = "image/png",
        alt = "contrib2"
      ))
    if(input$scene == "Dramatic")
      return(list(
        src = "drm_contrib.png",
        contentType = "image/png",
        alt = "contrib3"
      ))
  },deleteFile = FALSE)
  
  output$timeseries <- renderDygraph({
      time_index <- seq(from = as.POSIXct("2016-01-23 06:00"), 
                        to = as.POSIXct("2016-01-23 18:00"), 
                        by = "15 min")
      df$Humidity <- df$Humidity/100
      df$Temperature <- df$Temperature/10
      df$Lux <- df$Lux/1000
      df$Longitude <- NULL
      df$Latitude <- NULL
      df$Soundvalue <- NULL
      df$Distance <- NULL
      df$X <- NULL
      df$Time <- NULL
      df$Windspeed <- NULL
      colnames(df) <- c("Humidity","Temperature","Luminosity")
      value <- df[1:49,]
      plotdata <- xts(value, order.by = time_index)
      dygraph(plotdata, main = "Variation of Atmospheric Conditions", ylab = "Scaled values") %>% 
        dyAxis("y", valueRange = c(0,5)) %>% 
        dyRangeSelector() %>%
        dyLegend(labelsDiv = "legendDivID") %>%
        dyAnnotation("2016-01-23 10:00", text = "Fog + Dark", width = 50, height = 50)%>% 
        dyShading(from = "2016-01-23 10:00", 
                  to = "2016-01-23 11:00", 
                  color = "#FFE6E6") %>% dyLegend(width = 400)
  })
  
  # Generate an HTML table view of the data
  output$table <- renderDataTable({
    
    if(input$scene == "Mysterious")
      {
      colnames(mys) <- c("Long (degrees)", "Lat (degrees)", "Time (hh:mm:ss)", "Humidity (%)", "Temp (°C)", "WindSpeed (m/s)", "Sound (dB)", "Luminosity (Lux)", "Distance (m)") 
      mys
    }
    else if(input$scene == "Serene")
      {
      colnames(ser) <- c("Long (degrees)", "Lat (degrees)", "Time (hh:mm:ss)", "Humidity (%)", "Temp (°C)", "WindSpeed (m/s)", "Sound (dB)", "Luminosity (Lux)", "Distance (m)") 
      ser
    }
    else if(input$scene == "Dramatic")
      {
      colnames(dra) <- c("Long (degrees)", "Lat (degrees)", "Time (hh:mm:ss)", "Humidity (%)", "Temp (°C)", "WindSpeed (m/s)", "Sound (dB)", "Luminosity (Lux)", "Distance (m)") 
      dra
    }
  })
  

})
