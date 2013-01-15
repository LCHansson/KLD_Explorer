commune2 <- cdb$get_v("Kommun")
year2 <- cdb$get_v("År")

grund_df <- data.frame(Kommun=commune2, År=year2)


# TEST 1
getData <- function() {
  for(colname in u$res){
    commune <- cdb$get_v("Kommun")
    year <- cdb$get_v("År")
    xvar <- cdb$get_v(colname)
    yvar <- cdb$get_v(colname)
    df <- data.frame(commune, year, xvar, yvar)
  }
}

system.time(getData())

# TEST 2
getData2 <- function() {
  for(colname in u$res){
    
    xvar <- cdb$get_v(colname)
    yvar <- cdb$get_v(colname)
    
    df <- grund_df
    df$v1 <- xvar
    df$v2 <- yvar
  }
}


system.time(getData2())