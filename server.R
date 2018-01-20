library(shiny)
library(googlesheets)
library(dplyr)
library(DT)


data <- gs_url("https://docs.google.com/spreadsheets/d/1ZtlHeHFO0nv5D0vkR8VdghVhsMgBaGlDAZhPVR6hqDQ/") %>% 
    gs_read() 

colnames(data) <- data[5,]
data <- data[6:nrow(data),]
  

shinyServer(function(input, output, session) {
  
  output$the_data <- renderDataTable({
  
    datatable(data[,c(1,5,23,25)])
    
  })
  
})
