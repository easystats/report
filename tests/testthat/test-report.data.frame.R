skip_if_not(getRversion() <= "4.2.1")

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

test_that("report.data.frame", {
  skip_if_not_or_load_if_installed("dplyr")

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

  r <- report(group_by(iris, Species))
  expect_equal(nrow(as.data.frame(r)), 8, tolerance = 0)
  expect_equal(mean(as.data.frame(r)$n_Obs), 50, tolerance = 0)

  expect_snapshot(variant = "windows", r)
})

test_that("report.data.frame - with NAs", {
  skip_if_not_or_load_if_installed("dplyr")

  df <- mtcars
  df[1, 2] <- NA
  df[1, 6] <- NA

  report_grouped_df <- report(group_by(df, cyl))
  expect_snapshot(variant = "windows", report_grouped_df)
})

test_that("report.data.frame - with list columns", {
  skip_if_not_or_load_if_installed("dplyr")

  set.seed(123)
  expect_snapshot(variant = "windows", report(dplyr::starwars))
})
