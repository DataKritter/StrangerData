library(shiny)
library(ggplot2)

num <- as.integer(abs(rnorm(20))*10)
let <- letters[1:20]
date <- as.Date(abs(rnorm(20))*17839, origin = "1900-01-01")
df <- data.frame(num,let,date)

ui <- fluidPage(
   titlePanel(title=h4("Races", align="center")),
   sidebarPanel(
      sliderInput("num", "Number:",min = 0, max = 20,step=1,value=c(1,2))),
   mainPanel(plotOutput("plot2")))

server <- function(input,output){

   dat <- reactive({
      test <- df[df$num %in% seq(from = min(input$num),to = max(input$num), by = 1),]
      print(test)
      test
   })

   dat2 <- reactive({
      my_size <- min(input$num)
      print(my_size)
      my_size
   })

   output$plot2 <- renderPlot({
      ggplot(dat(),aes(x = date,y = num)) +
         geom_point(colour ='red', size = dat2())
   })}


shinyApp(ui, server)