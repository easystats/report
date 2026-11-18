test_that("Median removes NA", {
  x <- c(1, 2, NA, 4)
  result <- report_table(x)$Median
  expect_identical(result, median(x, na.rm = TRUE))
})

test_that("numeric reports retain requested observation counts", {
  for (x in list(1:5, c(1:5, NA))) {
    result <- report(x, n = TRUE, varname = "values")
    table <- report_table(x, n = TRUE)
    text <- report_text(x, n = TRUE, varname = "values")

    expect_identical(as.report_table(result), table)
    expect_identical(as.report_table(result, summary = TRUE), summary(table))
    expect_identical(as.character(result), as.character(text))
    expect_identical(as.character(summary(result)), as.character(summary(text)))
    expect_identical(as.report_table(result, summary = TRUE)$n_Obs, length(x))
    expect_match(
      as.character(summary(result)),
      paste0("values: n = ", length(x)),
      fixed = TRUE
    )
  }
})

test_that("numeric reports omit observation counts from summaries by default", {
  for (x in list(1:5, c(1:5, NA))) {
    result <- report(x)

    expect_identical(result, report(x, n = FALSE))
    expect_null(as.report_table(result, summary = TRUE)$n_Obs)
    expect_no_match(as.character(summary(result)), "\\bn = ")
    expect_identical(
      as.character(summary(result)),
      as.character(summary(report_text(x, n = FALSE)))
    )
  }
})
