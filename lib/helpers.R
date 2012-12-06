loadKLData <- function(title)
{
  typeof(title)
  path <- paste("./data/", title, ".csv", sep="")
  sprintf(path)
  
  # Loads and cleans data from the ./data folder.
  # Data must be in the following format:
  # - csv (sep=";")
  # - encoded in ISO8859-1
  # - Four columns: "Kommun", "Nyckeltal", "År", "Visat_Värde"
  x <- read.csv(path, sep=";", stringsAsFactors = FALSE, fileEncoding="ISO8859-1")
  
  # Add metadata
  x <- merge(x, Metadata.corr[c("Kortnamn", "Kod")], by.x="Nyckeltal", by.y="Kortnamn")

  # Drop "Nyckeltal" column
  #x <- x[,!colnames(x) %in% "Nyckeltal"]
  
  # Clean NAs and order data for browsability
  x[is.na(x)] <- 0
  x <- x[order(x$Kommun),]
  
  # Rename columns
  colnames(x) <- c("Beskrivning", "Kommun", "År", "value", "Kod")
  
  return(x)
}