##### CREATE DB FROM KOLADA INDATA #####
system("python import_xls.py")


##### DEV SPACE #####
datafiles <- listKLIndata()

addToKlDB(datafiles)

a <- loadKLData(title="N00800.xls")


filename <- paste(getwd(),"/scraper/out,", sep="")

wb <- loadWorkbook(filename)
df <- readWorksheet(filename)


mdcdb <- put_db(df=Metadata.corr,path="./db/",lookup=T)

test <- get_v(name="Kortnamn", path="./db/")
testdb <- get_db("./db")
test
testdb