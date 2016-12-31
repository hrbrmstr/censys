
<!-- README.md is generated from README.Rmd. Please edit that file -->



[![Travis-CI Build Status](https://travis-ci.org/hrbrmstr/censys.svg?branch=master)](https://travis-ci.org/hrbrmstr/censys) [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/censys)](https://cran.r-project.org/package=censys)

`censys` is an R package interface to the [Censys API](https://censys.io/api)

Censys is a search engine that enables researchers to ask questions about the hosts and networks that compose the Internet. Censys collects data on hosts and websites through daily [ZMap](https://zmap.io/) and [ZGrab](https://github.com/zmap/zgrab) scans of the IPv4 address space, in turn maintaining a database of how hosts and websites are configured. Researchers can interact with this data through a search interface, report builder, and SQL engine.

[Censys tutorial](https://www.censys.io/tutorial).

The following functions are implemented:

- `censys_export_download`:	Download export job files to a specified directory
- `censys_export_job_status`:	Get status of a Censys export job
- `censys_get_job_result`:	Get results of completed Censys SQL query job
- `censys_get_job_status`:	Get status of a Censys SQL query job
- `censys_query`:	Issue SQL Queries against the Censys API
- `censys_report`:	Create aggregate reports on the breakdown of a field in the result set of a query
- `censys_search`:	Perform queries against Censys data
- `censys_series`:	List all series that can be queried from the SQL interface
- `censys_series_details`:	Get details about a series, including the list of tables and schema for the series
- `censys_start_export`:	Export large datasets and structured records from Censys to JSON or CSV files
- `get_series`:	Retrieve data on the types of scans Censys regularly performs ("series").
- `view_document`:	Retrieve data that Censys has about a specific host, website, or certificate.
- `view_result`:	Retrieve data on a particular scan "result"
- `view_series`:	Retrieve data that Censys has about a particular series

### Installation


```r
devtools::install_github("hrbrmstr/censys")
```



### Usage


```r
library(censys)

# current verison
packageVersion("censys")
#> [1] '0.1.0'

library(purrr)
library(dplyr)

res <- censys_query("
SELECT p80.http.get.headers.server, p80.http.get.headers.www_authenticate, location.country, autonomous_system.asn
FROM ipv4.20161206
WHERE REGEXP_MATCH(p80.http.get.headers.server, r'gen[56]')
")

inf <- censys_get_job_status(res$job_id)

Sys.sleep(10) # giving it some time to process for the README

map(1:3, ~censys_get_job_result(inf$job_id, .)) %>% 
  map(c("rows", "f")) %>% 
  flatten() %>% 
  map("v") %>% 
  map_df(~setNames(as.list(.), c("server", "auth", "geo", "asn"))) %>% 
  count(geo, sort=TRUE)
#> # A tibble: 54 × 2
#>               geo     n
#>             <chr> <int>
#> 1   United States   645
#> 2         Germany   338
#> 3         Vietnam   233
#> 4         Austria   135
#> 5          France   127
#> 6           Japan    77
#> 7  Czech Republic    64
#> 8           Italy    60
#> 9          Russia    57
#> 10         Canada    44
#> # ... with 44 more rows
```

### Test Results


```r
library(censys)
library(testthat)

date()
#> [1] "Sat Dec 31 10:14:03 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 2 SKIPPED: 0 FAILED: 0
#> 
#> DONE ===================================================================================================================
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). 
By participating in this project you agree to abide by its terms.
