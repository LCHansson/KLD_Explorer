##### SKAPA SVERIGEKARTA #####
# Ref: https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles

libraries <- c("rgdal", "ggplot2", "maptools", "gpclib")
lapply(libraries, library, character.only = TRUE)
rm(libraries)

# Set gpclibPermitStatus() to TRUE
# (Whatever that means...)
gpclibPermit()

# Load Sweden Shapefile
sverige = readOGR(dsn="./mapdata/kommuner_SCB/", layer="Kommungranser_SCB_07")
sverige@data$id = rownames(sverige@data)
sverige.points = fortify(sverige, region="id")
sverige.df = join(sverige.points, sverige@data, by="id")


KL_mergeframe <- KLData[KLData$Variabelkod == "N40011" & KLData$År == 2009,c("Kommun", "Värde")]
sverige.df.KL <- merge(sverige.df, KL_mergeframe, by.x="KNNAMN", by.y="Kommun", all=F)


# Plot Sweden map
ggplot(sverige.df.KL) + 
  aes(long,lat,group=group,fill=Värde) + 
  geom_polygon() +
#   geom_path(color="white") +
  coord_equal() +
  scale_fill_continuous() +
  theme_bw()

# Add map locations for annotations
# label_points = coordinates(sverige)
# label_points can then be used as mapping coordinates for geom_text()