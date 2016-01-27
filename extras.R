
# Generate a plot of the data. Also uses the inputs to build
# the plot label. Note that the dependencies on both the inputs
# and the data reactive expression are both tracked, and
# all expressions are called in the sequence implied by the
# dependency graph

#   d4 <- read.csv(paste(path,"/Data_day4.csv",sep=""))
#   d51 <- read.csv(paste(path,"/Day_5_1.csv",sep=""))
#   d52 <- read.csv("~/R/shiny-examples/006-tabsets/Day_5_2.csv")
#   d53 <- read.csv("~/R/shiny-examples/006-tabsets/Day_5_3.csv")
#   d6 <- read.csv("~/R/shiny-examples/006-tabsets/Day_6.csv")


#     g1 <- rHighcharts ::: Chart$new()
#     
#     g1$data(x = c("Fog","Darkness","Twilight"), 
#             y = c(mean(df$humidity, na.rm = TRUE),mean(df$temperature, na.rm = TRUE),
#                   mean(df$windspeed, na.rm = TRUE)), 
#             type = "pie")
#     
#    g1$legend("Mysterious")
#    g1$chart(height = 300, width = 500)
#    g1

#g1 <- rHighcharts ::: Chart$new()
#g1$title("Appropriateness of weather")
#g1$data(x = bardata$Conditions, y = bardata$Contribution, type = "bar")
#     g1$data(x = c("Fog","Cold","Cluttered"), 
#             y = c(mean(df$humidity, na.rm = TRUE),mean(df$temperature, na.rm = TRUE),
#                   mean(df$distance, na.rm = TRUE)), 
#             type = "bar",col = "")
#g1$xAxis(c("Fog","Cold","Cluttered"))

#g1$chart(height = 200, width = 400)

#dygraph(humidity, main = )

#tags$br()
#dygraph(humidity,main = "Variation of Humidity over time", ylab = "Humidity (%)")
#g2 <- ggplot
#       gvisColumnChart(df, xvar = colnames(df)[2], yvar = colnames(df)[3:5lib], 
#                           options=list(title="Variation of atmospheric conditions over time",
#                                        titlePosition='out',
#                                        hAxis="{slantedText:'true',slantedTextAngle:45}",
#                                        titleTextStyle="{color:'black',fontName:'Courier',fontSize:14}",
#                                        height=500, width=800))