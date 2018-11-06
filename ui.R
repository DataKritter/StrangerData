library(shiny)
library(ggplot2)


navbarPage("Stranger Data!",
           tabPanel("Seasons, Scenes, Episodes, and Screen Time",
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
                                              "Scenes" = "scene_id",
                                              "Screen time" = "scene_length")),

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
           tabPanel("Summary",
                    verbatimTextOutput("summary")
           ),
           navbarMenu("More",
                      tabPanel("Table",
                               DT::dataTableOutput("table")
                      ),
                      tabPanel("About"

                      )
           )
)