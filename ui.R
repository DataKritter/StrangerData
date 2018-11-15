library(shiny)
library(ggplot2)


navbarPage("Stranger Data!",

           tabPanel("How many?",
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
                                              "Scenes" = "scene_seq"))


                          ),

                          mainPanel(
                                plotOutput("plot1", height = 800)
                          )
                    )
           ),

           tabPanel("Which ones?",
                    sidebarLayout(
                          sidebarPanel(
                                checkboxGroupInput("characters2", "Y axis:",
                                                   c("The Party" = "Party",
                                                     "Other main characters" = "Main",
                                                     "Minor characters" = "Minor",
                                                     "Un-credited characters" = "Uncredited",
                                                     "Upside-Down" = "Upside Down"), selected = "Party"),
                                selectInput('metric2', 'X axis:',
                                            c("Seasons" = "seasonNum",
                                              "Episodes" = "episode_id",
                                              "Scenes" = "scene_seq"))


                          ),

                          mainPanel(
                                plotOutput("plot2", height = 800)
                          )
                    )
           ),
           tabPanel("Where?",
                    sidebarLayout(
                          sidebarPanel(
                                checkboxGroupInput("characters3", "Y axis:",
                                                   c("The Party" = "Party",
                                                     "Other main characters" = "Main",
                                                     "Upside-Down" = "Upside Down"), selected = "Party"),
                                selectInput('metric3', 'X axis:',
                                            c("Location (City)" = "location",
                                              "Sublocation (Site)" = "subLocation")


                          )),

                          mainPanel(
                                plotOutput("plot3", height = 800)
                          )
                    )
           )




)