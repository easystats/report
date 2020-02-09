context("report.aov")

test_that("report.aov", {
  r <- report(insight::download_model("anova_1"))
  testthat::expect_equal(c(ncol(r$tables$table_short), nrow(r$tables$table_short)), c(7, 2))
  testthat::expect_equal(r$tables$table_short$Mean_Square[1], 5.6724, tol = 0.01)

  r <- report(insight::download_model("aov_1"))
  testthat::expect_equal(c(ncol(r$tables$table_short), nrow(r$tables$table_short)), c(7, 2))
  testthat::expect_equal(r$tables$table_short$Mean_Square[1], 5.6724, tol = 0.01)

  r <- report(insight::download_model("aovlist_1"))
  testthat::expect_equal(c(ncol(r$tables$table_short), nrow(r$tables$table_short)), c(7, 3))
  testthat::expect_equal(r$tables$table_short$Mean_Square[1], 9.61, tol = 0.01)

  r <- report(insight::download_model("aov_2"), eta_squared = TRUE)
  testthat::expect_equal(c(ncol(r$tables$table_short), nrow(r$tables$table_short)), c(8, 8))
  testthat::expect_equal(r$tables$table_short$Mean_Square[1], 31.6060, tol = 0.01)

  r <- report(insight::download_model("aovlist_2"))
  testthat::expect_equal(c(ncol(r$tables$table_short), nrow(r$tables$table_short)), c(7, 5))
  testthat::expect_equal(r$tables$table_short$Mean_Square[1], 0.00167, tol = 0.01)
})
