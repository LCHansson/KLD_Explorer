# Include init file
source("./1-init.R")

# Create dimensional data frame
commune <- cdb$get_v("Kommun")
year <- cdb$get_v("År")
dim_df <- data.frame(Kommun=commune, År=year)

shinyServer(function(input, output) {
  
  output$caption <- reactiveText(function() {
    "KLD Explorer 1.0 (technology preview)"
  })
  
  output$startpage <- reactiveText(function() {
      y <- source("0-startpage.R")
      as.character(y)
  })
  
  output$main_plot <- reactivePlot(function() {    
    p <- ggplot(data=KLData, aes(x=År, y=Värde, group=1, xmin=min(allyears), xmax=max(allyears)))
    #   p <- p + layer(geom=input$graftyp, subset = .(Variabelkod == input$category & Kommun == input$kommun))
    p <- p + layer(
      geom=input$graftyp, 
      subset=.(Variabelkod == input$category & Kommun == unique(KLData$Kommun)[input$kommunNr]),
      #     	title=KLData$Kommun[input$kommunNr]
      title="Test"
    )
    
    #    p <- p + ylim(0,100)
    
    # Kod för utvärdering av två variabler med samma y-limits
    if(input$tvavar) {
      p <- p + layer(geom=input$graftyp, subset=.(Variabelkod == input$categ2 & Kommun == unique(KLData$Kommun)[input$kommunNr]), aes(color="red", fill="red"))
      
      if (input$smooth) {
        #       	p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$categ2 & Kommun == input$kommun), aes(group=1))
        p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$categ2 & Kommun == unique(KLData$Kommun)[input$kommunNr]), aes(group=1,color="red"))
      }
    }
    
    if (input$smooth) {
      p <- p + geom_smooth(method=ifelse(input$loess == TRUE, "loess", "lm"), subset = .(Variabelkod == input$category & Kommun == unique(KLData$Kommun)[input$kommunNr]), aes(group=1))
    }
    
    p <- p + ggtitle(unique(KLData$Kommun)[input$kommunNr])
    
    print(p)
    print(paste("Kommun:", input$kommunNr, unique(KLData$Kommun)[input$kommunNr]))
  })
  
  
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
    q <- q + xlim(0,100) + ylim(0,100) + theme(legend.position = "right")
    
    print(q)
  })
  
  
  output$sessioninfo <- reactiveText(function() {
    print(input$graftyp)
    print(input$category)
    print(input$smooth)
    print(paste("Var1: ",input$category, ", var2: ", input$categ2))
    print(KLData[KLData$Variabelkod == input$category,][1][[1]][[1]])
    print(paste("Working directory:", getwd()))
  })
})
