#' Tools to access the Censys API
#'
#' Censys is a search engine that allows computer scientists to ask questions
#' about the devices and networks that compose the Internet. Driven by I
#' nternet-wide scanning, Censys lets researchers find specific hosts and
#' create aggregate reports on how devices, websites, and certificates are
#' configured and deployed.
#'
#' The Censys API provides programmatic access to the same data accessible
#' through web interface (\url{https://censys.io/}).
#'
#' You must have both \code{CENSYS_API_ID} and \code{CENSYS_API_SECRET} present in the
#' R environment for the functions in this package to work. It is highly suggested that
#' you place those in \code{~/.Renviron} at least for interactive work.
#'
#' Censys tutorial: \url{https://censys.io/tutorial}
#'
#' @name censys
#' @docType package
#' @author Bob Rudis (brudis@@rapid7.com)
#' @references \url{https://censys.io/about};
#'             \url{https://censys.io/static/censys.pdf}
#' @import httr jsonlite stringi
#' @importFrom purrr walk
#' @importFrom utils download.file
NULL
