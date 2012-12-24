require(sp)
require(RColorBrewer)

# Ladda data för Tyskland
#con <- url("http://gadm.org/data/rda/DEU_adm3.RData")
#print(load(con))
#close(con)

# Ladda data för Sverige
con <- url("http://gadm.org/data/rda/SWE_adm2.RData")
print(load(con))
close(con)

# Test: Definiera en enkel regnbådspalett efter antalet kommuner, plotta kommuner 
col = rainbow(length(levels(gadm$NAME_2)))
spplot(gadm, "NAME_2", col.regions=col, main="Svenska kommuner", colorkey = FALSE, lwd=.4, col="white")

# Korrigera encodings
gadm_names <- iconv(gadm$NAME_2, "UTF-8", "ISO8859-1") 

col_no <- as.factor(as.numeric(cut(gadm2$value, c(0,2.5,5,7.5,10,15,60))))

levels(col_no) <- c(">2,5%", "2,5-5%", "5-7,5%","7,5-10%", "10-15%", ">15%")

gadm2 <- merge(gadm, aldre.2010.N1, by="NAME_2")

gadm2$col_no <- col_no
myPalette<-brewer.pal(6,"Purples")

spplot(gadm2, "col_no", col=grey(.9), col.regions=myPalette,
       main="Visat Värde")

