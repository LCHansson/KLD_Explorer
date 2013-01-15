shinyUI(pageWithSidebar(
  
  headerPanel("KLD Explorer 0.2rc"),
  
  sidebarPanel(
    selectInput(inputId = startpage,
                label="About KLD Explorer",
                choices = c(
                  "startpage" = "0-startpage.R"),
                selected = "0-startpage.R"
    ),
    
    selectInput(inputId = "category",
                label = "Variabel 1:",
                choices = keys,
                selected = "Nettokostnad äldreomsorg, kr/inv"),
    
    conditionalPanel(condition = "input.tab != 'Start'",
                     selectInput(inputId = "categ2",
                                 label = "Variabel 2:",
                                 choices = keys,
                                 selected = "Kostnad individ- och familjeomsorg, kr/inv")
    ),
    
    checkboxInput(inputId = "smooth",
                  label = strong("Visa regressionslinje"),
                  value = FALSE),
    
    checkboxInput(inputId = "tvavar",
                  label = strong("Visa variabel 2 i Tidsserier"),
                  value = TRUE),
    
    # Display this only if the density is shown
    conditionalPanel(condition = "input.smooth == true",
                     checkboxInput(inputId = "loess",
                                   label = "Loess",
                                   value = FALSE)
    ),
    
    selectInput(inputId = "kommun",
                label = "Kommun för Tidsserier:",
                choices = sort(unique(KLData$Kommun)),
                selected = "Ale"),
    
    
    
    selectInput(inputId = "graftyp",
                label = "Plotkategori:",
                choices = c("point",
                            "line",
                            "jitter")),
    
    # Options below only apply to twoway graph    
    sliderInput(inputId="year",
                label="År för Tvåvägsplot:",
                min=min(allyears),
                max=max(allyears),
                value=2008,
                step=1,
                animate=T),
    
    checkboxInput(inputId="percentgraph",
                  label="Använd procentdimensioner (0-100)",
                  value=FALSE)
    
    # This is unused, invisible slider is necessary because of a bug
    ,conditionalPanel(
      condition = "false",
      sliderInput("nothing", "This does nothing:",
                  min = 1, max = 1000, value = 100)
    )
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Start", verbatimTextOutput("startpage"))
      ,tabPanel("Tidsserier", plotOutput("timeseries_plot", height="400px"))
      ,tabPanel("Tvåvägsplot", plotOutput("twoway_plot", height="500px"))
      ,tabPanel("Kartplot", plotOutput("map_plot", height="800px"))
      #       ,tabPanel("Utveckling", h3(verbatimTextOutput("devcaption")), verbatimTextOutput("development"))
      ,id="tab"
    )
    
  )
))