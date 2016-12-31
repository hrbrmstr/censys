#' Retrieve data on the types of scans Censys regularly performs ("series").
#'
#' You must have both \code{CENSYS_API_ID} and \code{CENSYS_API_SECRET} present in the
#' R environment for the functions in this package to work. It is highly suggested that
#' you place those in \code{~/.Renviron} at least for interactive work.
#'
#' @return list of series metadata
#' @note Censys ID & Secret must be in the R environment
#' @export
#' @references Census API: \url{https://www.censys.io/api/v1/docs/data}
#' @examples \dontrun{
#' scans <- get_series()
#' names(scans$raw_series)
#' names(scans$primary_series)
#' }
get_series <- function() {

  result <- httr::GET(CENSYS_API_URL %s+% "data", check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_srs", class(srs))

  srs

}


#' Retrieve data that Censys has about a particular series
#'
#' A "series" is a scan of the same protocol and destination accross time,
#' including the list of scans.
#'
#' You must have both \code{CENSYS_API_ID} and \code{CENSYS_API_SECRET} present in the
#' R environment for the functions in this package to work. It is highly suggested that
#' you place those in \code{~/.Renviron} at least for interactive work.
#'
#' @param series_id Censys series id (e.g. \code{"22-ssh-banner-full_ipv4"})
#' @return list of specific series details
#' @export
#' @references Census API: \url{https://www.censys.io/api/v1/docs/data}
#' @examples \dontrun{
#' view_series("443-https-tls-full_ipv4")
#' }
view_series <- function(series_id) {

  result <- httr::GET(CENSYS_API_URL %s+% "data/" %s+% series_id, check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_srs_info", class(srs))

  srs

}

#' Retrieve data on a particular scan "result"
#'
#' Generally used after a call to either \code{get_series} or \code{view_series}.
#'
#' You must have both \code{CENSYS_API_ID} and \code{CENSYS_API_SECRET} present in the
#' R environment for the functions in this package to work. It is highly suggested that
#' you place those in \code{~/.Renviron} at least for interactive work.
#'
#' @param series_id Censys series id (e.g. \code{"22-ssh-banner-full_ipv4"})
#' @param result_id Censys series result id (e.g. \code{"20150930T0056"})
#' @return list of specific series result details
#' @export
#' @references Census API: \url{https://www.censys.io/api/v1/docs/data}
view_result <- function(series_id, result_id) {

  result <- httr::GET(CENSYS_API_URL %s+% "data/" %s+% series_id %s+% "/" %s+% result_id,
                check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_srs_res", class(srs))

  srs

}
