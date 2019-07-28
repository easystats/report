# context("report.easycorrelation")
#
# test_that("report.easycorrelation", {
#   library(BayesFactor)
#
#   r <- report(correlation(iris))
#   testthat::expect_equal(nrow(r$values$data), 16)
#   testthat::expect_equal(nrow(to_table(r)), 3)
#   r <-  report(correlation(dplyr::group_by(iris, Species), partial=TRUE, p_adjust = "bonf"))
#   testthat::expect_equal(nrow(r$values$data), 48)
#   testthat::expect_equal(nrow(to_table(r)), 11)
#   r <-  report(correlation(dplyr::group_by(iris, Species), partial="semi"), effsize="evans1996")
#   testthat::expect_equal(nrow(r$values$data), 48)
#   testthat::expect_equal(nrow(to_table(r)), 11)
#   r <-  report(correlation(iris, bayesian=TRUE))
#   testthat::expect_equal(nrow(r$values$data), 16)
#   testthat::expect_equal(nrow(to_table(r)), 3)
#
# })
