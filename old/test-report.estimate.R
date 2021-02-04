context("report.estimate")

# test_that("report.estimate", {
#   library(estimate)
#
#   model <- lm(Sepal.Width ~ Species * Petal.Width, data = iris)
#
#   r <- report(estimate_contrasts(model))
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(3, 8))
#
#   r <- report(estimate_contrasts(model, fixed = "Petal.Width"))
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(3, 9))
#
#   r <- report(estimate_contrasts(model, modulate = "Petal.Width", length = 2))
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(6, 9))
#
#   r <- report(estimate_means(model))
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(3, 5))
#
#   # r <- report(estimate_slopes(model))
#   # expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(3, 5))
#
#   model <- lm(Sepal.Width ~ poly(Petal.Length, 2), data = iris)
#   # r <- report(estimate_smooth(model))
#   # expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(3, 5))
# })
