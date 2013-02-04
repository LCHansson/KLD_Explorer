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

# Constants
kIndataRoot <- "./indata/"
kIndataFileExtension <- "xls"
kDBRoot <- "./db/"

# Load libraries
require(gdata)
require(data.table)
require(Coldbir)

# Find all variables in Indata folder
xlsFiles <- list.files(kIndataRoot, paste("*.", kIndataFileExtension, sep=""))

# Load data and save it in a vector
for(varFile in xlsFiles) {
  # Read XLS file
  varContents <- read.xls(paste(varFile)
  
  # Find variable name
  varName <- gsub("*.xls", "", varFile)
}



# TEST CODE
# varName <- gsub("*.xls", "", xlsFiles[1])
