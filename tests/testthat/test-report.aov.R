context("report.aov")

# test_that("report.aov", {
#   r <- report(insight::download_model("anova_1"), omega_squared = "partial")
#   testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 2))
#   testthat::expect_equal(r$values$Species$Mean_Square, 5.6724, tol = 0.01)
#
#   r <- report(insight::download_model("aov_1"), omega_squared = "partial")
#   testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 2))
#   testthat::expect_equal(r$values$Species$Mean_Square, 5.6724, tol = 0.01)
#
#   r <- report(insight::download_model("aovlist_1"))
#   testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 3))
#   testthat::expect_equal(r$values$cyl$Mean_Square, 9.61, tol = 0.01)
#
#   r <- report(insight::download_model("aov_2"), eta_squared = TRUE)
#   testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 8))
#   testthat::expect_equal(r$values$Species$Mean_Square, 31.6060, tol = 0.01)
#
#   r <- report(insight::download_model("aovlist_2"))
#   testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 5))
#   testthat::expect_equal(r$values$Species$Mean_Square, 31.6060, tol = 0.01)
# })
