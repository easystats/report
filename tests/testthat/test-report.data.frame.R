context("report data")


context("report.numeric")

test_that("report.numeric", {
  r <- report(seq(0, 1, length.out = 100))
  testthat::expect_equal(as.data.frame(r)$Mean, 0.5, tol = 0)
  testthat::expect_null(as.report_table(r, summary = TRUE)$Median)

  r <- report(seq(0, 1, length.out = 100), centrality = "median", range = FALSE, dispersion = FALSE, missing_percentage = TRUE)
  testthat::expect_equal(as.data.frame(r)$Median, 0.5, tol = 0)
  testthat::expect_equal(as.data.frame(r)$percentage_Missing, 0, tol = 0)
  testthat::expect_null(summary(as.data.frame(r))$Mean)
  testthat::expect_null(summary(as.data.frame(r))$Min)
  testthat::expect_null(summary(as.data.frame(r))$MAD)
  testthat::expect_warning(report(c(0, 0, 0, 1, 1)))
})
