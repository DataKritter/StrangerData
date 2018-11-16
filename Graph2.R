#Which locations do you think were on screen the most?
unique(scene_locs$subLocation)


#Show the first 25 observations of scene_locs
View(head(scene_locs, 25))


#Try changing x and/or fill to subLocation.  Note the capital 'L' in subLocation
#Try changing y to num_scenes, num_episodes, num_seasons, screen_time

ggplot(scene_locs, aes(
      x = location,
      y = screen_time,
      fill = location)) +
      geom_bar(stat = "identity") +
      coord_flip()
