u <- unstack(unique(bakgr[,c("Kod", "Beskrivning")]))
keys <- c(u[,1])
names(keys) <- rownames(u)

runApp("Shiny")



variabler <- unique(bakgr$Kod)
kommuner <- unique(bakgr$Kommun)

