##############################################
#                                            #
######## VISUALISERING AV KOLADA-DATA ########
#                                            #
##############################################


p <- ggplot(data=aldre.long[aldre.long$year==2011,], aes(x=value, y=kommun))

p + geom_bar(aes(fill=code), position=position_dodge())

p <- ggplot(data=aldre.long, aes(x=År, y=Visat.Värde, fill=År))
p + geom_boxplot(aes(fill=Kod))
p + geom_boxplot() + geom_point()

p + geom_point()


p <- ggplot(aldre.wide, aes(x=value.N21890, y=value.N23890))

p + geom_point(alpha=0.5) + geom_smooth(method="lm")