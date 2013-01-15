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