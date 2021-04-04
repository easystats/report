test_that("report.htest", {
  # Correlations ---------------------
  r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
  expect_equal(as.report_table(r)$r, -0.117, tolerance = 0.01)

  r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
  expect_equal(as.report_table(r)$rho, -0.166, tolerance = 0.01)

  r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "kendall"))
  expect_equal(as.report_table(r)$tau, -0.077, tolerance = 0.01)

  # snapshot tests with a different dataset
  set.seed(123)
  expect_snapshot(report(cor.test(mtcars$wt, mtcars$mpg)))

  set.seed(123)
  expect_snapshot(report(cor.test(mtcars$wt, mtcars$mpg, method = "spearman")))

  set.seed(123)
  expect_snapshot(report(cor.test(mtcars$wt, mtcars$mpg, method = "kendall")))

  # t-tests ---------------------
  r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, -2.786, tolerance = 0.01)

  r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, -2.786, tolerance = 0.01)

  r <- report(t.test(mtcars$mpg ~ mtcars$vs))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, 7.9404, tolerance = 0.01)

  r <- report(t.test(iris$Sepal.Width, mu = 1))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, 2.057, tolerance = 0.01)

  # one-sample
  set.seed(123)
  expect_snapshot(report(t.test(iris$Sepal.Width, mu = 1)))

  # two-sample unpaired
  set.seed(123)
  expect_snapshot(report(t.test(formula = wt ~ am, data = mtcars)))

  if (getRversion() > "4.0") {
    # two-sample paired
    sleep2 <- reshape(sleep, direction = "wide", idvar = "ID", timevar = "group")
    set.seed(123)
    expect_snapshot(report(t.test(Pair(extra.1, extra.2) ~ 1, data = sleep2)))
  }
})
