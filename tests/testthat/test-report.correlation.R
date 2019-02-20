context("report.correlation")

test_that("report.correlation", {
  library(BayesFactor)

  r <- report(correlation(iris))
  testthat::expect_equal(nrow(r$values$data), 16)
  r <-  report(correlation(dplyr::group_by(iris, Species), partial=TRUE, p_adjust = "bonf"))
  testthat::expect_equal(nrow(r$values$data), 48)
  r <-  report(correlation(dplyr::group_by(iris, Species), partial="semi"), effsize="evans1996")
  testthat::expect_equal(nrow(r$values$data), 48)
  r <-  report(correlation(iris, bayesian=TRUE))
  testthat::expect_equal(ncol(r$values$data), 10)

})
