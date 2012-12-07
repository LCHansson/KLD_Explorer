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
bakgr <- loadKLData("kld_randomdata")
bakgr <- loadKLData("kld_bakgr")
bakgr <- loadKLData("kld_sthlm2")

## SKAPA ETIKETTVARIABEL FÖR DROP DOWN-MENYER
u <- unstack(unique(bakgr[,c("Kod", "Beskrivning")]))
keys <- c(u[,1])
names(keys) <- rownames(u)

# Skapa wide-dataset och ta bort beskrivningsvariabeln
wide_time <- dcast(bakgr, Kommun + Beskrivning + Kod ~ År, value.var = "value")

bakgr <- bakgr[,2:5]

wide_var <- dcast(bakgr, Kommun + År ~ Kod, value.var="value")
#wide <- reshape(bakgr, varying=c("Kod", "Beskrivning", "value"), v.names="test", timevar="År", idvar="Kommun", direction="wide")