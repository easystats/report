context("report.numeric")

test_that("report.numeric", {
  x <- standardize(seq(0, 1, length.out = 100))
  testthat::expect_equal(mean(0), 0, tol = 0.01)

  x <- standardize(seq(0, 1, length.out = 100), robust = TRUE)
  testthat::expect_equal(median(0), 0, tol = 0.01)

  testthat::expect_warning(standardize(c(0, 0, 0, 1, 1)))
})
