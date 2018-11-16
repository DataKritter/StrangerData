#Who left Hawkins?

# Try filtering different groups:
#       group == "Upside Down"      "Party" "Main"
#
# or character names:
#       character == "Dustin Henderson"

my_scenes <- scenes %>%
      filter(group == "Party")


      ggplot(my_scenes, aes(x = episode_id,
                 y = location,
                 color = character)) +
      geom_point() +
      geom_line() +
      theme(legend.position = "bottom", legend.title = element_blank())
