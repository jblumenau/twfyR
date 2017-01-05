#' getPerson
#'
#' Fetch a particular person.
#'
#' @param id If you know the person ID for the member you want (returned from getMPs or elsewhere), this will return data for that person. This will return all database entries for this person, so will include previous elections, party changes, etc.
#'
#' @return list of 2 elements. The first element is a data.frame named `member` which includes information of the person's house memberships. The second is a data.frame named `office` which details the offices that member has held.
#'
#' @examples
#' getPerson(10001)
#'
#' @export
getPerson <- function(id_person = NA){

  check_api_key()
  
  if(is.na(id_person)) stop("No id provided.")

  mp_data <- get_generic(call = "getPerson", search_id = id_person)
  mp_children <- xml_children(mp_data)

  member_id <- xml_child_search(mp_children, "member_id")
  house <- xml_child_search(mp_children, "house")
  constituency <- xml_child_search(mp_children, "constituency")
  party <- xml_child_search(mp_children, "party")
  entered_house <- xml_child_search(mp_children, "entered_house")
  left_house <- xml_child_search(mp_children, "left_house")
  entered_reason <- xml_child_search(mp_children, "entered_reason")
  left_reason <- xml_child_search(mp_children, "left_reason")
  person_id <- xml_child_search(mp_children, "person_id")
  lastupdate <- xml_child_search(mp_children, "lastupdate")
  title <- xml_child_search(mp_children, "title")
  given_name <- xml_child_search(mp_children, "given_name")
  family_name <- xml_child_search(mp_children, "family_name")
  full_name <- xml_child_search(mp_children, "full_name")
  url <- xml_child_search(mp_children, "url")

  member <- data.frame(member_id, house, constituency, party, entered_house, left_house, left_reason, person_id, lastupdate, title, given_name, family_name, full_name, url, stringsAsFactors = F)

  office_id <- xml_text_search("./office//moffice_id", mp_data)
  department <- xml_text_search("./office//dept", mp_data)
  position <- xml_text_search("./office//position", mp_data)
  from_date <- xml_text_search("./office//from_date", mp_data)
  to_date <- xml_text_search("./office//to_date", mp_data)
  person_id <- xml_text_search("./office//person", mp_data)
  source <- xml_text_search("./office//source", mp_data)

  office <- data.frame(office_id, department, position, from_date, to_date, person_id, source, stringsAsFactors = F)

  member$entered_house <- convert_dates(member$entered_house)
  member$left_house <- convert_dates(member$left_house)
  member$lastupdate <- convert_dates(member$lastupdate)
  office$from_date <- convert_dates(office$from_date)
  office$to_date <- convert_dates(office$to_date)

  out <- list(member = member, office = office)

  return(out)

}
