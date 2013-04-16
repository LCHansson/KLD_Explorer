# var1 <- selectInput(inputId = "category",
#                     label = "Variabel 1:",
#                     choices = keys,
#                     selected = "Kostnad individ- och familjeomsorg, kr/inv")
# 
# var2 <- selectInput(inputId = "categ2",
#                     label = "Variabel 2:",
#                     choices = keys,
#                     selected = "Nettokostnad äldreomsorg, kr/inv",
#                     multiple = TRUE)
# 
# regressionslinje  <-  checkboxInput(inputId = "smooth",
#                                     label = strong("Visa regressionslinje"),
#                                     value = FALSE)
# 
# smoothLine <- checkboxInput(inputId = "loess",
#                             label = "Loess",
#                             value = FALSE)
# 
# plotCond  <- "input.tab == 'Tidsserier' || input.tab == 'Tvåvägsplot'"


shinyUI(pageWithSidebar(
  
  headerPanel(paste("KLD Explorer", kVersion, sep=" ")),
  
  # MAIN PANEL (LEFT)
  #     source("ui/main.R", local=T)
  mainPanel(
    tabsetPanel(
      tabPanel("Start", verbatimTextOutput("frontpage"))
      #       ,tabPanel("Utforska", verbatimTextOutput("frontpage"))
      ,tabPanel("Utforska",
                plotOutput("utforska_plot"),
                verbatimTextOutput("utforska_text"))
      ,tabPanel("Analysera",
                plotOutput("analysera_plot"),
                verbatimTextOutput("analysera_text"))
      #       ,tabPanel("Kartplot", plotOutput("map_plot", height="800px"))
      #       ,tabPanel("Session info", verbatimTextOutput("sessioninfo"))
      ,id="mainmenu"
    )
  ),
  
  # SIDEBAR (RIGHT)
  #   source("ui/sidebar.R", local=T)
  sidebarPanel(
    
    # Root menu - frontpage
    conditionalPanel(
      condition = "input.mainmenu == 'Start'",
      selectInput(inputId = "frontpage_text",
                  label="Om KLD Explorer",
                  choices = c(
                    "Startsida" = "frontpage.R",
                    "Mer om KLD Explorer" = "more_info.R"),
                  selected = "Startsida"
      )
    ),
    
    # Root menu - UTFORSKA
    conditionalPanel(
      condition= "input.mainmenu == 'Utforska'",
      selectInput(inputId = "utforska_tool",
                  label="Välj metod för att utforska",
                  choices = XXX,
                  selected = XXX
    ),
    
    # Root menu - ANALYSERA
    conditionalPanel(
      
    )
  )
))