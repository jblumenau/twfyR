#' getDebates
#'
#' Fetch a list of MPs.
#'
#' @param type One of "commons", "westminsterhall", "lords", "scotland", or "northernireland". (required)
#' @param date Fetch the debates for this date. (Currently not working!!)
#' @param search Fetch the debates that contain this term.
#' @param person Fetch the debates by a particular person ID.
#' @param gid Fetch the speech or debate that matches this GID.
#' @param order (optional, when using search or person) "d" for date ordering, "r" for relevance ordering.
#' @param page (optional, when using search or person) Page of results to return.
#' @param num (optional, when using search or person) Number of results to return (maximum and default is 1000).
#' @param complete_call The twfy API will only seemingly return 1000 results per call. Setting this parameter to TRUE will iterate over the page parameter until all results are collected. Warning: this is a quick way to use up your API call allowance.
#'
#' @return data.frame of debates
#'
#' @examples
#' getDebates()
#'
#' @export
getDebates <- function(type = NA, date = NA, search = NA, person = NA, gid = NA, order = NA, page = NA, num = 1000, complete_call = F){
  # func_args_global(getDebates)
  # type = "commons"
  # person = 10001
  # num = 1000
  # complete_call = T

  check_api_key()

  if(is.na(type)) stop("'type' parameter cannot be missing. Must be one of 'commons', 'westminsterhall', 'lords', or 'northernireland'.")
  if(!is.na(date)) stop("'Date' paramenter is currently not working.")
  if(sum(!is.na(c(date,search,person, gid))) > 1) stop("You can only supply one of 'date', 'search', 'person', or 'gid' at present. See https://www.theyworkforyou.com/api/docs/getDebates for more information.")

  if(!is.na(person)) initial_root <- "rows/match"
  if(!is.na(date)) initial_root <- "match/entry"
  if(!is.na(search)) initial_root <- "rows/match"
  if(!is.na(gid)) initial_root <- "rows/match"

  xpath_search <- c("gid","hdate","htime", "section_id", "subsection_id", "htype", "major", "minor",
                    "person_id", "hpos", "video_status", "epobject_id", "body", "collapsed", "relevance", "extract", "listurl",
                    "speaker/member_id", "speaker/name", "speaker/house", "speaker/constituency", "speaker/party", "speaker/url",
                    "speaker/office/match/dept", "speaker/office/match/position", "speaker/office/match/source", "speaker/office/match/pretty")

  date <- convert_dates_r_to_twfy(date)

  xml_data <- try(get_generic("getDebates", search_type = type,
                      search_date = date, search_string = search,
                      search_person = person, search_gid = gid,
                      search_order = order, search_page = page,
                      search_num = num, return_url = F), silent = T)

  data_page_list <- list()
  data_page_list[[1]] <- xml_data

  if(complete_call){

    if(!"try-error" %in% class(xml_data)) {
      
      total_results <- as.numeric(xml_text(xml_find_all(xml_data,"info/total_results")))
    
    if(total_results == 0) return(NA)
    
    } else{
        total_results <- 3000
      }
    
    pages_to_search <- floor(total_results/1000) + 1
    cat(paste0("Retreiving all the data for your search will require approximately ", pages_to_search," calls to the twfy API.\n"))
    cat(paste0("Call 1 complete.\n"))
    stop_looping <- F
    i <- 1
    while(!stop_looping){
    i <- i + 1

      data_page_list[[i]] <- try(get_generic("getDebates", search_type = type,
                        search_date = date, search_string = search,
                        search_person = person, search_gid = gid,
                        search_order = order, search_page = i,
                        search_num = num, return_url = F), silent = T)
      
      if("try-error" %in% class(data_page_list[[i]])) {
        cat(paste0("Error calling the following url: ", last_api_call,"\n"))
        cat(paste0("Skipping to next call.\n"))
        next
      }
      
      if(length(xml_find_all(data_page_list[[i]], initial_root))==0) stop_looping <- T

      if(!stop_looping) cat(paste0("Call ", i," complete.\n"))

    }


  }

  # Remove any output which inherited a try error
  data_page_list <- data_page_list[!unlist(lapply(data_page_list, function(x) "try-error" %in% class(x)))]
  
  
  out_list <- list()
  for(doc in 1:length(data_page_list)){

    tmp_data <- xml_find_all(data_page_list[[doc]], initial_root)

    tmp_out <- lapply(xpath_search, function(x) {
    # x <- xpath_search[1]
      tmp <- xml_find_first(tmp_data, x)
      var <- as.character(na.omit(unique(xml_name(tmp))))
      val <- xml_text(tmp)
      out <- data.frame(val, stringsAsFactors = F)
      names(out) <- var
      out
    })

  out_list[[doc]] <- data.frame(do.call("cbind", tmp_out), stringsAsFactors = F)

  # Remove variables for which no results were returned
  out_list[[doc]] <- out_list[[doc]][,!grepl("NA",names(out_list[[doc]]))]

  }

  out <- rbind.fill(out_list)

  ## Clean the data a little

  out$hdate <- as.Date(out$hdate)
  out$body <- clean_texts_fun(out$body)
  out$extract <- clean_texts_fun(out$extract)

  return(out)
}

#test <- getDebates(type = "commons", search = "fish", num = 1000, complete_call = T)
#test <- getDebates(type = "commons", person = 10001, num = 1000, complete_call = T)
#str(test)

#getMP(id = 10001)

#test <- getDebates(type = "commons", person = 10168, complete_call = T)
