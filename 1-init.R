library(ProjectTemplate)
setwd("~/R/KLD_Explorer")
load.project()


##### METADATA #####
# Läs in nyckeltals-metadata
Metadata.Kolada <- read.csv("./data/Metadata_Kolada.csv", stringsAsFactors = FALSE)

# Ta bort dubletter från Metadata.Kolada
# Av någon anledning är vissa nyckeltal duplicerade i filen, men det finns även
# nyckeltal med olika kod men identiskt innehåll. Ta bort alla sådana dubletter.
Metadata.corr <- Metadata.Kolada[!duplicated(Metadata.Kolada$Kod),]
Metadata.corr <- Metadata.corr[!duplicated(Metadata.corr$Kortnamn),]

##### LÄS IN KOLADA-DATA ##### 

## NEDLADDAD DATA (format: long)
bakgr <- loadKLData("kld_bakgr")
miscdata <- loadKLData("kld_randomdata")

bakgr <- loadKLData("kld_randomdata")
