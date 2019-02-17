context("format_ci")

test_that("format_ci", {
  testthat::expect_equal(nchar(format_ci(1.2012313, 145)), 21, tol = 0)
})
