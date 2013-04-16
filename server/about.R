output$about <- reactiveText(function() {
    x <- "Test! <strong>STRONG!</strong>"
    
    as.character(x)
})