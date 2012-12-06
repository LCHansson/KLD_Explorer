shinyServer(function(input, output) {
  
  output$main_plot <- reactivePlot(function() {
    
    p <- ggplot(data=bakgr, aes(x=År, y=value, group=År))
    #   p <- p + layer(geom=input$graftyp, subset = .(Kod == input$category & Kommun == input$kommun))
    p <- p + layer(geom=input$graftyp, subset=.(Kod == input$category & Kommun == input$kommun))
    
    #     if (input$smooth) {
    #       p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Kod == input$category & Kommun == input$kommun), aes(group=1))
    #     }
    
    print(p)
    
  })
  
  output$sessioninfo <- reactiveText(function() {
    print(input$graftyp)
    print(input$category)
    print(input$smooth)
    print(bakgr[bakgr$Kod == input$category,][1][[1]][[1]])
  })
})
