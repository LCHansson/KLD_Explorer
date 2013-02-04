sidebarPanel(
  conditionalPanel(condition = "input.tab == 'Start'",
                   selectInput(inputId = "frontpage_text",
                               label="About KLD Explorer",
                               choices = c(
                                 "Startsida" = "0-startpage.R",
                                 "Mer om KLD Explorer" = "0-more_info.R"),
                               selected = "Startsida"
                   )
  ),
  
  #     conditionalPanel(condition = "input.tab != 'Start'",
  #                      selectInput(inputId = "category",
  #                                  label = "Variabel 1:",
  #                                  choices = keys,
  #                                  selected = "Nettokostnad äldreomsorg, kr/inv"),
  #     ),
  
  
  conditionalPanel(condition = "input.tab != 'Start'", var1),
  
  conditionalPanel(condition = "input.tab == 'Tidsserier'",
                   checkboxInput(inputId = "tvavar",
                                 label = strong("Visa variabel 2"),
                                 value = FALSE)
  ),
  
  conditionalPanel(condition = "input.tab == 'Tvåvägsplot' || (input.tab == 'Tidsserier' && input.tvavar == true)", var2),
  
  conditionalPanel(condition = plotCond, regressionslinje),
  
  
  # Display this only if the density is shown
  conditionalPanel(condition = "input.smooth == true", smoothLine),
  
  conditionalPanel(condition = "input.tab == 'Tidsserier'",
                   selectInput(inputId = "kommun",
                               label = "Kommun",
                               choices = sort(unique(KLData$Kommun)),
                               selected = "Ale"
                   )),
  
  conditionalPanel(condition = "input.tab == 'Tidsserier'",
                   selectInput(inputId = "graftyp",
                               label = "Plotkategori:",
                               choices = c("point",
                                           "line",
                                           "jitter")
                   )),
  
  # Options below only apply to twoway graph    
  conditionalPanel("input.tab == 'Tvåvägsplot' || input.tab == 'Kartplot'",
                   sliderInput(inputId="year",
                               label="År:",
                               format="####",
                               min=min(allyears),
                               max=max(allyears),
                               value=2008,
                               step=1,
                               animate=T
                   )),
  
  conditionalPanel("input.tab == 'Tvåvägsplot'",
                   checkboxInput(inputId="percentgraph",
                                 label="Anpassa grafen för procentvariabler",
                                 value=FALSE
                   )),
  
  conditionalPanel(plotCond,
                   downloadButton('downloadData', 'Eportera data (.csv)'))
  
  # This is unused, invisible slider is necessary because of a bug
  #     ,conditionalPanel(
  #       condition = "false",
  #       sliderInput("nothing", "This does nothing:",
  #                   min = 1, max = 1000, value = 100)
  #     )
)
