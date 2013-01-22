# Include init file
#source("./1-init.R")
library(ProjectTemplate)
load.project()

kommunNamn <- unique(KLData$Kommun)
kommunNamn <- sort(kommunNamn)

# Create dimensional data frame
commune <- wide_data$get_v("Kommun")
year <- wide_data$get_v("År")
dim_df <- data.table(Kommun=commune, År=year)

shinyServer(function(input, output) {
  
  #####################################################################
  ##          Internal functions                                     ##
  #####################################################################
  getOutputData <- reactive(function() {
    gg_df <- dim_df
    
    xvar <- wide_data$get_v(input$category)
    gg_df$var1 <- xvar
    
    yvar <- wide_data$get_v(input$categ2)
    gg_df$var2 <- yvar
    
    xname <- input$category
    yname <- input$categ2
    setnames(gg_df, 1:4, c("Kommun", "År", xname, yname))
    
    gg_df
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
    #     browser()
    
    gg_df <- getOutputData()

    kom_key <- get_lookup("Kommun", "./db/wide")
    
    setnames(gg_df, c(input$category, input$categ2), c("primary", "secondary"))
    
    # TODO: Change from KLData to the Coldbir wide db
    # (This might require implementing Coldbir Dimensions to data)
    p <- ggplot(data=gg_df, 
                aes(x=År,
                    y=primary,
                    xmin=min(allyears), 
                    xmax=max(allyears)
                ),
                subset=.(Kommun == 5),
                group=1
    )
    
#     browser()
    
    p <- p + layer(
      geom=input$graftyp
    )
    
    
    # Kod för utvärdering av två variabler med samma y-limits
    if(input$tvavar) {
      p <- p + layer(
        geom=input$graftyp, 
        subset=.(Variabelkod == input$categ2 & Kommun == input$kommun), 
        aes(color="red", fill="red")
      )
      
      if (input$smooth) {
        p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$categ2 & Kommun == input$kommun), aes(group=1,color="red"))
      }
    }
    
    if (input$smooth) {
      p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$category & Kommun == input$kommun), aes(group=1))
    }
    
    p <- p + ggtitle(input$kommun)
    
    print(p)
    print(paste("Kommun:", input$kommun))
  })
  
  
  
  #####################################################################
  ##          TWOWAY PLOT                                            ##
  #####################################################################
  output$twoway_plot <- reactivePlot(function() {  
    
    gg_df <- getOutputData()
    
    q <- ggplot(data=gg_df, aes_string(x=input$category, y=input$categ2, color="Kommun"))
    q <- q + layer(geom="point", subset=.(År == input$year))
    
    
    # TODO: Feetch this data from the Coldbir Metadata db
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
    
    # Load Sweden Shapefile
    sverige = readOGR(dsn="./mapdata/Kommuner_SCB/", layer="Kommungranser_SCB_07", input_field_name_encoding="ISO8859-1")
    sverige@data$id = rownames(sverige@data)
    sverige.points = fortify(sverige, region="id")
    sverige.df = join(sverige.points, sverige@data, by="id")
    
    # TODO: Change from KLData to the Coldbir db.
    # Merge with KLD data
    KL_mergeframe <- KLData[KLData$Variabelkod == input$category & KLData$År == input$year ,c("Kommun", "Värde")]
    setnames(KL_mergeframe, 1:2, c("KNNAMN", "Värde"))
    sverige.df.KL <- join(sverige.df, KL_mergeframe, by="KNNAMN", type="left")
    
    
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
            axis.ticks = element_blank())
    
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
