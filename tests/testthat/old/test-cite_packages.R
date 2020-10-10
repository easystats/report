context("cite_packages")

test_that("cite_packages", {
  testthat::expect_equal(ncol(show_packages(sessionInfo())), 3)
  testthat::expect_equal(ncol(cite_packages(sessionInfo())), 1)
})
