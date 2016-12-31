context("basic functionality")
test_that("we can do something", {

  testthat::skip_on_cran()
  testthat::skip_on_travis()

  expect_gte(length(get_series()), 2)

  q <- censys_query("SELECT p443.https.tls.cipher_suite.name, count(ip) FROM ipv4
                   WHERE p443.https.tls.validation.browser_trusted=true
                   GROUP BY p443.https.tls.cipher_suite.name;")

  expect_equal(sort(names(q)), c("configuration", "job_id", "status"))

})
