test_that("Shapiro-Wilk reports preserve W and the p-value", {
  x <- shapiro.test(c(1, 3, 4, 7, 13, 19))
  result <- report(x)
  table <- as.report_table(result)

  expect_s3_class(result, "report")
  expect_identical(table, report_table(x))
  expect_identical(table$W, unname(x$statistic))
  expect_identical(table$p, x$p.value)
  expect_match(
    as.character(result),
    "Shapiro-Wilk normality test",
    fixed = TRUE
  )
  expect_match(as.character(result), "W = 0.91, p = 0.408", fixed = TRUE)
})

test_that("Bartlett reports preserve K-squared, degrees of freedom, and the p-value", {
  x <- bartlett.test(Sepal.Length ~ Species, data = iris)
  result <- report(x)
  table <- as.report_table(result)

  expect_s3_class(result, "report")
  expect_identical(table, report_table(x))
  expect_identical(table$K2, unname(x$statistic))
  expect_identical(table$df, unname(x$parameter))
  expect_identical(table$p, x$p.value)
  expect_match(
    as.character(result),
    "Bartlett test of homogeneity of variances",
    fixed = TRUE
  )
  expect_match(
    as.character(result),
    "K-squared(2) = 16.01, p < .001",
    fixed = TRUE
  )
})

test_that("Bartlett reports identify undefined statistics for constant groups", {
  x <- bartlett.test(list(rep(1, 3), rep(2, 3)))
  result <- report(x)
  table <- as.report_table(result)

  expect_identical(table$K2, unname(x$statistic))
  expect_identical(table$p, x$p.value)
  expect_match(as.character(result), "K-squared(1) = NA, p = NA", fixed = TRUE)
})
