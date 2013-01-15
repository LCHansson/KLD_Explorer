output$timeseries_plot <- reactivePlot(function() {
  #     browser()
  p <- ggplot(data=KLData, aes(x=År, y=Värde, group=1, xmin=min(allyears), xmax=max(allyears)))
  #   p <- p + layer(geom=input$graftyp, subset = .(Variabelkod == input$category & Kommun == input$kommun))
  p <- p + layer(
    geom=input$graftyp,
    subset=.(Variabelkod == input$category & Kommun == input$kommun),
    #       title=KLData$Kommun[input$kommunNr]
    title="Test"
  )
  
  
  # Kod för utvärdering av två variabler med samma y-limits
  if(input$tvavar) {
    p <- p + layer(geom=input$graftyp, subset=.(Variabelkod == input$categ2 & Kommun == input$kommun), aes(color="red", fill="red"))
    
    if (input$smooth) {
      #       	p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$categ2 & Kommun == input$kommun), aes(group=1))
      p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$categ2 & Kommun == input$kommun), aes(group=1,color="red"))
    }
  }
  
  if (input$smooth) {
    p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$category & Kommun == input$kommun), aes(group=1))
  }
  
  p <- p + ggtitle(input$kommun)
  
  print(p)
  print(paste("Kommun:", input$kommun))
})