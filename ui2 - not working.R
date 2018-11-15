library(shiny)
library(ggplot2)


navbarPage("Stranger Data!",
           tabPanel("Seasons, Scenes, & Episodes",
                    sidebarLayout(
                          sidebarPanel(
                                checkboxGroupInput("characters", "Y axis: Include which characters?",
                                                   c("The Party" = "Party",
                                                     "Other main characters" = "Main",
                                                     "Minor characters" = "Minor",
                                                     "Un-credited characters" = "Uncredited",
                                                     "Upside-Down" = "Upside Down"), selected = "Party"),
                                selectInput('metric', 'X axis: Count what?',
                                            c("Seasons" = "seasonNum",
                                              "Episodes" = "episode_id",
                                              "Scenes" = "scene_id")),

                                selectInput('color', 'Color: Subcount',
                                            c("Seasons" = "seasonNum",
                                              "Episodes" = "episode_id",
                                              "Scenes" = "scene_id",
                                              "Screen time" = "scene_length",
                                              "Character group" = "group",
                                              "Character" = "character"))


                          ),

                          mainPanel(
                                plotOutput("plot1")
                          )
                    )
           ),
           tabPanel("Tab 2",
                    verbatimTextOutput("summary")
           ),
           tabPanel("Tab 3",
                    verbatimTextOutput("Test")
           )
)