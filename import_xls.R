# IMPORT_XLS.R
#
# Imports any .xls files placed directly in the ./indata root and saves them
# as a .csv file in the ./db root.
#
# TODO:
# - Implement saving directly to the Coldbir DB?
# - Allow for horizontally incremental updates (i.e. add new *variables*
# without adding all old ones)
#
# Structure:
# 1. Read contents of the indata root and put names in a vector
# 2. Read every file using package gdata and save values to a column in a
#    data.table
# 3. Save the data.table to a Coldbir instance

Constants
kIndataRoot <- "./indata/"
kIndataFileExtension <- ".xls"
kDBRoot <- "./db/"

# Load libraries
require(gdata)
require(data.table)
require(Coldbir)

# Find all variables in Indata folder
xlsFiles <- list.files(kIndataRoot, paste("*", kIndataFileExtension, sep=""))

rm(KLD_data)

# Load data and save it in a vector
for(varFile in xlsFiles) {
  
  cat("Reading file:",varFile, "\n")
  
  # Read XLS file
  varContents <- data.table(
    read.xls(
      paste(
        kIndataRoot,
        varFile,
        sep=""
      ),
      fileEncoding="ISO8859-1"
    )
  )[,list(Kommun.Landsting, År, Visat.Värde)]
  
  # Index indata
  setkeyv(varContents, c("Kommun.Landsting", "År"))
  
  cat("Indata Keys:", key(varContents), "\n")
  cat("Indata Names:", names(varContents), "\n")
  
  # Find variable name and merge names and set it to be the title of the value column
  # (The names() call is due to encoding problems)
  varName <- gsub("*.xls", "", varFile)
  setnames(varContents, names(varContents), c("Kommun", "Year", varName))
  
  cat("Prepset Names:", names(varContents), "\n")
  
  # Merge/create indata with main data.table
  if(!exists("KLD_data")) {
    KLD_data <- copy(varContents)
  } else {
    cat("Masterdata keys:", key(KLD_data), "\n")
    cat("Masterdata names:", names(KLD_data), "\n***\n")
    KLD_data <- merge(KLD_data, varContents, by=c("Kommun", "Year"), all=T)
  }
}

# Write to .csv
write.csv(KLD_data,
          paste(kDBRoot, "nyckeltal2.csv", sep=""),
          row.names=F
)

# EOF cleanup
rm(list=ls())

# TEST CODE
# varName <- gsub("*.xls", "", xlsFiles[1])
