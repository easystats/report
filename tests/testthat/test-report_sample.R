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

# test_that("report_sample weights", {
#   expect_snapshot(report_sample(airquality, weights = "Temp"))
#   expect_snapshot(report_sample(mtcars, weights = "carb"))
#   expect_snapshot(report_sample(iris, weights = "Petal.Width"))
# })
