output$frontpage <- renderText((
#   source(paste("./static_html/", input$frontpage_text, sep=""))
  #     x <- as.character(input$frontpage_text)
  #     print(x)
  x <- paste("./static_html/", input$frontpage_text, sep="")
  as.character(x)
))