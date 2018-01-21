library(shiny)
library(googlesheets)

shinyUI(
  fluidPage(
    titlePanel("ICO data"),
    
    p('Data manually taken from various crypto-project websites and compiled @ http://bit.ly/2DuJq8c'),
    
    DT::dataTableOutput("the_data"),
    
    hr(),
    
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
    
    fluidRow(
      column(2,
             p("Choose input"),
             checkboxInput("industry", "Industry"),
             checkboxInput("location", "Team location", value=T)
      ),
      column(10,
             plotOutput('plot2')
      )
    )

  )
)