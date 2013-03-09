# Include init file
#source("./1-init.R")
library(ProjectTemplate)
load.project()

kommunNamn <- unique(KLData$Kommun)
kommunNamn <- sort(kommunNamn)

# Create dimensional data frame
commune <- wide_data$get_v("Kommun")
year <- wide_data$get_v("Year")
dim_DT <- data.table(Kommun=commune, År=year, key="Kommun")

kom_key <- get_lookup("Kommun", "./db/wide2")

## Create Sweden map data
# Set gpclibPermitStatus() to TRUE
# (Whatever that means...)
gpclibPermit()

# Load Shapefile
sverige = readOGR(dsn="./mapdata/Kommuner_SCB/", layer="Kommungranser_SCB_07", input_field_name_encoding="ISO8859-1")
sverige@data$id = rownames(sverige@data)
sverige.points = fortify(sverige, region="id")
sverige.df = join(sverige.points[,c("long", "lat", "group", "id")], sverige@data[,c("KNNAMN", "id")], by="id")

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
