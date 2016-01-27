library(shiny)
library(leaflet)
library(rCharts)
library(dygraphs)
library(ggplot2)
library(zoo)
library(rHighcharts)
library(png)

# Define server logic for the display of data
shinyServer(function(input, output) {

  path <- c("~/R/shiny-examples/006-tabsets/data")
  #d1 <- read.csv(paste(path,"/Day_7_1.csv",sep=""))
  #d2 <- read.csv(paste(path,"/Day_7_2.csv",sep=""))
  #d3 <- read.csv(paste(path,"/Day_7_3.csv",sep=""))
  #rbind(d1,d2,d3)
  df <- read.csv(paste(path,"/Data.csv",sep = ""))
  #write.csv(x = df, file = paste(path,"/Data.csv",sep = ""))

  output$map <- renderLeaflet({
    map <- leaflet(width = 500, height = 200) %>%
    addTiles() %>%
    #map$setView(c(51.967,7.663), zoom = 12)
    addMarkers(lng = 7.599008, lat = 51.947237,popup = "Aasee")
    #map$set(dom = 'map', width = 500, height = 200)
    map
  })

  # Generate image corresponding to a scene
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
  
  # Generate a summary of the data
  
  output$Bar <- renderPlot({
    bardata = data.frame(Conditions =
                           factor(c("Fog", "Darkness", "Twilight"),
                           levels = c("Fog", "Darkness", "Twilight")),
                           Contribution = c(mean(df$Humidity/100), 
                                            mean(df$Windspeed), 
                                            mean(df$Distance/10, na.rm = TRUE)))

    g1 <- ggplot(bardata,aes(Conditions,Contribution)) + 
          geom_bar(stat = "identity") + xlab("Conditions") + 
          ylab("Contribution")
    g1
  })
  
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
  output$table <- renderTable({
    data.frame(x=na.omit(df[1:10,3:8]))
  })
  

})
