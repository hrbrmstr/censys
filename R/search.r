#' Perform queries against Censys data
#'
#' The search endpoint allows searches against the current Censys data in the
#' IPv4, Top Million Websites, and Certificates indexes using the same search
#' syntax as the primary site. The endpoint returns a paginated result set of
#' hosts (or websites or certificates) that match the search.
#'
#' @param index The search index to be queried. Must be one of either
#'        \code{ipv4}, \code{websites}, or \code{certificates}.
#' @param query The query to be executed. For example,
#'        \code{80.http.get.headers.server: nginx}.
#' @param page The page of the result set to be returned. The number of pages in
#'        the result set is available under metadata in any request. By default,
#'        the API will return the first page of results. "\code{1}" indexed.
#' @param fields (optional) character vector of fields you would like returned in
#'        the result set in "dot notation", e.g. \code{location.country_code}.
#' @return list of information about the endpoint
#' @references Censys search syntax: \url{https://www.censys.io/ipv4/help};
#'             API doc: \url{https://www.censys.io/api/v1/docs/search}
#' @export
#' @examples \dontrun{
#' censys_search("ipv4", "80.http.get.headers.server: Apache", 2,
#'               c("ip", "location.country", "autonomous_system.asn"))
#' }
censys_search <- function(index, query, page=1, fields=NULL) {

  result <- POST(CENSYS_API_URL %s+% "search/" %s+% index,
                 body=list(query=query,
                            page=page,
                            fields=fields),
                 encode="json",
                 check_api())

  stop_for_status(result)

  srs <- fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_srch_res", class(srs))

  srs

}
