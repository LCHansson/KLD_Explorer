# Include init file
#source("./1-init.R")
library(ProjectTemplate)
load.project()

kommunNamn <- unique(KLData$Kommun)
kommunNamn <- sort(kommunNamn)

# Create dimensional data frame
commune <- wide_data$get_v("Kommun")
year <- wide_data$get_v("År")
dim_DT <- data.table(Kommun=commune, År=year, key="Kommun")

kom_key <- get_lookup("Kommun", "./db/wide")

# Load Sweden Shapefile
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
  output$frontpage <- reactiveText(function() {
    source(paste("./text_pages/", input$frontpage_text, sep=""))
    #     x <- as.character(input$frontpage_text)
    #     print(x)
    as.character(x)
  })
  
  
  
  #####################################################################
  ##          TIME SERIES PLOT                                       ##
  #####################################################################
  output$timeseries_plot <- reactivePlot(function() {
    
    gg_DT <- getOutputData()[subset(kom_key, value == c(input$kommun))["value"]]
    
    p <- ggplot(data=gg_DT,
                group=1
    ) + 
      aes_string(x="År",
                 y=input$category,
                 xmin=min(allyears), 
                 xmax=max(allyears)
      )
    
    p <- p + layer(
      geom=input$graftyp
    )
    
    # Kod för utvärdering av två variabler med samma y-limits
    if(input$tvavar) {
      p <- p + layer(
        geom=input$graftyp,
        aes(color="red", fill="red"),
        mapping=aes_string(x="År",
                           y=input$categ2)
      )
      
      if (input$smooth) {
        p <- p + geom_smooth(
          method=ifelse(input$loess == TRUE, "loess", "lm"), 
          mapping=aes_string(x="År", y=input$categ2),
          color="red"
        )
      }
    }
    
    if (input$smooth) {
      p <- p + geom_smooth(
        method=ifelse(input$loess == TRUE, "loess", "lm"), 
        mapping=aes_string(x="År", y=input$category)
      )   
    }
    
    p <- p + ggtitle(input$kommun)
    p <- p + labs(
      x="År",
      y=ifelse(!input$tvavar, "Variabel 1 (svart)", "Variabel 1 (svart), variabel 2 (röd)")
    )
    
    
    print(p)
  })
  
  
  
  #####################################################################
  ##          TWOWAY PLOT                                            ##
  #####################################################################
  output$twoway_plot <- reactivePlot(function() {  
    
    gg_DT <- getOutputData()
    
    q <- ggplot(data=gg_DT, aes_string(x=input$category, y=input$categ2, color="Kommun"))
    q <- q + layer(geom="point", subset=.(År == input$year))
    
    q <- q + labs(
      x=Metadata[Metadata$Kod == input$category, "Kortnamn"],
      y=Metadata[Metadata$Kod == input$categ2, "Kortnamn"]
    )
    
    
    if(input$percentgraph) {
      q <- q + xlim(0,100) + ylim(0,100)
      q <- q + layer(geom="abline", aes(intercept=0, slope=1, linetype=2))
    }
    
    if(input$smooth) {
      q <- q + geom_smooth(method=ifelse(input$loess, "loess", "lm"), se=FALSE, subset=.(År == input$year))
    }
    
    q <- q + ggtitle("Spridning per kommun")
    
    print(q)
  })
  
  
  
  #####################################################################
  ##          MAP PLOT                                               ##
  #####################################################################
  
  ##### SKAPA SVERIGEKARTA #####
  # Ref: https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles
  
  output$map_plot <- reactivePlot(function() {
    
    # Set gpclibPermitStatus() to TRUE
    # (Whatever that means...)
    gpclibPermit()
    
    gg_DT <- subset(getOutputData(), År == input$year)[,c("Kommun", input$category), with=F][kom_key]
        
    # Merge shapefile with KLD data
    setnames(gg_DT, names(gg_DT), c("Kommun", "Värde", "KNNAMN"))    
    sverige.df.KL <- join(sverige.df, gg_DT, by="KNNAMN", type="left")
    
#     browser()
    
    # Plot Sweden map
    p <- ggplot(sverige.df.KL, na.rm=TRUE) + 
      aes(long,lat,group=group,fill=Värde) + 
      geom_polygon() +
      #   geom_path(color="white") +
      coord_equal() +
      scale_fill_continuous(na.value="gray80") +
      theme_bw() +
      theme(axis.title = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank()
      )
    
    print(p)
    
    #     browser()
    
    # Add map locations for annotations
    # label_points = coordinates(sverige)
    # label_points can then be used as mapping coordinates for geom_text()
    
  })
  
  
  
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
