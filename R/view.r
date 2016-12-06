#' Retrieve data that Censys has about a specific host, website, or certificate.
#'
#' @param index The search index the document is in. Must be one of either
#'        \code{ipv4}, \code{websites}, or \code{certificates}.
#' @param id The ID of the document you are requesting. In the \code{ipv4} index,
#'        this is IP address (e.g., \code{192.168.1.1}), domain name in the
#'        \code{websites} index (e.g., \code{google.com}) and SHA-256 fingerprint
#'        in the \code{certificates} index (e.g.,
#'        \code{9d3b51a6b80daf76e074730f19dc01e643ca0c3127d8f48be64cf3302f6622cc}).
#' @return list of information about the endpoint
#' @export
#' @examples \dontrun{
#' view_document("google.com")
#' }
view_document <- function(index, id) {

  result <- httr::GET(CENSYS_API_URL %s+% "view/" %s+% index %s+% "/" %s+% id, check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_view_doc", class(srs))

  srs

}
