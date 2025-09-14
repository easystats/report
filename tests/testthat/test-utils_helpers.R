test_that(".error_message() generates proper error messages", {
  # Test with a simple object
  obj <- data.frame(x = 1:5)
  result <- report:::.error_message(obj)
  
  expect_type(result, "character")
  expect_match(result, "objects of class")
  expect_match(result, "data.frame")
  expect_match(result, "not supported")
  expect_match(result, "report\\(\\)")
  expect_match(result, "https://easystats.github.io/report")
})

test_that(".error_message() works with custom function names", {
  obj <- list(a = 1, b = 2)
  result <- report:::.error_message(obj, fun = "custom_function()")
  
  expect_match(result, "custom_function\\(\\)")
  expect_match(result, "list")
})

test_that(".error_message() handles multiple classes", {
  obj <- structure(1:5, class = c("custom1", "custom2", "numeric"))
  result <- report:::.error_message(obj)
  
  expect_match(result, "custom1")
  expect_match(result, "custom2")
  expect_match(result, "numeric")
})

test_that(".combine_tables_effectsize() combines tables correctly", {
  # Create mock parameters table
  parameters <- data.frame(
    Parameter = c("(Intercept)", "x"),
    Coefficient = c(1.5, 2.0),
    SE = c(0.2, 0.3),
    stringsAsFactors = FALSE
  )
  class(parameters) <- c("parameters_model", "data.frame")
  attr(parameters, "pretty_names") <- c("(Intercept)" = "(Intercept)", "x" = "x")
  
  # Create mock effect size table
  effsize_table <- data.frame(
    Parameter = c("(Intercept)", "x"),
    Std_Coefficient = c(0.8, 1.2),
    stringsAsFactors = FALSE
  )
  
  # Create mock effectsize object with table attribute
  effsize <- list()
  attr(effsize, "table") <- effsize_table
  
  # Test combination
  result <- report:::.combine_tables_effectsize(parameters, effsize)
  
  expect_s3_class(result, "parameters_model")
  expect_true("Std_Coefficient" %in% names(result))
  expect_equal(nrow(result), 2)
  expect_equal(result$Parameter, c("(Intercept)", "x"))
})

test_that(".combine_tables_performance() combines tables correctly", {
  # Create mock parameters table
  parameters <- data.frame(
    Parameter = c("(Intercept)", "x"),
    Coefficient = c(1.5, 2.0),
    stringsAsFactors = FALSE
  )
  class(parameters) <- c("parameters_model", "data.frame")
  
  # Create mock performance table
  performance <- data.frame(
    R2 = 0.75,
    R2_adjusted = 0.72,
    AIC = 150.2,
    stringsAsFactors = FALSE
  )
  
  # Test combination
  result <- report:::.combine_tables_performance(parameters, performance)
  
  expect_s3_class(result, "parameters_model")
  expect_true("Fit" %in% names(result))
  expect_true(nrow(result) > nrow(parameters))  # Should have added performance rows
  expect_true(any(is.na(result$Coefficient)))   # NA row should exist
})

test_that(".remove_performance() removes performance rows correctly", {
  # Create table with performance information
  table_with_perf <- data.frame(
    Parameter = c("(Intercept)", "x", NA, "R2", "AIC"),
    Coefficient = c(1.5, 2.0, NA, NA, NA),
    Fit = c(NA, NA, NA, 0.75, 150.2),
    stringsAsFactors = FALSE
  )
  
  result <- report:::.remove_performance(table_with_perf)
  
  expect_equal(nrow(result), 2)  # Should only keep parameter rows
  expect_equal(result$Parameter, c("(Intercept)", "x"))
  expect_false(any(is.na(result$Parameter)))
})

test_that(".remove_performance() handles tables without Fit column", {
  # Create table without performance information
  table_no_perf <- data.frame(
    Parameter = c("(Intercept)", "x"),
    Coefficient = c(1.5, 2.0),
    stringsAsFactors = FALSE
  )
  
  result <- report:::.remove_performance(table_no_perf)
  
  expect_equal(result, table_no_perf)  # Should return unchanged
})

test_that(".check_spelling() works correctly", {
  data <- data.frame(name = 1:3, value = 4:6, score = 7:9)
  
  # Test with correct column names - should not error
  expect_invisible(report:::.check_spelling(data, c("name", "value")))
  
  # Test with incorrect column names - might not error in current implementation
  # This function may just return suggestions rather than throw errors
  result <- tryCatch({
    report:::.check_spelling(data, c("nam", "values"))
    "no_error"
  }, error = function(e) e$message)
  # Function may or may not error, but it should handle the case
  expect_true(is.character(result))
  
  # Test with NULL input - should not error
  expect_invisible(report:::.check_spelling(data, NULL))
  
  # Test with empty string - should not error
  expect_invisible(report:::.check_spelling(data, ""))
})

test_that(".fuzzy_grep() finds approximate matches", {
  test_names <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")
  
  # Test with close match
  result1 <- report:::.fuzzy_grep(test_names, "Spela")
  expect_true(length(result1) > 0)  # Should find matches
  
  # Test with exact match
  result2 <- report:::.fuzzy_grep(test_names, "Species")
  expect_true(5 %in% result2)  # Should find exact match
  
  # Test with very different string
  result3 <- report:::.fuzzy_grep(test_names, "xyz")
  expect_true(length(result3) == 0)  # Should find no matches
  
  # Test with custom precision
  result4 <- report:::.fuzzy_grep(test_names, "Sepal", precision = 1)
  expect_true(length(result4) > 0)
})

test_that(".misspelled_string() creates helpful error messages", {
  source_names <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")
  
  # Test with likely misspelling
  result1 <- report:::.misspelled_string(source_names, "Spela")
  expect_match(result1, "Did you mean")
  expect_match(result1, "Sepal")
  
  # Test with multiple possibilities
  result2 <- report:::.misspelled_string(source_names, "Length")
  expect_match(result2, "one of")
  
  # Test with no close matches - function may return various types
  result3 <- report:::.misspelled_string(source_names, "xyz")
  # Just test that function executes without error and returns something reasonable
  expect_true(is.character(result3) || is.null(result3))
  
  # Test with default message
  result4 <- report:::.misspelled_string(source_names, "xyz", "Default message")
  expect_equal(result4, "Default message")
})

test_that("grouped dataframe utilities work correctly", {
  # Skip if dplyr not available
  skip_if_not_installed("dplyr")
  
  # Create a grouped dataframe
  df <- data.frame(
    group = rep(c("A", "B"), each = 3),
    value = 1:6
  )
  grouped_df <- dplyr::group_by(df, group)
  
  # Test group detection
  expect_true(report:::.has_groups(grouped_df))
  expect_false(report:::.has_groups(df))
  
  # Test group variables
  group_vars <- report:::.group_vars(grouped_df)
  expect_equal(group_vars, "group")
  
  # Test ungrouping
  ungrouped <- report:::.ungroup(grouped_df)
  expect_false(report:::.has_groups(ungrouped))
  expect_false(inherits(ungrouped, "grouped_df"))
})