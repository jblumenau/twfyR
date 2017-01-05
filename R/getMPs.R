#' getMPs
#'
#' Fetch a list of MPs.
#'
#' @param date Fetch the list of MPs as it was on this date. (optional)
#' @param party Fetch the list of MPs from the given party. (optional)
#' @param string Fetch the list of MPs that match this search string in their name. (optional)
#'
#' @return list of MPs and offices
#'
#' @examples
#' getMPs()
#'
#' @export
getMPs <- function(date = NA, string = NA, party = NA){

  check_api_key()

  data <- get_generic("getMPs", search_date = date, search_string = string, search_party = party)
  
  if(length(xml_children(data)) == 0) {
    warning("No data found for these parameter values.")
    members <- NA
    memberships <- NA
    return(list(members = members, office = memberships))
  }
  
  member_ids <- xml_text(xml_find_all(xml_children(data),"member_id"))
  person_ids <- xml_text(xml_find_all(xml_children(data),"person_id"))
  mp_names <- xml_text(xml_find_all(xml_children(data),"name"))
  parties <- xml_text(xml_find_all(xml_children(data),"party"))
  constituencies <- xml_text(xml_find_all(xml_children(data),"constituency"))

  members <- data.frame(member_id = member_ids, person_id = person_ids,
                        name = mp_names, party = parties, constituency = constituencies)

  departments <- lapply(xml_children(data), function(x) xml_text(xml_find_all(x, "./office//dept")))
  positions <- lapply(xml_children(data), function(x) xml_text(xml_find_all(x, "./office//position")))
  from_dates <- lapply(xml_children(data), function(x) xml_text(xml_find_all(x, "./office//from_date")))
  to_dates <- lapply(xml_children(data), function(x) xml_text(xml_find_all(x, "./office//to_date")))
  departments[unlist(lapply(departments, length))==0] <- NA
  positions[unlist(lapply(positions, length))==0] <- NA
  from_dates[unlist(lapply(from_dates, length))==0] <- NA
  to_dates[unlist(lapply(to_dates, length))==0] <- NA

  memberships <- lapply(1:length(positions), function(x) data.frame(members[x,], position = positions[[x]], department = departments[[x]], from_date = from_dates[[x]], to_date = to_dates[[x]]))

  memberships <- do.call("rbind", memberships)

  memberships$from_date <- convert_dates(memberships$from_date)
  memberships$to_date <- convert_dates(memberships$to_date)

  out <- list(members = members, office = memberships)

  return(out)
}
