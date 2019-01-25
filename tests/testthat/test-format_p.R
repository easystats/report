context("format_p")

test_that("format_p", {
  testthat::expect_equal(nchar(format_p(0.02)), 5, tol = 0)
  testthat::expect_equal(nchar(format_p(0.02, stars = TRUE)), 6, tol = 0)
  testthat::expect_equal(nchar(format_p(0.02, stars_only = TRUE)), 1, tol = 0)
})
