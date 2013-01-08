shinyUI(pageWithSidebar(
  
  headerPanel("KoladApp"),
  
  sidebarPanel(
    selectInput(inputId = "category",
                label = "Välj variabel",
                choices = keys,
                selected = "Nettokostnad äldreomsorg, kr/inv"),
    
    #     selectInput(inputId = "kommun",
    #                 label = "Välj kommun",
    #                 choices = unique(KLData$Kommun),
    #                 selected = "Ale"),
    
    sliderInput(inputId="year",
                label="Välj år",
                min=min(allyears),
                max=max(allyears),
                value=2008,
                step=1,
                animate=T),
    
    sliderInput(inputId="kommunNr",
                label="KommunNr",
                min=1,
                max=length(unique(KLData$Kommun)),
                value=1,
                step=1,
                animate=T),
    
    #     selectInput(inputId = "year",
    #                 label="Välj år",
    #                 choices = allyears,
    #                 selected = "2010"),
    
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
    
    checkboxInput(inputId = "tvavar",
                  label = strong("Lägg till andra variabel"),
                  value = FALSE),
    
    # Display this only if tvavar is active
    conditionalPanel(condition = "input.tvavar == true",
                     selectInput(inputId = "categ2",
                                 label = "Välj variabel",
                                 choices = keys,
                                 selected = "Kostnad individ- och familjeomsorg, kr/inv")
    ),
    
    # This is unused, invisible slider is necessary because of a bug
    conditionalPanel(
      condition = "false",
      sliderInput("nothing", "This does nothing:",
                  min = 1, max = 1000, value = 100)
    )
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Start", h3(verbatimTextOutput("caption")), verbatimTextOutput("startpage"))
      ,tabPanel("Plot", plotOutput("main_plot", height="400px"))
      ,tabPanel("Twoway", plotOutput("twoway_plot", height="500px"))
#       ,tabPanel("Session info", textOutput("sessioninfo"))
    )
  )
))