p <- ggplot(KLData[KLData$Nyckeltal %in% c("N00800","N00084"),])

p + geom_point(aes(x=År, y=Värde))