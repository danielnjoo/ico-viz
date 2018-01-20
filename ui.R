library(shiny)
library(googlesheets)

shinyUI(
  fluidPage(
    titlePanel("ICO data"),
    DT::dataTableOutput("the_data")
  ))