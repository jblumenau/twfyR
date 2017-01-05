#' getMPs
#'
#' Fetch a particular MP.
#'
#' @param postcode Fetch the MP for a particular postcode (either the current one, or the most recent one, depending upon the setting of the always_return variable). This will only return their current/ most recent entry in the database, look up by ID to get full history of a person. (optional)
#' @param constituency The name of a constituency; we will try and work it out from whatever you give us. This will only return their current/ most recent entry in the database, look up by ID to get full history of a person. (optional)
#' @param id If you know the person ID for the member you want (returned from getMPs or elsewhere), this will return data for that person. This will return all database entries for this person, so will include previous elections, party changes, etc. (optional)
#' @param always_return For the postcode and constituency options, sets whether to always try and return an MP, even if the seat is currently vacant (due to e.g. the death of an MP, or the period before an election when there are no MPs).
#'
#' @return list of MPs and offices
#'
#' @examples
#' getMPs()
#'
#' @export
getMP <- function(postcode = NA, constituency = NA, id = NA, always_return = NA){

  check_api_key()

  # postcode <- "SG75NS"
# constituency = NA
# id = NA
# always_return = NA
  data <- get_generic("getMP", search_postcode = postcode, search_constituency = constituency, search_id = id, search_always_return = always_return)

  getMP_details <- function(x){
    vars <- xml_name(xml_children(x))
    vars <- vars[vars != "office"]
    vals <- xml_text(xml_find_all(x, paste0(vars, collapse = "|")))
    vals <- data.frame(t(vals))
    names(vals) <- vars
    return(vals)
  }

  getMP_office <- function(x){
    if(is.na(xml_text(xml_child(x, "office")))) return(NULL)
    office <- xml_child(xml_child(x, "office"))
    office_vars <- xml_name(xml_children(office))
    office_vals <- xml_text(xml_find_all(office, paste0(office_vars, collapse = "|")))
    office_vals <- data.frame(t(office_vals))
    names(office_vals) <- office_vars

    return(office_vals)
  }


  if(length(xml_text(xml_find_all(data, "match")))==0){

      mp_details <- getMP_details(data)
      mp_office <- getMP_office(data)

  }else{
    mp_details <- rbind.fill(lapply(xml_children(data), function(x) getMP_details(x)))
    mp_office <- rbind.fill(lapply(xml_children(data), function(x) getMP_office(x)))

  }

  out <- list(member = mp_details, office = mp_office)

  return(out)
}


#getMP(id = 10131)
#tmp <- getMPs()
#tmp$members[grep("Cooper",tmp$members$name),]
