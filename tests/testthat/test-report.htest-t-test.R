test_that("report.htest-t-test", {
  # TODO: remove once you figure out why there is a discrepancy between local
  # snapshot and CI snapshot
  skip_on_ci()

  # two samples unpaired t-tests summaries ---------------------

  set.seed(123)
  r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, -2.786, tolerance = 0.01)

  set.seed(123)
  r <- report(t.test(iris$Sepal.Width, iris$Sepal.Length))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, -2.786, tolerance = 0.01)

  set.seed(123)
  r <- report(t.test(mtcars$mpg ~ mtcars$vs))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, -7.9404, tolerance = 0.01)

  set.seed(123)
  r <- report(t.test(iris$Sepal.Width, mu = 1))
  expect_equal(as.report_table(r, summary = TRUE)$Difference, 2.057, tolerance = 0.01)

  # one-sample t-test ---------------------

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(iris$Sepal.Width, mu = 1)))

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(iris$Sepal.Width, mu = -1, alternative = "l")))

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(iris$Sepal.Width, mu = 5, alternative = "g")))

  # two-sample unpaired t-test ---------------------

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(formula = wt ~ am, data = mtcars)))

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(formula = wt ~ am, data = mtcars, alternative = "l")))

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(formula = wt ~ am, data = mtcars, alternative = "g")))

  # two-sample paired t-test ---------------------

  x <- c(1.83, 0.50, 1.62, 2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
  y <- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(x, y, paired = TRUE, data = mtcars)))

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(x, y, paired = TRUE, data = mtcars, alternative = "l")))

  set.seed(123)
  expect_snapshot(variant = .Platform$OS.type, report(t.test(x, y, paired = TRUE, data = mtcars, alternative = "g")))

  if (getRversion() > "4.0") {
    sleep2 <- reshape(sleep, direction = "wide", idvar = "ID", timevar = "group")
    set.seed(123)
    expect_snapshot(variant = .Platform$OS.type, report(t.test(Pair(extra.1, extra.2) ~ 1, data = sleep2)))
  }
})
