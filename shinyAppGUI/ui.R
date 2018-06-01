# install.packages('shiny')
library(shiny)
library(ggplot2)
library(readr)

movies <- read_csv("movie_metadata.csv")
dataset <- diamonds
option1 <- c("Visualization","Correlation Analysis","Random Forest","Linear Regression")
visOpt <- c("Number of movies Vs Years","Imdb Score Vs Duration","Mean Imdb score vs Genre","Country vs Mean Ratings")

fluidPage(
  
  titlePanel("Movie Predictions"),
  sidebarPanel(
    selectInput('options', 'Options', option1),
    selectInput('visOpts', "Select if Option chosen was Visualization: Visualization Options", visOpt ),
    textOutput("info")
  ),
  
  mainPanel(
    
   verticalLayout( 
      plotOutput('plot')
     
    )
  )
)