##### INIT #####
# source("./lib/helpers.R")
checkPackageDeps()
# library(ProjectTemplate)
# load.project()
# setwd("~/R/KLD_Explorer")


##### LÄS IN KOLADA-DATA ##### 
Metadata <- loadKLMetadata()

## NEDLADDAD DATA (format: long)
KLData <- loadKLData()

## LÄS PÅ METADATA PÅ KLData
KLData <- appendMetadata(KLData, Metadata)


## SKAPA ETIKETTVARIABEL FÖR DROP DOWN-MENYER
u <- unstack(unique(KLData[,c("Variabelkod", "Kortnamn")]))
keys <- c(u[,1])
names(keys) <- rownames(u)

allyears <- unique(KLData$År)



# Skapa wide-dataset och ta bort beskrivningsvariabeln
# wide_time <- dcast(KLData, Kommun + Beskrivning + Variabelkod ~ År, value.var = "Värde")
# KLData <- bakgr[,2:5]
wide_data <- coldbir:::db$new('./db/wide')

wide_var <- dcast(KLData, Kommun + År ~ Variabelkod, value.var="Värde")
# wide <- reshape(bakgr, varying=c("Kod", "Beskrivning", "value"), v.names="test", timevar="År", idvar="Kommun", direction="wide")

allyears <- unique(KLData$År)
allyears <- allyears[sort.list(allyears)]
