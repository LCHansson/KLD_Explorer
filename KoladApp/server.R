shinyServer(function(input, output) {
  
  output$main_plot <- reactivePlot(function() {
    
    p <- ggplot(data=bakgr, aes(x=År, y=value, group=1))
    #   p <- p + layer(geom=input$graftyp, subset = .(Kod == input$category & Kommun == input$kommun))
    p <- p + layer(geom=input$graftyp, subset=.(Kod == input$category & Kommun == input$kommun))
    #    p <- p + ylim(0,100)
    
    # Kod för utvärdering av två variabler med samma y-limits
    if(input$tvavar) {
      p <- p + layer(geom=input$graftyp, subset=.(Kod == input$categ2 & Kommun == input$kommun), aes(color="red", fill="red"))
      
      if (input$smooth) {
        p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Kod == input$categ2 & Kommun == input$kommun), aes(group=1))
      }
    }
    
    if (input$smooth) {
      p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Kod == input$category & Kommun == input$kommun), aes(group=1))
    }
    
    print(p)
  })
  
  output$twoway_plot <- reactivePlot(function() {
    xvar <- as.double(wide_var[,input$category])
    yvar <- as.double(wide_var[,input$categ2])
    # browser()
    p <- ggplot(data=wide_var)
    p <- p + layer(geom=input$graftyp, aes(x=xvar, y=yvar)) + xlim(0,100) + ylim(0,100)
    print(p)
  })
  
  output$sessioninfo <- reactiveText(function() {
    print(input$graftyp)
    print(input$category)
    print(input$smooth)
    print(paste("Var1: ",input$category, ", var2: ", input$categ2))
    print(bakgr[bakgr$Kod == input$category,][1][[1]][[1]])
  })
})
