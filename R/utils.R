#' convert_dates
#'
#' Generic function to convert TWFY dates to R dates
#'
#' @param x Date string to convert
#'
#' @return R date object
#'
#' @export
convert_dates <- function(x){
  x <- gsub("00-00","01-01", x)
  x <- as.character(x)
  x <- as.Date(x)
  x[grep("9999", x)] <- Sys.Date()
  return(x)
}

#' convert_dates_r_to_twfy
#'
#' Generic function to convert R dates to twfy dates
#'
#' @param x R date object to convert
#'
#' @return Character object
#'
#' @export
convert_dates_r_to_twfy <- function(x){
  x <- as.character(x)
  return(x)
}

#' xml_text_search
#'
#' Generic function to find elements in XML
#'
#' @param x XML object
#' @param string xPath expression to find
#'
#' @return character vector
#'
#' @export
xml_text_search <- function(string = "member_id", x){
  xml_children(x) %>% xml_find_all(string) %>% xml_text()
}

#' xml_child_search
#'
#' Generic function to find elements in XML children
#'
#' @param children children of XML object
#' @param string xPath expression to find
#'
#' @return character vector
#'
#' @export
xml_child_search <- function(children, string = "url"){
  tmp <- lapply(children, function(x) xml_text(xml_find_all(x, string)))
  tmp[unlist(lapply(tmp, function(x) length(x)))==0] <- ""
  tmp <- unlist(tmp)
  return(tmp)
}

#' check_api_key
#'
#' Generic function to check that the user has supplied an API key for twfy
#'
#'
#' @return Error message if api_key is absent
#'
#' @export

check_api_key <- function(){

  if(!exists("api_key")) stop("You have not provided a TheyWorkForYou API key. Use set_twfy_key to do so before proceeding.", call. = F, domain = NA)

}

#' clean_texts_fun
#'
#' Generic function to clean up a speech string (remove html elements, etc)
#'
#'
#' @return Clean speech string
#'
#' @export
clean_texts_fun <- function(string) {
  string <- gsub("<.*?>", " ", string)
  string <- gsub("\\[(.)*?\\]"," ", string)
  string <- gsub("<(.)*?>"," ", string)
  string <- gsub("\\[(.)*?\\]"," ", string)
  string <- gsub('&#146;',' ', string,fixed=TRUE)
  string <- gsub('&nbsp;',' ', string,fixed=TRUE)
  string <- gsub('&amp;','&', string,fixed=TRUE)
  string <- gsub('&#145;',' ', string,fixed=TRUE)
  string <- gsub('&#8212;',' ', string,fixed=TRUE)
  string <- gsub('&#8217;',' ', string,fixed=TRUE)
  string <- gsub('&#8221;',' ', string,fixed=TRUE)
  string <- gsub('&#8220;',' ', string,fixed=TRUE)
  string <- gsub('&#8230;',' ', string,fixed=TRUE)
  string <- gsub('&#163;',' ', string,fixed=TRUE)
  string <- gsub('[Interruption. ]',' ', string,fixed=TRUE)
  string <- gsub('[ Interruption. ]',' ', string,fixed=TRUE)
  string <- gsub('[Interruption.]',' ', string,fixed=TRUE)
  string <- gsub('\n',' ', string)
  string <- gsub('\"',' ', string)
  string <- trim(string)
  return(string)
}


#' trim
#'
#' Trim leading and trailing whitespace from a character vector
#'
#'
#' @return Trimmed string
#'
#' @export
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
