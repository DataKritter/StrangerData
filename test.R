library(shiny)
library(plotly)
library(tidyverse)
library(jsonlite)
library(unheadr)
library(readr)

#gender
gender <- read_csv("gender.csv",
                   col_types =
                         cols(gender = col_factor(levels = c("female", "male"))),
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
      mutate(
            scene_length = sceneStart - sceneEnd,
            episode_id = seasonNum + episodeNum / 10,
            scene_id = seasonNum * 10 + episodeNum + sceneNum / 1000
      ) %>%
      left_join(gender) %>%
      left_join(groups) %>%
      mutate(
            group = ifelse(is.na(group), "Uncredited", group),
            episode_id = factor(episode_id),
            seasonNum = factor(seasonNum),
            episodeNum = factor(episodeNum),
            scene_id = factor(scene_id),
            group = ifelse(group == "Include", "Minor", group)
      ) %>%
      select(
            seasonNum,
            episodeNum,
            sceneNum,
            scene_id,
            location,
            subLocation,
            character,
            group,
            gender
      )

nms_num <- c("seasonNum",
             "episodeNum",
             "sceneNum",
             "scene_id")

nms_char <- c("location",
              "subLocation",
              "character",
              "group",
              "gender")


#ui
ui <- fluidPage(
      headerPanel("Stranger Things Explorer"),

      fluidRow(
            column(
                  4,
                  checkboxGroupInput(
                        "y",
                        "Y",
                        c(
                              "The Party" = "Party",
                              "Other main characters" = "Main",
                              "Minor characters" = "Minor",
                              "Un-credited characters" = "Uncredited",
                              "Upside-Down" = "Upside Down"
                        ),
                        selected = "Party"
                  ),
                  selectInput('x', 'X', choices = nms_num, selected = "scene_id"),
                  selectInput('color', 'Color', choices = nms_char, selected = "character"),
                  selectInput('facet_row', 'Facet Row', c(None = '.', nms_char), selected = "group"),
                  selectInput('facet_col', 'Facet Column', c(None = '.', nms_char)),
                  sliderInput(
                        'plotHeight',
                        'Height of plot (in pixels)',
                        min = 100,
                        max = 2000,
                        value = 600,
                        step = 50
                  )
            ),

            column(8,
                   plotOutput('trendPlot', height = "600px")),

            hr(),

            DT::dataTableOutput("mytable1")

      )

)


server <- function(input, output) {
      #add reactive data information.

      scenes_fun <- reactive({
            my_chars <- filter(scenes, group %in% input$y)
            print(my_chars)
            my_chars
      })

      output$trendPlot <- renderPlot({
            # build graph with ggplot syntax
            p <- ggplot(scenes_fun(),
                         aes_string(x = input$x, y = "character",  fill = input$color)) +
                  geom_tile(color = "white") +
                  guides(fill = FALSE)

            #if at least one facet column/row is specified, add it
            facets <- paste(input$facet_row, '~', input$facet_col)
            if (facets != '. ~ .') p <- p + facet_grid(facets, scales = "free")

plot(p)

      })

      output$mytable1 <- DT::renderDataTable({
            DT::datatable(scenes_fun())
      })

}

shinyApp(ui, server)
