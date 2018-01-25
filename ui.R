library(shiny)
library(googlesheets)

shinyUI(
  fluidPage(
    titlePanel("ICO data"),
    
    p('Data manually taken from various crypto-project websites and compiled @ http://bit.ly/2DuJq8c, current as of 25.1.18'),
    
    DT::dataTableOutput("the_data"),
    
    hr(),
    
    h3("ICO Length/Team Size"),
    p("Missing data is ommitted"),
    
    fluidRow(
      column(2,
             p("Choose input"),
             checkboxInput("length", "ICO length (days)", value=T),
             checkboxInput("size", "Team size")
      ),
      column(10,
             plotOutput('plot1')
      )
    ),
    
    hr(),
    
    h3("Industry/Team Location"),
    p("Missing data is ommitted"),
  
    fluidRow(
      column(2,
             p("Choose input"),
             checkboxInput("industry", "Industry"),
             checkboxInput("location", "Team location", value=T)
      ),
      column(10,
             plotOutput('plot2')
      )
    ),
    
    h3("Social Media Stats"),
    p("as of 25.1.18 (note not at time of ICO)"),
    p("Missing data is ommitted"),
    
    fluidRow(
      column(2,
             p("Choose input"),
             checkboxInput("facebook", "Facebook", value=T),
             checkboxInput("reddit", "Reddit"),
             checkboxInput("telegram", "Telegram"),
             checkboxInput("twitter", "Twitter"),
             checkboxInput("slack", "Slack")
      ),
      column(10,
             plotOutput('plot1')
      )
    ),
    
    DT::dataTableOutput("social_media_links"),
    
    p("Potential future features:"),
    p("Days since ICO, growth since ICO, backtrack social media stats to date of ICO")
  )
)