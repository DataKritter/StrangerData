library(tidyverse)
library(lubridate)
library(jsonlite)
library(unheadr)
library(readr)


#gender

gender <- read_csv("data/gender.csv", col_types = cols(gender = col_factor(levels = c("female","male"))), na = "NA")

#groups
groups <- read_json("data/characters-groups.json") %>%
      as.tibble() %>%
      unlist() %>%
      as.tibble() %>%
      untangle2("Party|Main|Upside Down|Include", value, group) %>%
      rename(character = value)

#scenes
scenes <- read_csv("data/stranger-things.csv",
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
      left_join(groups)

#characters in scenes
char_scenes <- scenes  %>%
      select(character, seasonNum, episode_id, scene_seq, scene_id, scene_length, scene_seq) %>%
      distinct() %>%
      arrange(character, scene_id) %>%
      group_by(character) %>%
      summarize(num_scenes = n_distinct(scene_seq),
                num_episodes = n_distinct(episode_id),
                num_seasons = n_distinct(seasonNum),
                screen_time = sum(scene_length)) %>%
      left_join(gender) %>%
      left_join(groups)  %>%
      mutate(group = ifelse(is.na(group), "Uncredited", group))


scene_locs <- scenes  %>%
      select(subLocation, location, seasonNum, episode_id, scene_seq, scene_id, scene_length, scene_seq) %>%
      distinct() %>%
      arrange(subLocation, location, scene_id) %>%
      group_by(subLocation, location) %>%
      summarize(num_scenes = n_distinct(scene_seq),
                num_episodes = n_distinct(episode_id),
                num_seasons = n_distinct(seasonNum),
                screen_time = as.numeric(sum(scene_length)))



MainChar <- scenes %>%
      filter(group %in% c("Main", "Party", "Upside Down") )

MainCharStats <- char_scenes %>%
      filter(group %in% c("Main", "Party", "Upside Down") )

MainCharEpisodeStats <- MainChar %>%
      group_by(character, episode_id) %>%
      summarize(sum_screen_time = sum(scene_length)) %>%
      mutate(episode_id = as.factor(episode_id),
             screen_time = as.numeric(sum_screen_time))

