library(coldbir)

mdcdb <- put_db(df=Metadata.corr,path="./db/",lookup=T)

test <- get_v(name="Kortnamn", path="./db/")
testdb <- get_db("./db")
test
testdb