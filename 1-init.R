library(ProjectTemplate)
setwd("~/R/KLD_Explore")
load.project()


##### LÄS IN KOLADA-DATA #####
# Äldredata
KLD_aldre1 <- read.csv("./data/kld_aldre1.csv", stringsAsFactors = FALSE)

# Misc data
KLD_misc1 <- read.csv("./data/kld_randomdata.csv", stringsAsFactors = FALSE, encoding="ISO8859-1")

# Enbart bakgrundsvariabler
KLD_bakgr1 <- read.csv("./data/kld_bakgr.csv", stringsAsFactors = FALSE, sep=";", fileEncoding="ISO8859-1")

## METADATA ##
# Läs in nyckeltals-metadata
Metadata.Kolada <- read.csv("./data/Metadata_Kolada.csv", stringsAsFactors = FALSE)


##### DATATVÄTT #####
# Ta bort dubletter från Metadata.Kolada
# Av någon anledning är vissa nyckeltal duplicerade i filen, men det finns även
# nyckeltal med olika kod men identiskt innehåll. Ta bort alla sådana dubletter.
Metadata.corr <- Metadata.Kolada[!duplicated(Metadata.Kolada$Kod),]
Metadata.corr <- Metadata.corr[!duplicated(Metadata.corr$Kortnamn),]

# Ändra headers i inläst data
colnames(KLD_bakgr1) <- c("Kommun", "Nyckeltal", "År", "value")


# Merga på nyckeltals-metadata
## TODO: Skriv om detta till en funktion?!?
bakgr <- merge(KLD_bakgr1, Metadata.corr[c("Kortnamn", "Kod")], by.x="Nyckeltal", by.y="Kortnamn")
bakgr[is.na(bakgr)] <- 0
bakgr <- bakgr[order(bakgr$Kommun),]

# Ta bort nyckeltalsnamn
bakgr <- bakgr[c(2:5)]

# Transformera från long till wide
bakgr.wide <- reshape(bakgr, direction="wide", timevar="Kod", idvar=c("År", "Kommun"))








aldre.long <- merge(KLD_aldre1[c(2:5)], Metadata.corr[c(2,4)], by.x="Nyckeltal", by.y="Kortnamn", sort=TRUE, all.x=TRUE)
aldre.long[is.na(aldre.long)] <- 0
aldre.long <- aldre.long[order(aldre.long$Kommun.Landsting),]

## KLD_aldre1 innehåller nyckeltalsvärden som inte mappas upp från Metadata-setet.
## Lös det tillfälligt genom att ta bort alla rader utan nyckeltal (==0).
aldre.long <- aldre.long[aldre.long$Kod != 0,]


# Sortera och putsa aldre.nt
colnames(aldre.long) <- c("nyckel", "kommun", "year", "value", "code")

# Transponera till wide
aldre.wide <- reshape(aldre.long, direction="wide", timevar="code", idvar=c("year", "kommun"))


# Hämta ut data för ett visst år och en viss variabel
aldre.2010 <- aldre.nt[aldre.nt$year == '2010',]
aldre.2010.N1 <- aldre.2010[aldre.2010$code == 'N23890',]