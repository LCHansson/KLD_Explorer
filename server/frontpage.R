output$frontpage <- reactiveText(function() {
  source(paste("./text_pages/", input$frontpage_text, sep=""))
  #     x <- as.character(input$frontpage_text)
  #     print(x)
  as.character(x)
})