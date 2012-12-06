shinyUI(pageWithSidebar(
  
  headerPanel("KoladApp"),
  
  sidebarPanel(
    selectInput(inputId = "category",
                label = "Välj variabel",
                choices = keys,
                selected = "Arbetslöshet, (%)"),
    #     
    selectInput(inputId = "kommun",
                label = "Välj kommun",
                choices = unique(bakgr$Kommun),
                selected = ""),
    
    #   checkboxInput(inputId = "canvas",
    #               label = strong("Tvåvägsgraf"),
    #               value=FALSE),
    
    selectInput(inputId = "graftyp",
                label = "Välj graf",
                choices = c("point",
                            "line",
                            "boxplot")),
    
    #     checkboxInput(inputId = "smooth",
    #                   label = strong("Visa regressionslinje"),
    #                   value = FALSE),
    
    #Display this only if the density is shown
    #     conditionalPanel(condition = "input.canvas == true",
    #                      sliderInput(inputId = "bw_adjust",
    #                                  label = "Bandwidth adjustment:",
    #                                  min = 0.2, max = 2, value = 1, step = 0.2)
    #     ),
    
    #   checkboxInput(inputId = "density",
    #                 label = strong("Show density estimate"),
    #                 value = FALSE),
    
    # This is unused, invisible slider is necessary because of a bug
    conditionalPanel(
      condition = "false",
      sliderInput("nothing", "This does nothing:",
                  min = 1, max = 1000, value = 100)
    )
  ),
  
  mainPanel(
    plotOutput(outputId = "main_plot", height = "300px", width = "300px")
  )  
  
))