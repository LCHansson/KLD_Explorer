shinyUI(pageWithSidebar(
  
  headerPanel("KoladApp (technology preview)"),
  
  sidebarPanel(
    selectInput(inputId = "category",
                label = "Variabel 1",
                choices = keys,
                selected = "Nettokostnad äldreomsorg, kr/inv"),
    
    selectInput(inputId = "categ2",
                label = "Variabel 2",
                choices = keys,
                selected = "Kostnad individ- och familjeomsorg, kr/inv"),
    
    checkboxInput(inputId = "tvavar",
                  label = strong("Visa variabel 2 i tidsserier"),
                  value = TRUE),
    
    selectInput(inputId = "kommun",
                label = "Välj kommun",
                choices = sort(unique(KLData$Kommun)),
                selected = "Ale"),
    
    #     sliderInput(inputId="kommunNr",
    #                 label="KommunNr",
    #                 min=1,
    #                 max=length(unique(KLData$Kommun)),
    #                 value=1,
    #                 step=1,
    #                 animate=T),
    
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
    
    # Options below only apply to twoway graph
    
    helpText("OBS: Alternativen nedan är endast",
             "tillämpbara i tvåvägsläge."),
    
    sliderInput(inputId="year",
                label="Välj år",
                min=min(allyears),
                max=max(allyears),
                value=2008,
                step=1,
                animate=T),
    
    checkboxInput(inputId="percentgraph",
                label="Använd procentdimensioner (0-100)",
                value=FALSE)
    
    # This is unused, invisible slider is necessary because of a bug
#     conditionalPanel(
#       condition = "false",
#       sliderInput("nothing", "This does nothing:",
#                   min = 1, max = 1000, value = 100)
#     )
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Start", h3(verbatimTextOutput("startcaption")), verbatimTextOutput("startpage"))
      ,tabPanel("Tidsserier", plotOutput("main_plot", height="400px"))
      ,tabPanel("Tvåvägsplot", plotOutput("twoway_plot", height="500px"))
      ,tabPanel("Utveckling", h3(verbatimTextOutput("devcaption")), verbatimTextOutput("development"))
      ,tabPanel("Mer...", h3(verbatimTextOutput("morecaption")), verbatimTextOutput("more_info"))
      #       ,tabPanel("Session info", textOutput("sessioninfo"))
    )
    
  )
))