shinyUI(pageWithSidebar(
  
  headerPanel("KoladApp"),
  
  sidebarPanel(
    selectInput(inputId = "category",
                label = "Välj variabel",
                choices = keys,
                selected = "Nettokostnad äldreomsorg, kr/inv"),
         
        selectInput(inputId = "kommun",
                    label = "Välj kommun",
                    choices = unique(bakgr$Kommun),
                    selected = "Ale"),
    
    selectInput(inputId = "graftyp",
                label = "Välj graf",
                choices = c("point",
                            "boxplot",
                            "line",
                            "jitter")),
    
    checkboxInput(inputId = "smooth",
                  label = strong("Visa regressionslinje"),
                  value = FALSE),
    
    # Display this only if the density is shown
    conditionalPanel(condition = "input.smooth == true",
                     checkboxInput(inputId = "loess",
                                   label = "Loess",
                                   value = FALSE)
    ),
    
    # This is unused, invisible slider is necessary because of a bug
    conditionalPanel(
      condition = "false",
      sliderInput("nothing", "This does nothing:",
                  min = 1, max = 1000, value = 100)
    )
  ),
  
  mainPanel(
    plotOutput(outputId = "main_plot", height = "300px"),
    textOutput("sessioninfo")
  )  
  
))