context("report.factor")

test_that("report.factor", {
  r <- report(factor(rep(c("A", "B", "C"), 10)))
  testthat::expect_equal(nrow(r$table), 3, tol = 0)
  testthat::expect_warning(r$table$Median)

  r <- report(factor(rep(c("A", "B", "C", NA), 10)), levels_percentage = FALSE)
  testthat::expect_equal(nrow(r$table), 4, tol = 0)
})
