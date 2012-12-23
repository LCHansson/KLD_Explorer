
shinyServer(function(input, output) {
  
  output$main_plot <- reactivePlot(function() {
  	

    
    p <- ggplot(data=bakgr, aes(x=År, y=value, group=1, xmin=min(allyears), xmax=max(allyears)))
    #   p <- p + layer(geom=input$graftyp, subset = .(Kod == input$category & Kommun == input$kommun))
    p <- p + layer(
    	geom=input$graftyp, 
    	subset=.(Kod == input$category & Kommun == unique(bakgr$Kommun)[input$kommunNr]),
#     	title=bakgr$Kommun[input$kommunNr]
    	title="Test"
    )

    #    p <- p + ylim(0,100)
    
    # Kod för utvärdering av två variabler med samma y-limits
    if(input$tvavar) {
      p <- p + layer(geom=input$graftyp, subset=.(Kod == input$categ2 & Kommun == unique(bakgr$Kommun)[input$kommunNr]), aes(color="red", fill="red"))
      
      if (input$smooth) {
#       	p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Kod == input$categ2 & Kommun == input$kommun), aes(group=1))
      	p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Kod == input$categ2 & Kommun == unique(bakgr$Kommun)[input$kommunNr]), aes(group=1,color="red"))
      }
    }
    
    if (input$smooth) {
      p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Kod == input$category & Kommun == unique(bakgr$Kommun)[input$kommunNr]), aes(group=1))
    }
    
    p <- p + ggtitle(unique(bakgr$Kommun)[input$kommunNr])
    
    print(p)
    print(paste("Kommun:", input$kommunNr, unique(bakgr$Kommun)[input$kommunNr]))
  })
  
  output$twoway_plot <- reactivePlot(function() {  
    
    q <- ggplot(data=wide_var, aes(x=N15400, y=N15402, color=Kommun))
    q <- q + layer(geom="point", subset=.(År == input$year))
    q <- q + layer(geom="abline", aes(intercept=0, slope=1, linetype=2))
    q <- q + xlim(0,100) + ylim(0,100) + theme(legend.position = "right")
    print(q)
  })
  
  output$sessioninfo <- reactiveText(function() {
    print(input$graftyp)
    print(input$category)
    print(input$smooth)
    print(paste("Var1: ",input$category, ", var2: ", input$categ2))
    print(bakgr[bakgr$Kod == input$category,][1][[1]][[1]])
  })
})
