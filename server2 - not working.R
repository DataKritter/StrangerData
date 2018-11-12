#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(jsonlite)
library(unheadr)
library(readr)

#gender

gender <- read_csv("gender.csv",
                   col_types =
                       cols(gender = col_factor(levels = c("female","male"))),
                   na = "NA")

#groups
groups <- read_json("characters-groups.json") %>%
    as.tibble() %>%
    unlist() %>%
    as.tibble() %>%
    untangle2("Party|Main|Upside Down|Include", value, group) %>%
    rename(character = value)

#scenes
scenes <- read_csv("stranger-things.csv",
                   col_types = cols(
                       sceneEnd = col_time(format = "%H:%M:%S"),
                       sceneStart = col_time(format = "%H:%M:%S")
                   )) %>%
    gather(chars1:chars18, key = Chars, value = Name) %>%
    arrange(seasonNum, episodeNum, sceneNum) %>%
    select(-Chars) %>%
    na.omit() %>%
    rename(character = Name) %>%
    mutate(scene_length = sceneStart - sceneEnd,
           episode_id = seasonNum * 10 + episodeNum,
           scene_id = seasonNum * 10 + episodeNum + sceneNum/1000) %>%
    left_join(gender) %>%
    left_join(groups) %>%
    mutate(group = ifelse(is.na(group), "Uncredited", group),
           episode_id = factor(episode_id),
           seasonNum = factor(seasonNum),
           group = ifelse(group == "Include", "Minor", group)
           )



server <- function(input,output){

    my_scenes <- reactive({

        test <- filter(scenes, group %in% input$characters) %>%
        select(input$metric, everything()) %>%
            distinct() %>%
            group_by(input$metric, character, group, seasonNum) %>%
            summarize(n = n())
        print(test)
        test
    })

    mymetric <- reactive({
        test2 <- input$metric
        print(test2)
        test2
    })


     output$plot1 <- renderPlot({
        ggplot(my_scenes(),aes(x = reorder(character, n), y = n,  fill = seasonNum)) +
            geom_bar(stat = "identity") +
            coord_flip() +
            xlab("") +
            ylab(paste0("Count of ",  mymetric())) +
            theme(legend.position = "bottom", legend.title = element_blank())
    })


    }

