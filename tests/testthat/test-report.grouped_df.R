test_that("reports combine multiple grouping variables in a single introduction", {
  skip_if_not_installed("dplyr")

  data <- data.frame(
    site = rep(c("north", "south"), each = 4),
    visit = rep(rep(c("before", "after"), each = 2), 2),
    score = 1:8,
    stringsAsFactors = FALSE
  )
  grouped <- dplyr::group_by(data, site, visit)

  text <- report_text(grouped)
  result <- report(grouped)
  expect_length(text, 1)
  expect_length(summary(text), 1)
  expect_length(result, 1)
  expect_length(summary(result), 1)

  intro <- paste(
    "The data contains 8 observations, grouped by site and visit,",
    "of the following 3 variables:"
  )
  for (output in c(as.character(result), as.character(summary(result)))) {
    expect_true(startsWith(output, intro))
    for (group in c("north - before", "north - after", "south - before", "south - after")) {
      header <- paste0("- ", group, " (n = 2):")
      expect_length(regmatches(output, gregexpr(header, output, fixed = TRUE))[[1]], 1)
    }
  }
})

test_that("single grouping variable introductions are unchanged", {
  skip_if_not_installed("dplyr")

  data <- data.frame(
    site = rep(c("north", "south"), each = 4),
    score = 1:8,
    stringsAsFactors = FALSE
  )
  result <- report(dplyr::group_by(data, site))

  expect_length(result, 1)
  expect_length(summary(result), 1)
  intro <- paste(
    "The data contains 8 observations, grouped by site,",
    "of the following 2 variables:"
  )
  expect_true(startsWith(as.character(result), intro))
  expect_true(startsWith(as.character(summary(result)), intro))
})
