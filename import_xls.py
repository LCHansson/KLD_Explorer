#encoding:UTF-8
import xlrd
import glob 
import re
import csv 

with open("./db/nyckeltal.csv", 'wb') as outfile:
    writer = csv.writer(outfile)
    writer.writerow(["Variabelkod","Kommun","År","Värde"])
    for f in glob.glob("./indata/*.xls"):
        varname = re.match(r".*/([^/]*)\.xls",f).groups(1)[0]
        sheet = xlrd.open_workbook(f).sheets()[0]
        for row_index in range(1,sheet.nrows):
            writer.writerow([varname] + [unicode.encode(unicode(c.value), "utf-8") for c in sheet.row(row_index)[1:]])
