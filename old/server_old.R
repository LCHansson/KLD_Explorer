##### SERVER.R #####
# This is the server script for KLD_Explorer.
# 
# The script also includes the pre-loading of data and packages through
# ProjectTemplate::load.project().
#
# See Readme.md for more details on the project structure.

# Include init file
#source("./1-init.R")
library(ProjectTemplate)
load.project()


shinyServer(function(input, output) {
  
  #####################################################################
  ##          Internal functions                                     ##
  #####################################################################
  getOutputData <- reactive(function() {
    DT <- copy(dim_DT)
    
    xvar <- wide_data$get_v(input$category)
    
    yvar <- wide_data$get_v(input$categ2)
    
    xname <- input$category
    yname <- input$categ2
    
    DT[,c("xvar", "yvar") := list(xvar, yvar)]
    
    setnames(DT, names(DT), c("Kommun", "År", xname, yname))
    
    return(DT)
  })
  
  ##### TABSETS #####
  
  #####################################################################
  ##          FRONTPAGE/INFO PAGE                                    ##
  #####################################################################
  source("server/frontpage.R", local=T)
  
  
  #####################################################################
  ##          TIME SERIES PLOT                                       ##
  #####################################################################
  source("server/time_series.R", local=T)
  
  
  #####################################################################
  ##          TWOWAY PLOT                                            ##
  #####################################################################
  source("server/twoway.R", local=T)
  
  
  #####################################################################
  ##          MAP PLOT                                               ##
  #####################################################################
  source("server/map.R", local=T)
  
  #####################################################################
  ##          DOWNLOAD FUNCTION                                      ##
  #####################################################################
  output$downloadData <- downloadHandler(
    filename = function() {paste(input$category, '.csv', sep='') },
    content = function(file) {
      write.csv(getOutputData(), file)
    }
  )
  
  
  
  #####################################################################
  ##          SESSION INFO (for evaluation purposes only)            ##
  #####################################################################
  
  output$sessioninfo <- reactiveText(function() {
    print(input$graftyp)
    print(input$category)
    print(input$smooth)
    print(paste("Var1: ",input$category, ", var2: ", input$categ2))
    print(KLData[KLData$Variabelkod == input$category,][1][[1]][[1]])
    print(paste("Working directory:", getwd()))
  })
})
