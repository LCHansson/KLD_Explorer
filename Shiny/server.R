shinyServer(function(input, output) {
  
  output$main_plot <- reactivePlot(function() {
    
    #    p <- ggplot(data=bakgr[bakgr$Kod == input$category & bakgr$Kommun == input$kommun,], aes(x=År, y=value))
    p <- ggplot(data=bakgr[bakgr$Kod == input$category & bakgr$Kommun == input$kommun,], aes(x=År, y=value))
    #    p <- ggplot(data=bakgr[bakgr$Kod == input$category,], aes(x=År, y=value, group=1))
    #p <- ggplot(data=bakgr[bakgr$Kod == input$category,], aes(x=År, y=value))
    p <- p + layer(geom=input$graftyp)
    #    p <- p + layer(geom="point")
    
#     if (input$smooth) {
#       p <- p + geom_smooth(method="lm")
#     }
    
    ## Theming
    #p <- p + ggtitle(paste("Diagramtyp:", input$graftyp, sep=" ")) + scale_x_continuous(limits=c(2000, 2011))
    
    print(p)
    
    #     hist(faithful$eruptions,
    #          probability = TRUE,
    #          breaks = as.numeric(input$n_breaks),
    #          xlab = "Duration (minutes)",
    #          main = "Geyser eruption duration")
    #     
    #     if (input$individual_obs) {
    #       rug(faithful$eruptions)
    #     }
    #     
    #     if (input$density) {
    #       dens <- density(faithful$eruptions,
    #                       adjust = input$bw_adjust)
    #       lines(dens, col = "blue")
    #     }
    
  })
})