#' Issue SQL Queries against the Censys API
#'
#' The Query API allows executing SQL queries against our daily snapshots and raw data
#' analogous to the Query web interface. Queries are executed asynchronously. You must
#' first start a job, then check its status. Once a job has completed, you can view
#' paginated results using the get results endpoint. Jobs typically require 15-30
#' seconds to execute; results can be viewed for 24 hours after the job completed.
#' Ddefinition endpoints are also exposed where you can list the series and view series
#' details (i.e., list tables and schema).
#'
#' @param query SQL query string
#' @references Censys SQL query syntax: \url{https://censys.io/query};
#'             API doc: \url{https://www.censys.io/api/v1/docs/search}
#' @export
#' @return API call result (invisibly)
#' @examples \dontrun{
#' }
censys_query <- function(sql) {

  result <- httr::POST(CENSYS_API_URL %s+% "query",
                       body=list(query=sql),
                       encode="json",
                       check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_query_res", class(srs))

  message(sprintf("Query: %s\nStatus: %s\nJob Id: %s",
                  srs$configuration$query, srs$status, srs$job_id))

  invisible(srs)

}


#' Get status of a Censys SQL query job
#'
#' The Get Job Status endpoint allows you to determine whether a job has completed. Once
#' it has successfully finished, you can then retrieved results with the Get Results
#' endpoint. Data should be posted as a JSON request document.
#'
#' @param job_id Censys job id (from calling \code{censys_query()})
#' @references Censys SQL query syntax: \url{https://censys.io/query};
#'             API doc: \url{https://www.censys.io/api/v1/docs/search}
#' @return API call result (invisibly)
#' @export
censys_get_job_status <- function(job_id) {

  result <- httr::GET(CENSYS_API_URL %s+% "query/" %s+% job_id,
                      check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_job_status", class(srs))

  message(sprintf("Query: %s\nStatus: %s\nJob Id: %s",
                  srs$configuration$query, srs$status, srs$job_id))

  invisible(srs)

}

#' Get results of completed Censys SQL query job
#'
#' The Get Results endpoint allows you to retrieve results of a query after it has
#' completed successfully.
#'
#' @param job_id Censys job id (from calling \code{censys_query()})
#' @param page page number of paged results
#' @references Censys SQL query syntax: \url{https://censys.io/query};
#'             API doc: \url{https://www.censys.io/api/v1/docs/search}
#' @export
censys_get_job_result <- function(job_id, page=1) {

  result <- httr::GET(CENSYS_API_URL %s+% "query/" %s+% job_id %s+% "/" %s+% page,
                      check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_job_results", class(srs))

  srs

}

#' @export
censys_series <- function() {

  result <- httr::GET(CENSYS_API_URL %s+% "query_definitions",
                      check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_series", class(srs))

  srs

}

#' @export
censys_series_details <- function(series="ipv4") {

  result <- httr::GET(CENSYS_API_URL %s+% "query_definitions/" %s+% series,
                      check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_series_details", class(srs))

  srs

}
