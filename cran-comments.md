## Test environments
* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R-oldrel, R-release, R-devel
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

* API access is required for tests and every test costs University of Michigan
  real USD on Google's BigQuery engine (access to Censys is free for academics
  and researchers), so all the examples are set to \dontrun{} and the tests
  are set to skip on CRAN and Travis-CI (they also take longer than the CRAN
  guidelines suggest).
  
* Happy New Year! to the CRAN team! You folks are unsung heroes of the R-verse. 
  Many thanks for all your help this year.
