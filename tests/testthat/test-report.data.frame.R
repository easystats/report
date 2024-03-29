test_that("report.numeric", {
  r <- report(seq(0, 1, length.out = 100))
  expect_equal(as.data.frame(r)$Mean, 0.5, tolerance = 0)
  expect_null(as.report_table(r, summary = TRUE)$Median)

  r <- report(
    seq(0, 1, length.out = 100),
    centrality = "median",
    range = FALSE,
    dispersion = FALSE,
    missing_percentage = TRUE
  )
  expect_equal(as.data.frame(r)$Median, 0.5, tolerance = 0)
  expect_equal(as.data.frame(r)$percentage_Missing, 0, tolerance = 0)
  expect_null(summary(as.data.frame(r))$Mean)
  expect_null(summary(as.data.frame(r))$Min)
  expect_null(summary(as.data.frame(r))$MAD)
  expect_warning(report(c(0, 0, 0, 1, 1)), "factor")
})


test_that("report.character", {
  x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
  r <- report(x)
  expect_equal(nrow(as.data.frame(r)), 1, tolerance = 0)
  expect_null(as.data.frame(r)$Median)

  r <- report(x, levels_percentage = FALSE, missing_percentage = TRUE)
  expect_equal(nrow(as.data.frame(r)), 1, tolerance = 0)
  expect_equal(as.data.frame(r)$percentage_Missing[1], 0, tolerance = 0)
})

test_that("report.factor", {
  r <- report(factor(rep(c("A", "B", "C"), 10)))
  expect_equal(nrow(as.data.frame(r)), 3, tolerance = 0)
  expect_null(as.data.frame(r)$Median)
  expect_snapshot(variant = "windows", r)

  r <- report(factor(rep(c("A", "B", "C", NA), 10)), levels_percentage = FALSE)
  expect_equal(nrow(as.data.frame(r)), 4, tolerance = 0)
})

test_that("report.Date", {
  set.seed(123)
  x <- sample(seq(as.Date("1999/01/01"), as.Date("1999/01/05"), by = "day"), 30, replace = TRUE)
  r <- report(x)
  expect_equal(
    as.character(r),
    "x: 5 levels, namely 1999-01-01 (n = 6, 20.00%), 1999-01-02 (n = 6, 20.00%), 1999-01-03 (n = 9, 30.00%), 1999-01-04 (n = 4, 13.33%) and 1999-01-05 (n = 5, 16.67%)",
    ignore_attr = TRUE
  )
})

test_that("report.data.frame", {
  skip_if_not_installed("dplyr")

  r <- report(iris)
  expect_equal(nrow(as.data.frame(r)), 7, tolerance = 0)
  expect_equal(mean(as.data.frame(r)$Median, na.rm = TRUE), 3.6125)

  r <- report(
    iris,
    levels_percentage = FALSE,
    missing_percentage = TRUE,
    median = TRUE,
    range = FALSE,
    dispersion = FALSE
  )
  expect_equal(nrow(as.data.frame(r)), 7, tolerance = 0)
  expect_equal(mean(as.data.frame(r)$n_Obs), 107, tolerance = 0.01)

  r <- report(dplyr::group_by(iris, Species))
  expect_equal(nrow(as.data.frame(r)), 12, tolerance = 0)
  expect_equal(mean(as.data.frame(r)$n_Obs), 50, tolerance = 0)

  expect_snapshot(variant = "windows", r)
})

test_that("report.data.frame - with NAs", {
  skip_if_not_installed("dplyr")

  df <- mtcars
  df[1, 2] <- NA
  df[1, 6] <- NA

  report_grouped_df <- report(dplyr::group_by(df, cyl))
  expect_snapshot(variant = "windows", report_grouped_df)
})

test_that("report.data.frame - with list columns", {
  skip_if_not_installed("dplyr")

  set.seed(123)
  expect_snapshot(variant = "windows", report(dplyr::starwars))
})
