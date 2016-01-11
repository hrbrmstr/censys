#' Create aggregate reports on the breakdown of a field in the result set of a query
#'
#' The build report endpoint lets you run aggregate reports on the breakdown of
#' a field in a result set analogous to the "Build Report" functionality in the
#' front end. For example, if you wanted to determine the breakdown of cipher
#' suites selected by Top Million Websites.
#'
#' @param index The search index to be queried. Must be one of either
#'        \code{ipv4}, \code{websites}, or \code{certificates}.
#' @param query The query to be executed. For example,
#'        \code{80.http.get.headers.server: nginx}.
#' @param field The field you are running a breakdown on in "dot notation",
#'        e.g. \code{location.country_code}.
#' @param buckets (optional) The maximum number of values to be returned in the
#'        report. Maximum: \code{500}. Default: \code{50}.
#' @return list of information about the endpoint
#' @references Censys search syntax: \url{https://www.censys.io/ipv4/help};
#'             API doc: \url{https://www.censys.io/api/v1/docs/report}
#' @export
#' @examples \dontrun{
#' censys_report("ipv4", "80.http.get.headers.server: Apache",
#'               "location.country", 100)
#' }
censys_report<- function(index, query, field, buckets=50) {

  result <- POST(CENSYS_API_URL %s+% "report/" %s+% index,
                 body=list(query=query,
                            field=field,
                            buckets=buckets),
                 encode="json",
                 check_api())

  stop_for_status(result)

  srs <- fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_rpt_res", class(srs))

  srs

}
