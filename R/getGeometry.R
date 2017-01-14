#' getGeometry
#'
#' Returns geometry information for constituencies.
#'
#' This currently includes, for Great Britain, the latitude and longitude of the centre point of the bounding box of the constituency, its area in square metres, the bounding box itself and the number of parts in the polygon that makes up the constituency. For Northern Ireland, as we don't have any better data, it only returns an approximate (estimated by eye) latitude and longitude for the constituency's centroid.
#'
#' @param name Name of the constituency.
#'
#' @return data.frame of constituency information.
#'
#' @examples
#' constituency_names <- getConstituencies()
#' getGeometry(constituency_names[1])
#'
#' @export
getGeometry <- function(name = NA){
  
  check_api_key()
  
  data <- get_generic("getGeometry", search_name = name)
  
  out <- data.frame(t(xml_text(xml_children(data))))
  names(out) <- xml_name(xml_children(data))

  return(out)
}

