
output$startpage <- reactiveText(function() {
  y <- source("0-startpage.R")
  as.character(y)
})