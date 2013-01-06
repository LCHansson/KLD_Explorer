
##### INIT #####
checkPackageDeps <- function() {
  requiredPackages <- c("ggplot2", "sp", "lubridate", "coldbir", "devtools", "ProjectTemplate", "reshape2", "XLConnect")
  
  for(package in requiredPackages) {
    if (!package %in% installed.packages()) {
      install.packages(package) # TODO: Implementera install_github om install.packages ger ett error
    } 
  }
}


##### DB FUNCTIONS #####
loadKLMetadata <- function(){
  ##### METADATA #####
  # Läs in nyckeltals-metadata
  Metadata.Kolada <- read.csv("./indata/metadata/Metadata_Kolada.csv", stringsAsFactors = FALSE)[,2:4] # Remove strange "X" column
  
  # Ta bort dubletter från Metadata.Kolada
  # Av någon anledning är vissa nyckeltal duplicerade i filen, men det finns även
  # nyckeltal med olika kod men identiskt innehåll. Ta bort alla dubletter av Kod
  Metadata.corr <- Metadata.Kolada[!duplicated(Metadata.Kolada$Kod),]
  return(Metadata.corr)
}


loadKLData <- function(){
  x <- read.csv("db/nyckeltal.csv", sep=",", stringsAsFactors = FALSE, fileEncoding="UTF-8")
  
  return(x)
}

appendMetadata <- function(indata, metadata, byname="Variabelkod", metaname="Kod"){
  KLData <- merge(indata, metadata,by.x=byname, by.y=metaname, all.x=T, all.y=F)
}







listKLIndata <- function(path = paste(getwd(), "/indata/", sep="")) {
  datafiles <- list.files(path=path, pattern="*.xls")
  
  return(datafiles)
}


listKLDBcols <- function() {
  collist <- getlistofKLDBcols()
  
  return(collist)
}

addtoKLDB <- function(path=paste(getwd(),"/indata/", sep=""), varlist="") {
  for(varname in varlist)
    loadKLData() 
}