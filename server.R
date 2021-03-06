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
  df <- df[,c(2,3,4:10)]
  mys <- df[df$Humidity>80 & df$Temperature>4 & df$Temperature<8,]
  ser <- df[df$Soundvalue<100 & df$Windspeed<1,]
  dra <- df[df$Windspeed>0.2 & df$Lux<1000,]
  
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
           #addProviderTiles("http://{s}.tile.openweathermap.org/{z}/{x}/{y}.png") %>%
           addMarkers(lng = lng, lat = lat,icon = leafIcons, popup = c("Aasee","Gievenbeck")) 
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
        addMarkers(lng = lng, lat = lat,icon = leafIcons,popup = c("Aasee","Gievenbeck"))
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
    
    
      if(input$scene == "Mysterious")
      {
        timestep <- paste(round((12*60)/nrow(mys),2),"min")
        
        time_index <- seq(from = as.POSIXct("2016-01-23 06:00"), 
                          to = as.POSIXct("2016-01-23 18:00"), 
                          by = "hour")
        
        mys$Humidity <- mys$Humidity/100
        mys$Temperature <- mys$Temperature/10
        mys$Lux <- mys$Lux/100
        mys$Longitude <- NULL
        mys$Latitude <- NULL
        mys$Soundvalue <- NULL
        mys$Distance <- NULL
        mys$X <- NULL
        mys$Time <- NULL
        mys$Windspeed <- NULL
        
        colnames(mys) <- c("Humidity","Temperature","Luminosity")
        value <- mys[1:length(time_index),]
#         plotH <- xts(value$Humidity, order.by = time_index)
#         plotT <- xts(value$Temperature, order.by = time_index)
#         plotL <- xts(value$Luminosity, order.by = time_index)
          plotdata <- xts(value, order.by = time_index)
        
        #annoText = c("Fog + Dark")
        #from_time = as.POSIXct("2016-1-23 10:00")
        #to_time = as.POSIXct("2016-1-23 11:00")
        #scale_col = "#FFE7E6"
        
        d <- dygraph(plotdata, main = "Variation of Atmospheric Conditions", ylab = "Scaled values") %>% 
          dyAxis("y", valueRange = c(0,1)) %>% 
          dyRangeSelector() %>%
          dyLegend(labelsDiv = "legendDivID") %>%
          #dySeries("Humidity", stepPlot = TRUE, color = "blue") %>%
          #dySeries("Temperature", drawPoints = TRUE, color = "red") %>%
          #dySeries("Temperature", color = "purple") %>%
          dyAnnotation("2016-01-23 07:00", text = "Fog + Dark", width = 100, height = 20)%>% 
          dyShading(from = as.POSIXct("2016-1-23 07:00:00"), 
                    to = as.POSIXct("2016-1-23 08:00:00"), 
                    color = "#FFE7E6") %>% 
          dyShading(from = as.POSIXct("2016-1-23 16:00:00"), 
                    to = as.POSIXct("2016-1-23 17:00:00"), 
                    color = "#FFE7E6")
        
      }
      
      if(input$scene == "Dramatic")
      {
        timestep <- round((12*60)/nrow(dra),2)
        time_index <- seq(from = as.POSIXct("2016-01-23 06:00"), 
                          to = as.POSIXct("2016-01-23 18:00"), 
                          by = "hour")
        dra$Humidity <- dra$Humidity/100
        dra$Temperature <- dra$Temperature/10
        dra$Lux <- dra$Lux/100
        dra$Longitude <- NULL
        dra$Latitude <- NULL
        dra$Soundvalue <- NULL
        dra$Distance <- NULL
        dra$X <- NULL
        dra$Time <- NULL
        
        colnames(dra) <- c("Humidity","Temperature","WindSpeed","Luminosity")
        value <- dra[1:length(time_index),]
        plotdata <- xts(value, order.by = time_index)
        
        annoText <- c("Windy+Cloudy")
        
        from_time = as.POSIXct("2016-01-23 13:00")
        to_time = as.POSIXct("2016-01-23 14:00")
        scale_col = "#EFE7E6"
        
        d <- dygraph(na.omit(plotdata), main = "Variation of Atmospheric Conditions", ylab = "Scaled values") %>% 
          dyAxis("y", valueRange = c(0,1)) %>% 
          dyRangeSelector() %>%
          dyLegend(labelsDiv = "legendDivID") %>%
          dyAnnotation("2016-01-23 13:00", text = "Cloudy + Windy", width = 100, height = 50)%>% 
          dyShading(from = from_time, 
                    to = to_time, 
                    color = scale_col) %>% dyLegend(width = 400)
        
      }
      
      d
     
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
