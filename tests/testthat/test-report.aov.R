context("report.aov")

test_that("report.aov", {
  model <- anova(lm(Sepal.Width ~ Species, data = iris))
  r1 <- report(model)
  expect_equal(c(ncol(as.report_table(r1, summary = TRUE)), nrow(as.report_table(r1, summary = TRUE))), c(7, 2))
  expect_equal(as.report_table(r1, summary = TRUE)$Mean_Square[1], 5.6724, tolerance = 0.01)

  model <- aov(Sepal.Width ~ Species, data = iris)
  r2 <- report(model)
  expect_equal(c(ncol(as.report_table(r2, summary = TRUE)), nrow(as.report_table(r2, summary = TRUE))), c(7, 2))
  expect_equal(as.report_table(r2, summary = TRUE)$Mean_Square[1], 5.6724, tolerance = 0.01)

  model <- aov(wt ~ cyl + Error(gear), data = mtcars)
  r3 <- report(model)
  expect_equal(c(ncol(as.report_table(r3, summary = TRUE)), nrow(as.report_table(r3, summary = TRUE))), c(8, 3))
  expect_equal(sum(as.report_table(r3, summary = TRUE)$Mean_Square), 20.04901, tolerance = 0.01)

  data <- iris
  data$Cat1 <- rep(c("X", "X", "Y"), length.out = nrow(data))
  data$Cat2 <- rep(c("A", "B"), length.out = nrow(data))

  model <- aov(Sepal.Length ~ Species * Cat1 * Cat2, data = data)
  r4 <- report(model)
  expect_equal(c(ncol(as.report_table(r4, summary = TRUE)), nrow(as.report_table(r4, summary = TRUE))), c(7, 8))
  expect_equal(as.report_table(r4, summary = TRUE)$Mean_Square[1], 31.6060, tolerance = 0.01)

  model <- aov(Sepal.Length ~ Species * Cat1 + Error(Cat2), data = data)
  r5 <- report(model)
  expect_equal(c(ncol(as.report_table(r5, summary = TRUE)), nrow(as.report_table(r5, summary = TRUE))), c(8, 5))
  expect_equal(as.report_table(r5, summary = TRUE)$Mean_Square[1], 0.00167, tolerance = 0.01)
})
