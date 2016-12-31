#' Export large datasets and structured records from Censys to JSON or CSV files
#'
#' The Export API allows exporting large datasets and structured records from Censys to
#' JSON or CSV files. Unlike the query endpoint, there are no limits on the type or amount
#' of data returned.
#'
#' Exports are executed as asynchronous jobs. You must first start a job. If the query is
#' parsed successfully, the call will return a job ID, which is used in subsequent calls
#' to get job. Once a job executes successfully, the get job endpoint will provide a list
#' of 128MB JSON files that are available for download for 24 hours. Jobs typically
#' require 15-30 seconds to execute.
#'
#' You must have both \code{CENSYS_API_ID} and \code{CENSYS_API_SECRET} present in the
#' R environment for the functions in this package to work. It is highly suggested that
#' you place those in \code{~/.Renviron} at least for interactive work.
#'
#' @param query the SQL query to be executed
#' @param format the format data should be output in. Must be \code{csv} or \code{json}.
#'               Default: \code{csv}.
#' @param flatten should nested and repeated fields in the query results be flattened. Default: \code{true}.
#' @param compress should data files be gzipped. Default: \code{false}.
#' @param delimiter delimiter to use between fields in the exported data. Default: \code{","}.
#' @param headers should a header row be included in results files. Default: \code{true}.
#' @references Censys SQL query syntax: \url{https://censys.io/query};
#'             API doc: \url{https://censys.io/api/v1/docs/export}
#' @return API call result (invisibly)
#' @export
#' @examples \dontrun{
#' q <- censys_start_export("
#' SELECT location.country, count(ip) FROM ipv4.20161206 GROUP BY location.country
#' ")
#' censys_export_job_status(q$job_id)
#' censys_export_download(q$job_id, "~/Data")
#' }
censys_start_export <- function(query, format=c("csv", "json"), flatten=TRUE, compress=FALSE,
                          delimiter=",", headers=TRUE) {

  format <- match.arg(format, c("csv", "json"))

  result <- httr::POST(CENSYS_API_URL %s+% "export",
                       body=list(
                         query=query,
                         format=format,
                         flatten=flatten,
                         compress=compress,
                         delimiter=delimiter,
                         headers=headers),
                       encode="json",
                       check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_export_res", class(srs))

  message(sprintf("Query: %s\nStatus: %s\nJob Id: %s",
                  srs$configuration$query, srs$status, srs$job_id))

  invisible(srs)

}

#' Get status of a Censys export job
#'
#' The Get Job Status endpoint lets you retrieved information about a previously submitted
#' job. The status field will return "pending" until the job has completed at which time
#' status will be "success" or "error". On success, the output will define download_paths,
#' a list of files that can be downloaded for the next 24 hours. After 24 hour, the job
#' status will change to "expired" and the files will no longer be retrievable.
#'
#' You must have both \code{CENSYS_API_ID} and \code{CENSYS_API_SECRET} present in the
#' R environment for the functions in this package to work. It is highly suggested that
#' you place those in \code{~/.Renviron} at least for interactive work.
#'
#' @param job_id Censys export job id (from calling \code{censys_start_export()})
#' @references Censys SQL query syntax: \url{https://censys.io/query};
#'             API doc: \url{https://censys.io/api/v1/docs/export}
#' @return API call result (invisibly)
#' @export
#' @examples \dontrun{
#' q <- censys_start_export("
#' SELECT location.country, count(ip) FROM ipv4.20161206 GROUP BY location.country
#' ")
#' censys_export_job_status(q$job_id)
#' censys_export_download(q$job_id, "~/Data")
#' }
censys_export_job_status <- function(job_id) {

  result <- httr::GET(CENSYS_API_URL %s+% "export/" %s+% job_id,
                      check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  class(srs) <- c("censys_export_job_status", class(srs))

  message(sprintf("Query: %s\nStatus: %s\nJob Id: %s",
                  srs$configuration$query, srs$status, srs$job_id))

  invisible(srs)

}

#' Download export job files to a specified directory
#'
#' @param job_id Censys export job id (from calling \code{censys_start_export()})
#' @param path Location for downloaded data.
#' @return API call result (invisibly)
#' @export
#' @examples \dontrun{
#' q <- censys_start_export("
#' SELECT location.country, count(ip) FROM ipv4.20161206 GROUP BY location.country
#' ")
#' censys_export_job_status(q$job_id)
#' censys_export_download(q$job_id, "~/Data")
#' }
censys_export_download <- function(job_id, path) {

  path <- path.expand(path)
  if (!dir.exists(path)) stop(sprintf("'%s' does not exist", path), call.=FALSE)

  result <- httr::GET(CENSYS_API_URL %s+% "export/" %s+% job_id,
                      check_api())

  httr::stop_for_status(result)

  srs <- jsonlite::fromJSON(content(result, as="text"), flatten=TRUE)

  if (srs$status != "success") {
    message("Job has not finished yet")
  } else {
    walk(srs$download_paths, function(x) {

      message(sprintf("Downloading %s...", basename(x)))

      fil_path <- file.path(path, basename(x))
      download.file(x, fil_path)

    })

  }

  class(srs) <- c("censys_export_job_results", class(srs))

  invisible(srs)

}
