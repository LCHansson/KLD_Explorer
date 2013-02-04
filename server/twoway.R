output$twoway_plot <- reactivePlot(function() {  
  
  gg_DT <- getOutputData()
  
  q <- ggplot(data=gg_DT, aes_string(x=input$category, y=input$categ2, color="Kommun"))
  q <- q + layer(geom="point", subset=.(År == input$year))
  
  q <- q + labs(
    x=Metadata[Metadata$Kod == input$category, "Kortnamn"],
    y=Metadata[Metadata$Kod == input$categ2, "Kortnamn"]
  )
  
  
  if(input$percentgraph) {
    q <- q + xlim(0,100) + ylim(0,100)
    q <- q + layer(geom="abline", aes(intercept=0, slope=1, linetype=2))
  }
  
  if(input$smooth) {
    q <- q + geom_smooth(method=ifelse(input$loess, "loess", "lm"), se=FALSE, subset=.(År == input$year))
  }
  
  q <- q + ggtitle("Spridning per kommun")
  
  print(q)
})
