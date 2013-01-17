##### CREATE DB FROM KOLADA INDATA #####
# Note: uses Coldbir v0.1. Coldbir syntax WILL change in later releases!
system("python import_xls.py")

system("rm -r ./db/metadata ./db/wide")

mdcdb <- coldbir:::put_variable(Metadata, path="./db/metadata/", lookup=T)
cdb <- coldbir:::put_variable(wide_var, path="./db/wide/", lookup=T)
