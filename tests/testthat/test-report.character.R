test_that("character reports can show all entries", {
  x <- c("first", "first", "second", "third", "fourth", NA)

  result <- report(x, n_entries = "all")
  expected <- report(x, n_entries = 4)

  expect_identical(as.character(result), as.character(expected))
  expect_identical(as.character(summary(result)), as.character(summary(expected)))
  expect_match(as.character(result), "fourth (n = 1)", fixed = TRUE)
  expect_false(grepl("other", as.character(result), fixed = TRUE))

  expect_identical(
    as.character(summary(report_parameters(x, n_entries = "all"))),
    as.character(summary(report_parameters(x, n_entries = 4)))
  )
  expect_identical(
    as.character(summary(report_statistics(x, n_entries = "all"))),
    as.character(summary(report_statistics(x, n_entries = 4)))
  )
})

test_that("zero character entries produces empty summaries", {
  x <- c("first", "second", "third")

  expect_length(summary(report_parameters(x, n_entries = 0)), 0)
  expect_identical(as.character(summary(report_statistics(x, n_entries = 0))), "")
})
