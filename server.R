library(shiny)
library(googlesheets)
library(dplyr)
library(DT)
library(readr)
library(ggplot2)


data <- gs_url("https://docs.google.com/spreadsheets/d/1ZtlHeHFO0nv5D0vkR8VdghVhsMgBaGlDAZhPVR6hqDQ/") %>% 
    gs_read(col_names = c("NAME", "TICKER",	"WEB SITE","ICO LENGTH (DAYS)",	"TOTAL AMOUNT RAISED($$$)",	"HARD CAP",	"TIME TILL SOFT CAP WAS REACHED",	"CURRENCIES ACCEPTED",	"BOUNTY CAMPAIGN Y/N", "BOUNTY SIZE",	"FACEBOOK", "FACEBOOK FOLLOWERS",	"REDDIT",	"REDDIT FOLLOWERS",	"TELEGRAM",	"TELEGRAM FOLLOWERS",	"TWITTER",	"TWITTER FOLLOWERS",	"SLACK",	"SLACK FOLLOWERS",	"INDUSTRY",	"TEAM SIZE",	"TEAM LOCATION",	"WHITE PAPER"),
            skip = 6) %>% as.data.frame()

# sapply(data, typeof) # amt raised is a character

data$`TOTAL AMOUNT RAISED($$$)` <- gsub('[$,.]', '', data$`TOTAL AMOUNT RAISED($$$)`) %>% 
  as.numeric()

shinyServer(function(input, output, session) {
  
  output$the_data <- renderDataTable({
  
    datatable(data[,c(1,5,22,23,24)])
    
  })

  output$plot1 <- renderPlot({
    
    temp <- subset(data, `TOTAL AMOUNT RAISED($$$)`> 50000000)
    
    if (input$length==T){
      plot1input <- data$`ICO LENGTH (DAYS)`
      label1input <- temp$`ICO LENGTH (DAYS)`
      xLabel <- "ICO length (days)"
    } else if (input$size==T){
      plot1input <- data$`TEAM SIZE`
      label1input <- temp$`TEAM SIZE`
      xLabel <- "Team size"
    } 
    
    data %>% ggplot(aes(plot1input, `TOTAL AMOUNT RAISED($$$)`)) + 
      geom_point() + 
      geom_text(data=temp, aes(x=label1input,y=`TOTAL AMOUNT RAISED($$$)`, label=NAME), vjust=0,hjust=0) +
      ggtitle(paste("Amount Raised vs. "), xLabel) +
      xlab(xLabel)
    
  })
  
  output$plot2 <- renderPlot({
    
    if (input$industry==T){
      plot2input <- data %>% 
        group_by(`INDUSTRY`) %>% 
        summarise(count=n()) %>% 
        na.omit()
      temp<-plot2input$`INDUSTRY`
      xLabel <- "Industry"
    } else if (input$location==T){
      plot2input <- data %>% 
        group_by(`TEAM LOCATION`) %>% 
        summarise(count=n()) %>% 
        na.omit()
      temp<-plot2input$`TEAM LOCATION`
      xLabel <- "Location"
    } 
    
    plot2input %>% 
      ggplot(aes(temp, count), fill=temp) + 
        geom_bar(stat='identity') + 
        theme(axis.text.x = element_text(angle=90, vjust=0.5,hjust=1))
    
    
  })
  
})
