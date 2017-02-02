# You are not currently returning the debate title with each speech. Include this going forward.
# 
# library(twfyR)
# api_key <- "C62uGmATvPVNFBG4iRCAikiR"
# set_twfy_key(api_key)
# x <- try(getDebates(type = "commons", person = 10001, complete_call = F), silent = T)
# library(xml2)
# test <- read_xml(last_api_call)
# unique(xml_text(xml_find_all(test, "rows/match/parent/body")))
# 
# 
# ## Also try to figure out how to fix erroneous characters in the source XML: https://github.com/mysociety/theyworkforyou/issues/1198 and https://github.com/hadley/xml2/issues/165