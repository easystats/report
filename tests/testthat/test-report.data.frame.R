context("report.data.frame")

test_that("report.data.frame", {
  r <- report(iris)
  testthat::expect_equal(nrow(r$table), 6, tol = 0)
  testthat::expect_null(r$table$Median)

  r <- report(iris, levels_percentage = FALSE, missing_percentage = TRUE, median = TRUE, range = FALSE, dispersion = FALSE)
  testthat::expect_equal(nrow(r$table), 6, tol = 0)
  testthat::expect_equal(mean(r$table$n_Obs), 100, tol = 0)
})
