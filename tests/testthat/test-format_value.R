context("format_value")

test_that("format_value", {
  testthat::expect_equal(nchar(format_value(1.2012313)), 4, tol = 0)
})
