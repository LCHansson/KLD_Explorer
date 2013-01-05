p <- ggplot(data=diamonds)

p + geom_point(aes(x=carat, y=depth, color=cut)) + 
  xlim(0,4) +
  ggtitle("Diamonds") +
  labs(x="", y="") +
  theme(
    legend.position="none",
    axis.text = element_blank(),
    axis.ticks = element_blank(),
   plot.title = element_text(family="serif", face="italic", size=rel(1.1))
  )

