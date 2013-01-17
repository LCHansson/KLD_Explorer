# Include init file
source("./1-init.R")
kommunNamn <- unique(KLData$Kommun)
kommunNamn <- sort(kommunNamn)

# Create dimensional data frame
commune <- cdb$get_v("Kommun")
year <- cdb$get_v("År")
dim_df <- data.table(Kommun=commune, År=year)

shinyServer(function(input, output) {
  
  
  #####################################################################
  ##          FRONTPAGE/INFO PAGE                                    ##
  #####################################################################
  output$startpage <- reactiveText(function() {
    source(paste("./text_pages/", input$frontpage_text, sep=""))
    x <- "hej"
    as.character(x)
#     as.character(x)
  })
  
  
  
  #####################################################################
  ##          TIME SERIES PLOT                                       ##
  #####################################################################
  output$timeseries_plot <- reactivePlot(function() {
    #     browser()
    p <- ggplot(data=KLData, aes(x=År, y=Värde, group=1, xmin=min(allyears), xmax=max(allyears)))
    p <- p + layer(
      geom=input$graftyp,
      subset=.(Variabelkod == input$category & Kommun == input$kommun),
      title="Test"
    )
    
    # Kod för utvärdering av två variabler med samma y-limits
    if(input$tvavar) {
      p <- p + layer(geom=input$graftyp, subset=.(Variabelkod == input$categ2 & Kommun == input$kommun), aes(color="red", fill="red"))
      
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
    # Copy dimensional DF
    gg_df <- dim_df
    
    xvar <- cdb$get_v(input$category)
    yvar <- cdb$get_v(input$categ2)
    
    gg_df$var1 <- xvar
    gg_df$var2 <- yvar
    
    xname <- input$category
    yname <- input$categ2
    names(gg_df) <- c("Kommun", "År", xname, yname)
    
    q <- ggplot(data=gg_df, aes_string(x=xname, y=yname, color="Kommun"))
    q <- q + layer(geom="point", subset=.(År == input$year))
    q <- q + layer(geom="abline", aes(intercept=0, slope=1, linetype=2))
    q <- q + labs(
      x=xname,
      y=Metadata[Metadata$Kod == input$categ2, "Kortnamn"]
    )
    
    if(input$percentgraph) {
      q <- q + xlim(0,100) + ylim(0,100)
    }
    
    if(input$smooth) {
      q <- q + geom_smooth(method=ifelse(input$loess, "loess", "lm"), subset=.(År == input$year))
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
    sverige = readOGR(dsn="./mapdata/kommuner_SCB/", layer="Kommungranser_SCB_07")
    sverige@data$id = rownames(sverige@data)
    sverige.points = fortify(sverige, region="id")
    sverige.df = join(sverige.points, sverige@data, by="id")
    
    # Merge with KLD data
    KL_mergeframe <- KLData[KLData$Variabelkod == input$category & KLData$År == input$year ,c("Kommun", "Värde")]
    sverige.df.KL <- merge(sverige.df, KL_mergeframe, by.x="KNNAMN", by.y="Kommun", all=F)
    
    # Plot Sweden map
    p <- ggplot(sverige.df.KL) + 
      aes(long,lat,group=group,fill=Värde) + 
      geom_polygon() +
      #   geom_path(color="white") +
      coord_equal() +
      scale_fill_continuous() +
      theme_bw()
    
    print(p)
    
    # Add map locations for annotations
    # label_points = coordinates(sverige)
    # label_points can then be used as mapping coordinates for geom_text()
    
  })
  
  #####################################################################
  ##          OLD (FOR DELETION)                                     ##
  #####################################################################
  #   output$devcaption <- reactiveText(function() {
  #     "Utvecklingen av KLD Explorer"
  #   })
  #   
  #   output$development <- reactiveText(function() {
  #     y <- source("0-development.R")
  #     as.character(y)
  #   })
  #   
  #   output$morecaption <- reactiveText(function() {
  #     "Mer om projektet"
  #   })
  #   
  #   output$more_info <- reactiveText(function() {
  #     y <- source("0-more_info.R")
  #     as.character(y)
  #   })
  
  #   output$sessioninfo <- reactiveText(function() {
  #     print(input$graftyp)
  #     print(input$category)
  #     print(input$smooth)
  #     print(paste("Var1: ",input$category, ", var2: ", input$categ2))
  #     print(KLData[KLData$Variabelkod == input$category,][1][[1]][[1]])
  #     print(paste("Working directory:", getwd()))
  #   })
})
