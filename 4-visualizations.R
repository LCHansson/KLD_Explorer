##############################################
#                                            #
######## VISUALISERING AV KOLADA-DATA ########
#                                            #
##############################################


p <- ggplot(data=aldre.long[aldre.long$År==2011,], aes(x=Visat.Värde, y=Kommun.Landsting))

p + geom_bar(aes(fill=Kod), position=position_stack())

p <- ggplot(data=aldre.long, aes(x=År, y=Visat.Värde))
p + geom_boxplot(group=aldre.long$Kommun.Landsting, aes(fill=Kommun.Landsting))
p + geom_boxplot()