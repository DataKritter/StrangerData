View(MainCharStats)

#Try changing x and fill to different text variables: character, gender, group

#Try changing y to different numerical variables: num_scenes, num_episodes, num_seasons, screen_time

ggplot(MainCharStats,
       aes(x = character,
           y = num_scenes,
           fill = group)) +
      geom_bar(stat = "identity") +
      coord_flip()

