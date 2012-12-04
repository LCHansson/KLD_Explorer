shinyUI(bootstrapPage(
  
  selectInput(inputId = "category",
              label = "Välj variabel",
              choices = keys,
              selected = ""),

#   selectInput(inputId = "kommun",
#               label = "Välj kommun",
#               choices = unique(bakgr$Kommun),
#               selected = ""),
  
  selectInput(inputId = "graftyp",
              label = "Välj graf",
              choices = c("point",
                          "line",
                          "boxplot")),
  
   checkboxInput(inputId = "smooth",
                 label = strong("Visa regressionslinje"),
                 value = FALSE),
#   
#   checkboxInput(inputId = "density",
#                 label = strong("Show density estimate"),
#                 value = FALSE),
  
   plotOutput(outputId = "main_plot", height = "300px"),
  
  # Display this only if the density is shown
  conditionalPanel(condition = "input.density == true",
                   sliderInput(inputId = "bw_adjust",
                               label = "Bandwidth adjustment:",
                               min = 0.2, max = 2, value = 1, step = 0.2)
  )
  
))