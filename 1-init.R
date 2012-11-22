library(ProjectTemplate)
setwd("~/R/KLD_Explore")



##### LÄS IN KOLADA-DATA #####
# (Ligger i ./data/, Görs automatiskt i project-filen)


##### MODIFIERA KOLADA-DATA #####
# Ta bort dubletter från Metadata.Kolada
Metadata.corr <- Metadata.Kolada[!duplicated(Metadata.Kolada$Kod),]

# Merga på nyckeltal på äldredata
tid <- system.time(aldre.nt <- merge(kld.aldre1[c(2:5)], Metadata.corr[c(2,4)], by.x="Nyckeltal", by.y="Kortnamn", sort=TRUE, all.x=TRUE))

# Sortera och putsa aldre.nt
colnames(aldre.nt) <- c("nyckel", "NAME_2", "year", "value", "code")


aldre.nt <- aldre.nt[order(aldre.nt$kommun),]
aldre.nt[is.na(aldre.nt)] <- 0
aldre.nt <- aldre.nt[order(aldre.nt$Kommun.Landsting),]

# Hämta ut data för ett visst år och en viss variabel
aldre.2010 <- aldre.nt[aldre.nt$year == '2010',]
aldre.2010.N1 <- aldre.2010[aldre.2010$code == 'N23890',]