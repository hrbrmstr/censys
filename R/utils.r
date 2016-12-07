CENSYS_API_URL <- "https://www.censys.io/api/v1/"

check_api <- function() {

  id <- Sys.getenv("CENSYS_API_ID")
  secret <- Sys.getenv("CENSYS_API_SECRET")

  if (id == "" | secret == "") {
    stop("Both CENSYS_API_ID and CENSYS_API_SECRET must be present in the R environment.")
  }

  return(httr::authenticate(id, secret))

}
