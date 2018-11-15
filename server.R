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
    arrange(seasonNum, episodeNum, sceneNum) %>%
    mutate(scene_seq = row_number()) %>%
    gather(chars1:chars18, key = Chars, value = Name) %>%
    arrange(seasonNum, episodeNum, sceneNum) %>%
    select(-Chars) %>%
    na.omit() %>%
    rename(character = Name) %>%
    mutate(scene_length = sceneStart - sceneEnd,
           episode_id = seasonNum + episodeNum/10,
           scene_id = seasonNum * 10 + episodeNum + sceneNum/1000) %>%
    left_join(gender) %>%
    left_join(groups) %>%
    mutate(group = ifelse(is.na(group), "Uncredited", group),
           episode_id = factor(episode_id),
           seasonNum = factor(seasonNum),
           group = ifelse(group == "Include", "Minor", group)
    )



server <- function(input,output){

    #First Tab
    scenes_count <- reactive({
        my_count <- filter(scenes, group %in% input$characters) %>%
        select(input$metric,  character, group) %>%
            distinct() %>%
            group_by(group, character) %>%
            summarize(n = n())
        print(my_count)
        my_count
    })

    my_metric <- reactive({
        my_metric <- input$metric
        print(my_metric)
        my_metric
    })

    output$plot1 <- renderPlot({
        ggplot(scenes_count(),aes(x = reorder(character, n), y = n,  fill = group)) +
            geom_histogram(stat = "identity") +
            coord_flip() +
            xlab("") +
            ylab(paste0("Count of ",  my_metric())) +
            theme(legend.position = "bottom", legend.title = element_blank())
    })


#Second Tab

    scenes_which <- reactive({

        my_which <- filter(scenes, group %in% input$characters2) %>%
            select(input$metric2,  character, group) %>%
            distinct()
        print(my_which)
        my_which
    })



    my_metric2 <- reactive({
        my_metric2 <- as.factor(input$metric2)
        print(my_metric2)
        my_metric2
    })


    output$plot2 <- renderPlot({
        ggplot(scenes_which(),aes(x = character, fill = group)) +
                geom_tile(aes_string(y = input$metric2)) +
                coord_flip() +
                xlab("") +
                ylab(paste0(my_metric2())) +
                theme(legend.position = "bottom", legend.title = element_blank(),
                      axis.title.y=element_blank(),
                      axis.text.x=element_blank(),
                      axis.ticks.x=element_blank())
    })


    #Third Tab

    scenes_locs <- reactive({

        locs <- scenes %>%
            filter(group %in% input$characters3) %>%
            group_by(input$metric3, character, scene_seq) %>%
            summarize(num = n()) %>%
            top_n(5, wt = num) %>%
            right_join(scenes)

        print(locs)
        locs
    })

    my_metric3 <- reactive({
        my_metric3 <- input$metric3
        print(my_metric3)
        my_metric3
    })


    output$plot3 <- renderPlot({

        ggplot(filter(scenes_locs(), num > 0),
            aes(x = scene_seq, color = character, group = character)) +
            geom_point(aes_string(y = input$metric3)) +
            geom_line(aes_string(y = input$metric3)) +
            guides(fill = FALSE) +
            theme(legend.position = "bottom", legend.title = element_blank())

    })




}

