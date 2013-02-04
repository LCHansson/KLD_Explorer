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
  
  # Add map locations for annotations
  # label_points = coordinates(sverige)
  # label_points can then be used as mapping coordinates for geom_text()
  
})
