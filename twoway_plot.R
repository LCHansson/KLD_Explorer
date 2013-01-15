output$twoway_plot <- reactivePlot(function() {  
  # Copy dimensional DF
  gg_df <- dim_df
  
  xvar <- cdb$get_v(input$category)
  yvar <- cdb$get_v(input$categ2)
  
  gg_df$var1 <- xvar
  gg_df$var2 <- yvar
  
  xname <- input$category
  yname <- input$categ2
  names(gg_df) <- c("Kommun", "År", xname, yname)
  
  q <- ggplot(data=gg_df, aes_string(x=xname, y=yname, color="Kommun"))
  q <- q + layer(geom="point", subset=.(År == input$year))
  q <- q + layer(geom="abline", aes(intercept=0, slope=1, linetype=2))
  q <- q + labs(
    x=xname,
    #       x=Metadata[Metadata$Kod == input$category, "Kortnamn"],
    y=Metadata[Metadata$Kod == input$categ2, "Kortnamn"]
  )
  
  if(input$percentgraph) {
    q <- q + xlim(0,100) + ylim(0,100)
  }
  
  if(input$smooth) {
    q <- q + geom_smooth(method=ifelse(input$loess, "loess", "lm"), subset=.(År == input$year))
  }
  
  print(q)
})