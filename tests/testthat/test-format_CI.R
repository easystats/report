context("format_CI")

test_that("format_CI", {
  testthat::expect_equal(nchar(format_CI(1.2012313, 145)), 21, tol = 0)
})
