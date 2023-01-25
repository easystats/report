test_that("report.htest-t-test", {
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
  expect_snapshot(variant = "windows", report(t.test(iris$Sepal.Width, mu = 1)))

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(
    iris$Sepal.Width,
    mu = -1, alternative = "l"
  )))

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(
    iris$Sepal.Width,
    mu = 5, alternative = "g"
  )))

  # two-sample unpaired t-test ---------------------

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(mtcars$wt ~ mtcars$am)))

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(mtcars$wt ~ mtcars$am, alternative = "l")))

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(mtcars$wt ~ mtcars$am, alternative = "g")))

  # two-sample paired t-test ---------------------

  x <<- c(1.83, 0.50, 1.62, 2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
  y <<- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(x, y, paired = TRUE)))

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(x, y, paired = TRUE, alternative = "l")))

  set.seed(123)
  expect_snapshot(variant = "windows", report(t.test(x, y, paired = TRUE, alternative = "g")))

  if (getRversion() > "4.0") {
    sleep2 <<- reshape(sleep, direction = "wide", idvar = "ID", timevar = "group")
    set.seed(123)
    expect_snapshot(
      variant = "windows",
      report(t.test(sleep2$extra.1, sleep2$extra.2, paired = TRUE))
    )
  }

  # type, rules ---------------------

  x <- t.test(mtcars$mpg ~ mtcars$vs)
  expect_snapshot(
    variant = "windows",
    report_effectsize(x)
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "d")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "g")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "cohen1988")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "cohen1988", type = "d")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "cohen1988", type = "g")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "sawilowsky2009")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "sawilowsky2009", type = "d")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "sawilowsky2009", type = "g")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "gignac2016")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "gignac2016", type = "d")
  )
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "gignac2016", type = "g")
  )
})
