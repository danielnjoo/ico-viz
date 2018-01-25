library(shiny)
library(googlesheets)
library(dplyr)
library(DT)
library(readr)
library(ggplot2)


data <- gs_url("https://docs.google.com/spreadsheets/d/1ZtlHeHFO0nv5D0vkR8VdghVhsMgBaGlDAZhPVR6hqDQ/") %>% 
    gs_read(col_names = c("NAME", "TICKER",	"WEB SITE","ICO LENGTH (DAYS)", "ICO END DATE",	"TOTAL AMOUNT RAISED($$$)",	"HARD CAP",	"TIME TILL SOFT CAP WAS REACHED",	"CURRENCIES ACCEPTED",	"BOUNTY CAMPAIGN Y/N", "BOUNTY SIZE",	"FACEBOOK", "FACEBOOK FOLLOWERS",	"REDDIT",	"REDDIT FOLLOWERS",	"TELEGRAM",	"TELEGRAM FOLLOWERS",	"TWITTER",	"TWITTER FOLLOWERS",	"SLACK",	"SLACK FOLLOWERS",	"INDUSTRY",	"TEAM SIZE",	"TEAM LOCATION",	"WHITE PAPER"),
            skip = 6) %>% as.data.frame()

# sapply(data, typeof) # amt raised is a character

data$`TOTAL AMOUNT RAISED($$$)` <- gsub('[$,.]', '', data$`TOTAL AMOUNT RAISED($$$)`) %>% 
  as.numeric()

shinyServer(function(input, output, session) {
  
  output$the_data <- renderDataTable({
  
    datatable(data[,c(1,6,22,23,24,25)])
    
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
  
  output$plot3 <- renderPlot({
    
    if (input$facebook==T){
      gg <- data %>% 
        ggplot(aes(`FACEBOOK FOLLOWERS`,`TOTAL AMOUNT RAISED($$$)`)) + xlab('Facebook')
    } else if (input$reddit==T){
      gg <- data %>% 
        ggplot(aes(`REDDIT FOLLOWERS`,`TOTAL AMOUNT RAISED($$$)`)) + xlab('Reddit')
    } else if (input$telegram==T){
      gg <- data %>% 
        ggplot(aes(`TELEGRAM FOLLOWERS`,`TOTAL AMOUNT RAISED($$$)`)) + xlab('Telegram')
    } else if (input$twitter==T){
      gg <- data %>% 
        ggplot(aes(`TWITTER FOLLOWERS`,`TOTAL AMOUNT RAISED($$$)`)) + xlab('Twitter')
    } else if (input$slack==T){
      gg <- data %>% 
        ggplot(aes(`SLACK FOLLOWERS`,`TOTAL AMOUNT RAISED($$$)`)) + xlab('Slack')
    } 
    
    gg + geom_point() + geom_smooth(method="lm", se=F)
    
    
  })
  
  output$click_info <- renderPrint({
    #https://shiny.rstudio.com/gallery/plot-interaction-selecting-points.html
    
    if (input$facebook==T){
      nearPoints(data, input$plot3_click, x="FACEBOOK FOLLOWERS", y="TOTAL AMOUNT RAISED($$$)") %>% 
        select(NAME, FACEBOOK)
    } else if (input$reddit==T){
      nearPoints(data, input$plot3_click, x="REDDIT FOLLOWERS", y="TOTAL AMOUNT RAISED($$$)") %>% 
        select(NAME, REDDIT)
    } else if (input$telegram==T){
      nearPoints(data, input$plot3_click, x="TELEGRAM FOLLOWERS", y="TOTAL AMOUNT RAISED($$$)") %>% 
        select(NAME, TELEGRAM)
    } else if (input$twitter==T){
      nearPoints(data, input$plot3_click, x="TWITTER FOLLOWERS", y="TOTAL AMOUNT RAISED($$$)") %>% 
        select(NAME, TWITTER)
    } else if (input$slack==T){
      nearPoints(data, input$plot3_click, x="SLACK FOLLOWERS", y="TOTAL AMOUNT RAISED($$$)") %>% 
        select(NAME, SLACK)
    } 
    
  })
  
 
  
  
})
