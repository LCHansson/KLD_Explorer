##### KLD EXPLORER CONSTANTS #####
kVersion <- "0.2.1"

# Get geographic labels
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