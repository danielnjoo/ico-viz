library(shiny)
library(googlesheets)

shinyUI(
  fluidPage(
    titlePanel("ICO data"),
    
    p('Data manually taken from various crypto-project websites and compiled @ http://bit.ly/2DuJq8c'),
    
    DT::dataTableOutput("the_data"),
    
    hr(),
    
    fluidRow(
      column(3,
             p("Choose input"),
             checkboxInput("length", "ICO length (days)", value=T),
             checkboxInput("size", "Team size")
      ),
      column(9,
             plotOutput('plot1')
      )
    )

  )
)