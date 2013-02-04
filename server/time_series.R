output$timeseries_plot <- reactivePlot(function() {
  
  gg_DT <- getOutputData()[subset(kom_key, value == c(input$kommun))["value"]]
  
  p <- ggplot(data=gg_DT,
              group=1
  ) + 
    aes_string(x="År",
               y=input$category,
               xmin=min(allyears), 
               xmax=max(allyears)
    )
  
  p <- p + layer(
    geom=input$graftyp
  )
  
  # Kod för utvärdering av två variabler med samma y-limits
  if(input$tvavar) {
    p <- p + layer(
      geom=input$graftyp,
      aes(color="red", fill="red"),
      mapping=aes_string(x="År",
                         y=input$categ2)
    )
    
    if (input$smooth) {
      p <- p + geom_smooth(
        method=ifelse(input$loess == TRUE, "loess", "lm"), 
        mapping=aes_string(x="År", y=input$categ2),
        color="red"
      )
    }
  }
  
  if (input$smooth) {
    p <- p + geom_smooth(
      method=ifelse(input$loess == TRUE, "loess", "lm"), 
      mapping=aes_string(x="År", y=input$category)
    )   
  }
  
  p <- p + ggtitle(input$kommun)
  p <- p + labs(
    x="År",
    y=ifelse(!input$tvavar, "Variabel 1 (svart)", "Variabel 1 (svart), variabel 2 (röd)")
  )
  
  
  print(p)
})
