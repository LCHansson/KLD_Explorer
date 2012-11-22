##############################################
#                                            #
######## VISUALISERING AV KOLADA-DATA ########
#                                            #
##############################################


p <- ggplot(data=aldre.long[aldre.long$År==2011,], aes(x=Visat.Värde, y=Kommun.Landsting))

p + geom_bar(aes(fill=Kod), position=position_stack())

p <- ggplot(data=aldre.long, aes(x=Kommun.Landsting, y=Visat.Värde))
p + geom_boxplot(group=aldre.long$År)
p + geom_boxplot()