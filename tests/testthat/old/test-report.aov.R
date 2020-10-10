context("report.aov")

test_that("report.aov", {
  model <- anova(lm(Sepal.Width ~ Species, data = iris))
  r1 <- report(model)
  testthat::expect_equal(c(ncol(r1$tables$table_short), nrow(r1$tables$table_short)), c(7, 2))
  testthat::expect_equal(r1$tables$table_short$Mean_Square[1], 5.6724, tol = 0.01)

  model <- aov(Sepal.Width ~ Species, data = iris)
  r2 <- report(model)
  testthat::expect_equal(c(ncol(r2$tables$table_short), nrow(r2$tables$table_short)), c(7, 2))
  testthat::expect_equal(r2$tables$table_short$Mean_Square[1], 5.6724, tol = 0.01)

  model <- aov(wt ~ cyl + Error(gear), data = mtcars)
  r3 <- report(model)
  testthat::expect_equal(c(ncol(r3$tables$table_short), nrow(r3$tables$table_short)), c(8, 3))
  testthat::expect_equal(sum(r3$tables$table_short$Mean_Square), 20.04901, tol = 0.01)

  data <- iris
  data$Cat1 <- rep(c("X", "X", "Y"), length.out = nrow(data))
  data$Cat2 <- rep(c("A", "B"), length.out = nrow(data))

  model <- aov(Sepal.Length ~ Species * Cat1 * Cat2, data = data)
  r4 <- report(model, eta_squared = TRUE)
  testthat::expect_equal(c(ncol(r4$tables$table_short), nrow(r4$tables$table_short)), c(8, 8))
  testthat::expect_equal(r4$tables$table_short$Mean_Square[1], 31.6060, tol = 0.01)

  model <- aov(Sepal.Length ~ Species * Cat1 + Error(Cat2), data = data)
  r5 <- report(model)
  testthat::expect_equal(c(ncol(r5$tables$table_short), nrow(r5$tables$table_short)), c(8, 5))
  testthat::expect_equal(r5$tables$table_short$Mean_Square[1], 0.00167, tol = 0.01)
})
