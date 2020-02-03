context("report.htest")

# test_that("report.htest", {
#   # Correlations
#   r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#   testthat::expect_equal(r$values$r, -0.117, tol = 0.01)
#   r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#   testthat::expect_equal(r$values$rho, -0.166, tol = 0.01)
#   r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "kendall"))
#   testthat::expect_equal(r$values$tau, -0.076, tol = 0.01)
#
#   # t-tests
#   r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#   testthat::expect_equal(r$values$Difference, -2.786, tol = 0.01)
#   r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#   testthat::expect_equal(r$values$Difference, -2.786, tol = 0.01)
#   r <- report(t.test(mtcars$mpg ~ mtcars$vs))
#   testthat::expect_equal(r$values$Difference, -7.9404, tol = 0.01)
#   r <- report(t.test(iris$Sepal.Width, mu = 1))
#   testthat::expect_equal(r$values$Difference, 2.057, tol = 0.01)
# })
