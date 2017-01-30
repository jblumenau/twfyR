#' getBoundary
#'
#' Returns KML file for a UK Parliament constituency.
#'
#' Returns the bounding polygon of the constituency, in KML format (see mapit.mysociety.org for other formats, past constituency boundaries, and so on).
#'
#' @param name Name of the constituency.
#' @param plot_boundary Produce a (very) rudimentary plot of the constituency boundary.
#'
#' @return A SpatialPolygonsDataFrame from rgdal::readOGR
#'
#' @examples
#' getBoundary("Hornsey and Wood Green", plot_boundary = T)
#'
#' @export
getBoundary <- function(name = NA, plot_boundary = F){
  
  check_api_key()
  
  library(rgdal)
  
  file_url <- get_generic("getBoundary", search_name = name, return_url = T)
  
  # create a temporary directory
  td <- tempdir()
  
  # create the placeholder file
  tf <- tempfile(tmpdir=td, fileext=".kml")
  
  # download into the placeholder file
  download.file(file_url, tf, quiet = T)
  
  cons_sp <- readOGR(tf, layer = "Layer #0")
  
  if(plot_boundary){
    tmp_plot <- ggplot() + geom_polygon(data=cons_sp, aes(x=long, y=lat) , color="grey", size=0.2)
    print(tmp_plot)
  }
  
  unlink(tf)
  
  return(cons_sp)
}