if (require("testthat")) {
  data(iris)
  test_that("report.htest", {
    # Correlations
    r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
    testthat::expect_equal(as.list(r)$r, -0.117, tol = 0.01)
    r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
    testthat::expect_equal(as.list(r)$rho, -0.166, tol = 0.01)
    r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "kendall"))
    testthat::expect_equal(as.list(r)$tau, -0.076, tol = 0.01)

    # t-tests
    r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
    testthat::expect_equal(r$tables$table_short$Difference, -2.786, tol = 0.01)
    r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length))
    testthat::expect_equal(r$tables$table_short$Difference, -2.786, tol = 0.01)
    r <- report(t.test(mtcars$mpg ~ mtcars$vs))
    testthat::expect_equal(r$tables$table_short$Difference, 7.9404, tol = 0.01)
    r <- report(t.test(iris$Sepal.Width, mu = 1))
    testthat::expect_equal(r$tables$table_short$Difference, 2.057, tol = 0.01)
  })
}
