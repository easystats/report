test_that("report.character() works correctly", {
  # Test basic character vector
  char_data <- c("red", "blue", "red", "green", "blue", "red")

  result <- report(char_data)

  expect_s3_class(result, "report")
  expect_type(result, "character") # report objects are character type

  # Check that it contains the expected components
  expect_match(as.character(result), "entries")
  expect_match(as.character(result), "red")

  # Check table
  table_result <- as.data.frame(result)
  expect_s3_class(table_result, "data.frame")
  expect_true("n_Entries" %in% names(table_result))
  expect_true("n_Obs" %in% names(table_result))
})

test_that("report.character() handles missing values", {
  char_data <- c("red", "blue", NA, "green", "blue", "red", NA)

  result <- report(char_data)

  expect_match(as.character(result), "missing")

  # Check table contains missing info
  table_result <- as.data.frame(result)
  expect_gt(table_result$n_Missing[1], 0)
})

test_that("report.character() respects parameters", {
  char_data <- c(
    "red",
    "blue",
    "red",
    "green",
    "blue",
    "red",
    "yellow",
    "orange"
  )

  # Test with different n_entries
  result1 <- report(char_data, n_entries = 2)
  expect_match(as.character(result1), "others")

  # Test with levels_percentage
  result2 <- report(char_data, levels_percentage = TRUE)
  expect_match(as.character(result2), "%")

  result3 <- report(char_data, levels_percentage = FALSE)
  expect_match(as.character(result3), "n =")
})

test_that("report.factor() works correctly", {
  # Test basic factor
  factor_data <- factor(c("low", "medium", "high", "low", "medium", "high"))

  result <- report(factor_data)

  expect_s3_class(result, "report")
  expect_match(as.character(result), "levels")
  expect_match(as.character(result), "low")
  expect_match(as.character(result), "medium")
  expect_match(as.character(result), "high")

  # Check table
  table_result <- as.data.frame(result)
  expect_s3_class(table_result, "data.frame")
  expect_true("Level" %in% names(table_result))
  expect_true("n_Obs" %in% names(table_result))
})

test_that("report.factor() handles missing values", {
  factor_data <- factor(c("low", NA, "medium", "high", "low", NA, "medium"))

  result <- report(factor_data)

  expect_match(as.character(result), "missing")

  # Check table includes missing level
  table_result <- as.data.frame(result)
  expect_true("missing" %in% table_result$Level)
})

test_that("report.factor() works with logical vectors", {
  logical_data <- c(TRUE, FALSE, TRUE, TRUE, FALSE)

  result <- report(logical_data)

  expect_s3_class(result, "report")
  expect_match(as.character(result), "levels")
  expect_match(as.character(result), "TRUE|FALSE")
})

test_that("report.factor() respects levels_percentage parameter", {
  factor_data <- factor(c("A", "B", "A", "B", "A"))

  result_perc <- report(factor_data, levels_percentage = TRUE)
  expect_match(as.character(result_perc), "%")

  result_count <- report(factor_data, levels_percentage = FALSE)
  expect_match(as.character(result_count), "n =")
})

test_that("report.default() methods throw appropriate errors", {
  # Test with unsupported object
  unsupported_obj <- structure(list(x = 1), class = "unsupported_class")

  expect_error(
    report(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_table(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_parameters(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_statistics(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_effectsize(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_model(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_random(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_priors(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_performance(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_info(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_text(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
  expect_error(
    report_intercept(unsupported_obj),
    "objects of class.*unsupported_class.*not supported"
  )
})

test_that("report component functions work for character vectors", {
  char_data <- c("red", "blue", "red", "green", "blue", "red")

  # Test report_table
  table_result <- report_table(char_data)
  expect_s3_class(table_result, "report_table")
  expect_true("n_Entries" %in% names(table_result))

  # Test report_parameters
  params_result <- report_parameters(char_data)
  expect_s3_class(params_result, "report_parameters")

  # Test report_text
  text_result <- report_text(char_data)
  expect_s3_class(text_result, "report_text")
  expect_match(as.character(text_result), "char_data") # Variable name, not "Character variable"

  # Test report_statistics
  stats_result <- report_statistics(char_data)
  expect_s3_class(stats_result, "report_statistics")
})

test_that("report component functions work for factor vectors", {
  factor_data <- factor(c("low", "medium", "high", "low", "medium"))

  # Test report_table
  table_result <- report_table(factor_data)
  expect_s3_class(table_result, "report_table")
  expect_true("Level" %in% names(table_result))

  # Test report_parameters
  params_result <- report_parameters(factor_data)
  expect_s3_class(params_result, "report_parameters")

  # Test report_text
  text_result <- report_text(factor_data)
  expect_s3_class(text_result, "report_text")
  expect_match(as.character(text_result), "factor_data") # Variable name, not "Factor"

  # Test report_statistics
  stats_result <- report_statistics(factor_data)
  expect_s3_class(stats_result, "report_statistics")
})
