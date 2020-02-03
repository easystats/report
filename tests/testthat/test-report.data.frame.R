context("report.data.frame")

# test_that("report.data.frame", {
#   r <- report(iris)
#   testthat::expect_equal(nrow(r$table), 7, tol = 0)
#   testthat::expect_null(r$table$Median)
#
#   r <- report(iris, levels_percentage = FALSE, missing_percentage = TRUE, median = TRUE, range = FALSE, dispersion = FALSE)
#   testthat::expect_equal(nrow(r$table), 7, tol = 0)
#   testthat::expect_equal(mean(r$table$n_Obs), 107, tol = 0.01)
#
#   r <- report(dplyr::group_by_(iris, "Species"))
#   testthat::expect_equal(nrow(r$table), 12, tol = 0)
#   testthat::expect_equal(mean(r$table$n_Obs), 50, tol = 0)
# })


context("report.character")

# test_that("report.character", {
#   x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
#   r <- report(x)
#   testthat::expect_equal(nrow(r$table), 1, tol = 0)
#   testthat::expect_null(r$table$Median)
#
#   r <- report(x, levels_percentage = FALSE, missing_percentage = TRUE)
#   testthat::expect_equal(nrow(r$table), 1, tol = 0)
#   testthat::expect_equal(r$table$percentage_Missing[1], 0, tol = 0)
# })



context("report.factor")

# test_that("report.factor", {
#   r <- report(factor(rep(c("A", "B", "C"), 10)))
#   testthat::expect_equal(nrow(r$table), 3, tol = 0)
#   testthat::expect_warning(r$table$Median)
#
#   r <- report(factor(rep(c("A", "B", "C", NA), 10)), levels_percentage = FALSE)
#   testthat::expect_equal(nrow(r$table), 4, tol = 0)
# })



context("report.numeric")

# test_that("report.numeric", {
#   r <- report(seq(0, 1, length.out = 100))
#   testthat::expect_equal(r$table$Mean, 0.5, tol = 0)
#   testthat::expect_null(r$table$Median)
#
#   r <- report(seq(0, 1, length.out = 100), median = TRUE, range = FALSE, dispersion = FALSE, missing_percentage = TRUE)
#   testthat::expect_equal(r$table$Median, 0.5, tol = 0)
#   testthat::expect_equal(r$table$percentage_Missing, 0, tol = 0)
#   testthat::expect_null(r$table$Mean)
#   testthat::expect_null(r$table$Min)
#   testthat::expect_null(r$table$MAD)
#   testthat::expect_warning(report(c(0, 0, 0, 1, 1)))
# })
