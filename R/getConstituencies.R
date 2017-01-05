#' getConstituencies
#'
#' Fetch a list of UK Parliament constituencies. Note: only one argument can be given at present.
#'
#' @param date Fetch the list of constituencies as on this date.
#' @param string Fetch the list of constituencies that match this search string.
#'
#' @return character vector of constituencies
#'
#' @examples
#' getConstituencies()
#'
#' @export
getConstituencies <- function(date = NA, string = NA){

  check_api_key()

  data <- get_generic("getConstituencies", search_date = date, search_string = string)

  out <- xml_text(xml_children(data))

  return(out)
}
