

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Stranger Things"),


    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("characters", "Include characters:",
                               c("The Party" = "Party",
                                 "Other main characters" = "Main",
                                 "Minor characters" = "Minor",
                                 "Un-credited characters" = "Uncredited",
                                 "Upside-Down" = "Upside Down"), selected = "Party"),
            selectInput('metric', 'Which metric?',
                        c("Seasons" = "seasonNum",
                          "Episodes" = "episode_id",
                          "Scenes" = "scene_id",
                          "Screen time" = "scene_length"))

        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot1")
        )
    )
))
