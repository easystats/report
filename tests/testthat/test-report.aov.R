context("report.aov")

test_that("report.aov", {
  r1 <- report(insight::download_model("anova_1"))
  testthat::expect_equal(c(ncol(r1$tables$table_short), nrow(r1$tables$table_short)), c(7, 2))
  testthat::expect_equal(r1$tables$table_short$Mean_Square[1], 5.6724, tol = 0.01)

  r2 <- report(insight::download_model("aov_1"))
  testthat::expect_equal(c(ncol(r2$tables$table_short), nrow(r2$tables$table_short)), c(7, 2))
  testthat::expect_equal(r2$tables$table_short$Mean_Square[1], 5.6724, tol = 0.01)

  r3 <- report(insight::download_model("aovlist_1"))
  testthat::expect_equal(c(ncol(r3$tables$table_short), nrow(r3$tables$table_short)), c(7, 3))
  testthat::expect_equal(sum(r3$tables$table_short$Mean_Square), 20.04901, tol = 0.01)

  r4 <- report(insight::download_model("aov_2"), eta_squared = TRUE)
  testthat::expect_equal(c(ncol(r4$tables$table_short), nrow(r4$tables$table_short)), c(8, 8))
  testthat::expect_equal(r4$tables$table_short$Mean_Square[1], 31.6060, tol = 0.01)

  r5 <- report(insight::download_model("aovlist_2"))
  testthat::expect_equal(c(ncol(r5$tables$table_short), nrow(r5$tables$table_short)), c(7, 5))
  testthat::expect_equal(r5$tables$table_short$Mean_Square[1], 0.00167, tol = 0.01)
})
