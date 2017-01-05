#' get_generic
#'
#' Generic function to build a TheyWorkForYou url and call in the XML data. For internal use in twfyR only. I wouldn't bother using this directly.
#'
#' @param call Which api command do you want to call?
#' @param search_party Party paramenter
#' @param search_date Date paramenter
#' @param search_name Name paramenter
#' @param search_postcode Postcode paramenter
#' @param search_string String paramenter
#' @param search_id ID paramenter
#' @param search_constituency Constituency paramenter
#' @param search_always_return Always return paramenter
#' @param search_fields Fields paramenter
#' @param search_gid GID paramenter
#' @param search_order order paramenter
#' @param search_page page paramenter
#' @param search_num num paramenter
#' @param search_person person parameter
#' @param search_type type parameter
#'
#' @return XML data returned from TheyWorkForYou.
#'
#' @export

get_generic <- function(call = "getMPs", search_date = NA, search_name = NA, search_postcode = NA, search_party = NA, search_string = NA, search_id = NA, search_constituency = NA, search_always_return = NA, search_fields = NA, search_gid = NA, search_order = NA, search_page = NA, search_num = NA, search_type = NA, search_person = NA, return_url = F){

  args <- data.frame(date = search_date, name = search_name,
                     postcode = search_postcode, party = search_party,
                     search = search_string, id = search_id, constituency = search_constituency,
                     always_return = search_always_return, fields = search_fields,
                     gid = search_gid, order = search_order, page = search_page, num = search_num,
                     type = search_type, person = search_person,
                     stringsAsFactors = F)
  args_uri <- paste0(names(args),"=",args)
  args_uri <- args_uri[!is.na(args[1,])]

  base_uri <- "https://www.theyworkforyou.com/api/"

  # Add the call
  uri_call <- paste0(base_uri, paste0(call, "&output=xml"))

  # Add the arguments

  uri_call <- paste0(uri_call, "&", paste0(args_uri, collapse = "&"))

  # Add the key

  uri_call <- paste0(uri_call, "&key=", api_key)
  last_api_call <<- uri_call
  data <- xml2::read_xml(uri_call)

  if(return_url){
    return(uri_call)
  }else{
    return(data)
  }

}

