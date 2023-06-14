test_that("report_sample weights, coorect weighted N", {
  d <- data.frame(
    x = c("a", "a", "a", "a", "b", "b", "b", "b", "c", "c", "c", "c"),
    g = c(1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2),
    w = c(0.5, 0.5, 1, 1, 1.5, 1.5, 2, 2, 1, 1, 1.5, 1.5),
    stringsAsFactors = FALSE
  )

  out1 <- report_sample(d, select = "x", group_by = "g")
  out2 <- report_sample(d, select = "x", group_by = "g", weights = "w")
  expect_identical(
    capture.output(print(out1)),
    c(
      "# Descriptive Statistics",
      "",
      "Variable | 1 (n=6) | 2 (n=6) | Total (n=12)",
      "-------------------------------------------",
      "x [a], % |    33.3 |    33.3 |         33.3",
      "x [b], % |    33.3 |    33.3 |         33.3",
      "x [c], % |    33.3 |    33.3 |         33.3"
    )
  )
  expect_identical(
    capture.output(print(out2)),
    c(
      "# Descriptive Statistics (weighted)",
      "",
      "Variable | 1 (n=6) | 2 (n=9) | Total (n=15)",
      "-------------------------------------------",
      "x [a], % |    16.7 |    22.2 |         20.0",
      "x [b], % |    50.0 |    44.4 |         46.7",
      "x [c], % |    33.3 |    33.3 |         33.3"
    )
  )

  d <- data.frame(
    x = c("a", "a", "a", "a", "b", "b", "b", "b", "c", "c", "c", "c"),
    g1 = c(1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2),
    g2 = c(3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1),
    w = c(0.5, 0.5, 1, 1, 1.5, 1.5, 2, 2, 1, 1, 1.5, 1.5),
    stringsAsFactors = FALSE
  )
  expect_error(
    report_sample(d, select = "x", group_by = c("g1", "g2"), weights = "w"),
    regex = "Cannot apply"
  )
})

test_that("report_sample check input", {
  skip_if(packageVersion("parameters") < "0.20.3")
  data(iris)
  expect_error(report_sample(lm(Sepal.Length ~ Species, data = iris)))
  expect_silent(report_sample(iris$Species))
})

test_that("report_sample default", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris)
  )
})

test_that("report_sample n = TRUE", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, n = TRUE)
  )
  expect_equal(
    nchar(report_sample(airquality, n = TRUE)),
    c(Variable = 131, Summary = 128),
    ignore_attr = TRUE
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, n = TRUE)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, n = TRUE)
  )
})

test_that("report_sample CI", {
  expect_snapshot(
    variant = "windows",
    report_sample(iris, select = c("Sepal.Length", "Species"), ci = 0.95, ci_method = "wald")
  )

  expect_snapshot(
    variant = "windows",
    report_sample(iris, select = c("Sepal.Length", "Species"), ci = 0.95, ci_method = "wilson")
  )

  set.seed(123)
  d <- data.frame(
    x = as.factor(rbinom(1000, 1, prob = 0.03)),
    w = abs(rnorm(1000, 1, 0.1))
  )
  expect_snapshot(
    variant = "windows",
    report_sample(d, ci = 0.95, select = "x", ci_method = "wald")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(d, ci = 0.95, select = "x", ci_method = "wilson")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(d, ci = 0.95, ci_correct = TRUE, select = "x", ci_method = "wald")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(d, ci = 0.95, ci_correct = TRUE, select = "x", ci_method = "wilson")
  )
  expect_warning(report_sample(d, ci = 0.95, weights = "w", ci_method = "wald"), regex = "accurate")
})

test_that("report_sample group_by", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, group_by = "Month")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, group_by = "cyl")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, group_by = "Species")
  )
})

test_that("report_sample centrality", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, centrality = "mean")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, centrality = "mean")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, centrality = "mean")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, centrality = "median")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, centrality = "median")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, centrality = "median")
  )
})

test_that("report_sample select", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, select = "Temp")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, select = c("mpg", "disp"))
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, select = "Petal.Width")
  )
})

test_that("report_sample exclude", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, exclude = "Temp")
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, exclude = c("mpg", "disp"))
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, exclude = "Petal.Width")
  )
})

test_that("report_sample total", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, total = TRUE)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, total = FALSE)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, group_by = "Month", total = TRUE)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, group_by = "Month", total = FALSE)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, group_by = "Month", total = FALSE, n = TRUE)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, group_by = "Month", total = TRUE, n = TRUE)
  )
})

test_that("report_sample digits", {
  expect_snapshot(
    variant = "windows",
    report_sample(airquality, digits = 5)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(mtcars, digits = 5)
  )
  expect_snapshot(
    variant = "windows",
    report_sample(iris, digits = 5)
  )
})

test_that("report_sample weights", {
  expect_snapshot(report_sample(airquality, weights = "Temp"), variant = "windows")
  expect_snapshot(report_sample(mtcars, weights = "carb"), variant = "windows")
  expect_snapshot(report_sample(iris, weights = "Petal.Width"), variant = "windows")
})

test_that("report_sample grouped data frames", {
  skip_if_not_installed("datawizard")
  data(mtcars)
  mtcars_grouped <- datawizard::data_group(mtcars, "gear")
  out1 <- report_sample(mtcars_grouped, select = c("hp", "mpg"))
  out2 <- report_sample(mtcars, group_by = "gear", select = c("hp", "mpg"))
  expect_identical(out1, out2)
})

test_that("report_sample, with more than one grouping variable", {
  data(iris)
  set.seed(123)
  iris$grp <- sample(letters[1:3], nrow(iris), TRUE)
  out <- report_sample(
    iris,
    group_by = c("Species", "grp"),
    select = c("Sepal.Length", "Sepal.Width")
  )
  # verified against
  expected <- aggregate(iris["Sepal.Length"], iris[c("Species", "grp")], mean)
  expect_snapshot(out)
})

test_that("report_sample, numeric select", {
  data(iris)
  out1 <- report_sample(
    iris,
    select = c("Sepal.Length", "Sepal.Width")
  )
  out2 <- report_sample(
    iris,
    select = 1:2
  )
  expect_identical(out1, out2)
})

test_that("report_sample, print vertical", {
  skip_if_not_installed("datawizard")
  skip_if_not(getRversion() >= "4.2.0")
  data(iris)
  set.seed(123)
  iris$grp <- sample(letters[1:3], nrow(iris), TRUE)
  out <- iris |>
    datawizard::data_group(c("Species", "grp")) |>
    report_sample(select = 1:3)
  expect_snapshot(print(out, layout = "vertical"))
})
