#' set_twfy_key
#'
#' Sets the value of the TheyWorkForYou API key to be used with all other twfyR functions.
#'
#' @param key users TheyWorkForYou API key
#'
#' @return None
#'
#' @examples
#' set_twfy_key()
#'
#' @export
set_twfy_key <- function(key, testing = T){
  if(testing){
    api_key <<- "C7uqpUDw3nH7BVfxNcAK4T8U"
  }else{
    api_key <<- key
  }
  message("Api key set.")
}
