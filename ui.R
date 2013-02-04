var1 <- selectInput(inputId = "category",
                    label = "Variabel 1:",
                    choices = keys,
                    selected = "Kostnad individ- och familjeomsorg, kr/inv")

var2 <- selectInput(inputId = "categ2",
                    label = "Variabel 2:",
                    choices = keys,
                    selected = "Nettokostnad äldreomsorg, kr/inv")

regressionslinje  <-  checkboxInput(inputId = "smooth",
                                    label = strong("Visa regressionslinje"),
                                    value = FALSE)

smoothLine <- checkboxInput(inputId = "loess",
                            label = "Loess",
                            value = FALSE)

plotCond  <- "input.tab == 'Tidsserier' || input.tab == 'Tvåvägsplot'"


shinyUI(pageWithSidebar(
  
  headerPanel(paste("KLD Explorer", kVersion, sep=" ")),
  
  source("ui/sidebar.R", local=T),
  
  mainPanel(
    source("ui/graphwindow.R", local=T),
    source("ui/varbar.R", local=T)
    )
  )
)