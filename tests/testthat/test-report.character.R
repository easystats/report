test_that("character reports can show all entries", {
  x <- c("first", "first", "second", "third", "fourth", NA)

  result <- report(x, n_entries = "all")
  expected <- report(x, n_entries = 4)

  expect_identical(as.character(result), as.character(expected))
  expect_identical(
    as.character(summary(result)),
    as.character(summary(expected))
  )
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
  expect_identical(
    as.character(summary(report_statistics(x, n_entries = 0))),
    ""
  )

  result <- report(x, n_entries = 0, varname = "labels")
  expect_identical(as.character(result), "labels: 3 entries (0 missing)")
  expect_identical(as.character(summary(result)), "labels: 3 entries")
})

test_that("character reports handle no observed entries", {
  for (x in list(character(), rep(NA_character_, 2))) {
    for (n_entries in list(3, "all")) {
      result <- report(x, n_entries = n_entries, varname = "labels")
      table <- as.report_table(result)

      expect_identical(table$n_Entries, 0L)
      expect_identical(table$n_Obs, length(x))
      expect_identical(table$n_Missing, length(x))
      expect_identical(
        as.character(result),
        paste0("labels: 0 entries (", length(x), " missing)")
      )
      expect_length(report_parameters(x, n_entries = n_entries), 0)
      expect_identical(
        as.character(report_statistics(x, n_entries = n_entries)),
        ""
      )
    }
  }
})
