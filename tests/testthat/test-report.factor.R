test_that("literal missing factor levels remain distinct from missing values", {
  x <- factor(c("missing", "a", NA, NA))
  result <- report(x)
  table <- as.report_table(result)

  expect_identical(as.character(table$Level), c("a", "missing", "missing (NA)"))
  expect_identical(table$n_Obs, c(1L, 1L, 2L))
  expect_identical(table$percentage_Obs, c(25, 25, 50))
  expect_match(as.character(result), "2 levels, namely", fixed = TRUE)
  expect_match(as.character(result), "missing (NA) (n = 2", fixed = TRUE)

  x <- factor(c("missing", "missing (NA)", "missing (NA).1", NA, NA))
  table <- report_table(x)
  labels <- as.character(table$Level)

  expect_identical(anyDuplicated(labels), 0L)
  expect_true(all(levels(x) %in% labels))
  expect_length(setdiff(labels, levels(x)), 1L)
  expect_identical(table$n_Obs, c(1L, 1L, 1L, 2L))
})

test_that("factor text counts original levels", {
  expect_match(
    as.character(report(factor(c("missing", "a")))),
    "2 levels, namely",
    fixed = TRUE
  )
  expect_match(
    as.character(report(factor("missing"))),
    "1 level, namely",
    fixed = TRUE
  )
  expect_match(
    as.character(report(factor(c("a", NA)))),
    "1 level, namely",
    fixed = TRUE
  )
  expect_match(
    as.character(report(factor(c("missing", NA), levels = c("a", "missing")))),
    "2 levels, namely",
    fixed = TRUE
  )
})

test_that("factor summaries select percentages automatically", {
  for (size in c(99L, 100L)) {
    x <- factor(rep_len(c("A", "B", NA), size))
    percentage <- size >= 100L

    expect_identical(
      summary(report_parameters(x)),
      summary(report_parameters(x, levels_percentage = percentage))
    )
    expect_identical(
      summary(report_statistics(x)),
      summary(report_statistics(x, levels_percentage = percentage))
    )
    expect_identical(
      as.character(summary(report(x))),
      as.character(summary(report(x, levels_percentage = percentage)))
    )
    expect_identical(
      summary(report_table(x)),
      summary(report_table(x, levels_percentage = percentage))
    )
  }
})
