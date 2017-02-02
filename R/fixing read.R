# library(xml2)
# 
# read_xml(paste0(readLines("https://gist.githubusercontent.com/jblumenau/6e460a982a7779e0ec239ce743d21a0c/raw/81dc529c18ee2a43d17790244d90415c1a16a84d/noerror.xml"),collapse = " "))
# 
# error <- paste0(readLines("https://gist.githubusercontent.com/jblumenau/6e460a982a7779e0ec239ce743d21a0c/raw/fb4e543904b0c6b278b5cbdffb9559783169f476/error.xml"),collapse = " ")
# error<- gsub("\027","",error)
# read_xml(error)
# 
# 10651
# 
# noerror <- read_xml("https://gist.githubusercontent.com/jblumenau/6e460a982a7779e0ec239ce743d21a0c/raw/81dc529c18ee2a43d17790244d90415c1a16a84d/noerror.xml")
# 
# error <- read_xml("https://gist.githubusercontent.com/jblumenau/6e460a982a7779e0ec239ce743d21a0c/raw/fb4e543904b0c6b278b5cbdffb9559783169f476/error.xml")
