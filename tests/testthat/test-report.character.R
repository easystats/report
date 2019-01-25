context("report.character")

test_that("report.character", {
  x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
  r <- report(x)
  testthat::expect_equal(nrow(r$table), 1, tol = 0)
  testthat::expect_null(r$table$Median)

  r <- report(x, levels_percentage = FALSE, missing_percentage = TRUE)
  testthat::expect_equal(nrow(r$table), 1, tol = 0)
  testthat::expect_equal(r$table$percentage_Missing[1], 0, tol = 0)
})
