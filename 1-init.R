library(ProjectTemplate)
setwd("~/R/KLD_Explore")
load.project()

KLD_aldre1 <- read.csv("./data/kld_aldre1.csv", stringsAsFactors = FALSE)
Metadata.Kolada <- read.csv("./data/Metadata_Kolada.csv", stringsAsFactors = FALSE)

##### LÄS IN KOLADA-DATA #####
# (Ligger i ./data/, Görs automatiskt i project-filen)


##### MODIFIERA KOLADA-DATA #####
# Ta bort dubletter från Metadata.Kolada
Metadata.corr <- Metadata.Kolada[!duplicated(Metadata.Kolada$Kod),]

# Merga på nyckeltal på äldredata
aldre.long <- merge(KLD_aldre1[c(2:5)], Metadata.corr[c(2,4)], by.x="Nyckeltal", by.y="Kortnamn", sort=TRUE, all.x=TRUE)
aldre.long[is.na(aldre.long)] <- 0
aldre.long <- aldre.long[order(aldre.long$Kommun.Landsting),]

## KLD_aldre1 innehåller nyckeltalsvärden som inte mappas upp från Metadata-setet.
## Lös det tillfälligt genom att ta bort alla rader utan nyckeltal (==0).
aldre.long <- aldre.long[aldre.long$Kod != 0,]

#aldre.wide <- dcast(data=aldre.long, formula=... ~ Kod , value.var="Visat.Värde")

# Sortera och putsa aldre.nt
colnames(aldre.long) <- c("nyckel", "Kommun", "year", "value", "code")



# Hämta ut data för ett visst år och en viss variabel
aldre.2010 <- aldre.nt[aldre.nt$year == '2010',]
aldre.2010.N1 <- aldre.2010[aldre.2010$code == 'N23890',]