#' getMPsinfo
#'
#' Fetch extra information for a particular person.
#'
#' @param id The person IDs (vector of integers).
#' @param fields Which fields you want to return as a comma separated character string (defaults to all).
#'
#' @return list of data.frames of MPs' extra information (see TheyWorkForYou for details)
#'
#' @examples
#' getMPs()
#'
#' @export

#id <- c(24709,10131)
#fields <- "public_whip_dreammp6707_absent,public_whip_dreammp6708_both_voted"
#fields <- NA

getMPsinfo <- function(id = NA, fields = NA){

  check_api_key()

  id_tmp <- paste0(id, collapse = ",")
  data <- get_generic("getMPsinfo", search_id = id_tmp, search_fields = fields)

  members <- xml_find_all(data, "//twfy/match")

  tmp_func <- function(x){
    x <- xml_children(x)
    x_names <- xml_name(x)
    x_vals <- xml_text(x)

    remove_obs <- ifelse(x_vals[x_names=="id"] == "0", T, F)

    if(remove_obs) {
      tmp_out <- NULL
      }else{
      tmp_out <- data.frame(vars = x_names, vals = x_vals)
      tmp_out <- tmp_out[tmp_out$vars!="id",]
    }

    return(tmp_out)
  }

  out <- lapply(members, tmp_func)
  out <- out[!unlist(lapply(out, is.null))]

  names(out) <- id
  return(out)

}

# test <- getMPs()
# test2 <-  getMPsinfo(id = c(24709,10131, 11771, 10069))
