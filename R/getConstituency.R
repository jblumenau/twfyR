#' getConstituency
#'
#' Fetch a UK Parliament constituency.
#'
#' @param postcode Fetch the constituency with associated information for a given postcode.
#' @param name Fetch the data associated to the constituency with this name.
#'
#' @return data.frame of constituency info
#'
#' @examples
#' getConstituency()
#'
#' @export
getConstituency <- function(postcode = NA, name = NA){

  check_api_key()

  data <- get_generic("getConstituency", search_postcode = postcode, search_name = name)
  out <- data.frame(t(xml_text(xml_children(data))))
  names(out) <- xml_name(xml_children(data))
  return(out)
}
