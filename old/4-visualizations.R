# ########################################## #
#                                            #
######## VISUALISERING AV KOLADA-DATA ########
#                                            #
# ########################################## #

##### PRODUKTIONSKOD ######
p <- ggplot(data=bakgr[bakgr$År == 2010,], aes(x=Kod, y=value))
p + geom_point()



##### EXPERIMENTELL KOD #####
# Detta avsnitt är inte avsett för produktion utan för experiment.
# Produktionskod återfinns nedan.
p + geom_bar(aes(fill=Kod))


p <- ggplot(data=aldre.long[aldre.long$year==2011,], aes(x=value, y=kommun))

p + geom_bar(aes(fill=code), position=position_dodge())

p <- ggplot(data=aldre.long, aes(x=År, y=Visat.Värde, fill=År))
p + geom_boxplot(aes(fill=Kod))
p + geom_boxplot() + geom_point()

p + geom_point()


p <- ggplot(aldre.wide, aes(x=year, y=value.N21890))
p + geom_bar(position=position_dodge(), stat="identity")

p + geom_point(alpha=0.5) + geom_smooth(method="lm")


p <- ggplot(bakgr.wide[bakgr.wide$År==c(2008,2009,2010),], aes(x=value.N00919, y=value.N00910))
p + geom_point() + geom_smooth(method="lm")