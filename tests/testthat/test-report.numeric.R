context("report.numeric")

test_that("report.numeric", {
  r <- report(seq(0, 1, length.out = 100))
  testthat::expect_equal(r$table$Mean, 0.5, tol = 0)
  testthat::expect_null(r$table$Median)

  r <- report(seq(0, 1, length.out = 100), median = TRUE, range = FALSE, dispersion = FALSE, missing_percentage = TRUE)
  testthat::expect_equal(r$table$Median, 0.5, tol = 0)
  testthat::expect_equal(r$table$percentage_Missing, 0, tol = 0)
  testthat::expect_null(r$table$Mean)
  testthat::expect_null(r$table$Min)
  testthat::expect_null(r$table$MAD)
})
