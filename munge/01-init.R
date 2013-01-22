##### INIT #####
# source("./lib/helpers.R")
checkPackageDeps()
Sys.setlocale("LC_ALL", "sv_SE.UTF-8")
# library(ProjectTemplate)
# load.project()
# setwd("~/R/KLD_Explorer")


##### LÄS IN KOLADA-DATA ##### 

# TODO: Remove this. Implement Metadata fetching from the Coldbir Metadata db instead.
Metadata <- loadKLMetadata()


## NEDLADDAD DATA (format: long)

# TODO: Remove this. Read all data from the Coldbir Wide db instead.
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

# wide_var <- dcast(KLData, Kommun + År ~ Variabelkod, value.var="Värde")
# wide <- reshape(bakgr, varying=c("Kod", "Beskrivning", "value"), v.names="test", timevar="År", idvar="Kommun", direction="wide")

allyears <- unique(KLData$År)
allyears <- allyears[sort.list(allyears)]
