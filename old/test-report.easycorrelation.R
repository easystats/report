
# test_that("report.easycorrelation", {
#   library(BayesFactor)
#
#   r <- report(correlation(iris))
#   expect_equal(nrow(r$values$data), 16)
#   expect_equal(nrow(to_table(r)), 3)
#   r <-  report(correlation(group_by(iris, Species), partial=TRUE, p_adjust = "bonf"))
#   expect_equal(nrow(r$values$data), 48)
#   expect_equal(nrow(to_table(r)), 11)
#   r <-  report(correlation(group_by(iris, Species), partial="semi"), effsize="evans1996")
#   expect_equal(nrow(r$values$data), 48)
#   expect_equal(nrow(to_table(r)), 11)
#   r <-  report(correlation(iris, bayesian=TRUE))
#   expect_equal(nrow(r$values$data), 16)
#   expect_equal(nrow(to_table(r)), 3)
#
# })
