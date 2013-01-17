##### DEV SPACE #####
datafiles <- listKLIndata()

addToKlDB(datafiles)

a <- loadKLData(title="N00800.xls")


filename <- paste(getwd(),"/scraper/out,", sep="")

wb <- loadWorkbook(filename)
df <- readWorksheet(filename)

wide_data$get_v('Kommun')

test <- get_v(name="Kortnamn", path="./db/")
testdb <- get_db("./db")
test
testdb



cdb <- coldbir:::db$new('./db/cdb')

cdb$put_v(wide_var)

system.time(
  test <- cdb$get_v("N00800")
)