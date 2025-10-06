test_that("report_table() works with sessionInfo", {
  si <- sessionInfo()

  result <- report_table(si)

  expect_s3_class(result, "report_table")
  expect_s3_class(result, "data.frame")

  # Should have some basic information about the session
  expect_gt(nrow(result), 0)
})

test_that("report_table() works with basic data types", {
  # Numeric vector
  numeric_data <- iris$Sepal.Length
  result1 <- report_table(numeric_data)
  expect_s3_class(result1, "report_table")

  # Character vector
  char_data <- as.character(round(iris$Sepal.Length, 1))
  result2 <- report_table(char_data)
  expect_s3_class(result2, "report_table")
  expect_true("n_Entries" %in% names(result2))

  # Factor
  factor_data <- iris$Species
  result3 <- report_table(factor_data)
  expect_s3_class(result3, "report_table")
  expect_true("Level" %in% names(result3))
})

test_that("report_table() works with data frames", {
  result <- report_table(iris)

  expect_s3_class(result, "report_table")
  expect_s3_class(result, "data.frame")
  expect_gt(nrow(result), 0)
})

test_that("report_table() works with statistical tests", {
  # t-test
  test_result <- t.test(mtcars$mpg ~ mtcars$am)
  result1 <- report_table(test_result)
  expect_s3_class(result1, "report_table")

  # ANOVA
  aov_result <- aov(Sepal.Length ~ Species, data = iris)
  result2 <- report_table(aov_result)
  expect_s3_class(result2, "report_table")
})

test_that("report_table() works with linear models", {
  # Simple linear model
  model1 <- lm(Sepal.Length ~ Petal.Length, data = iris)
  result1 <- report_table(model1)
  expect_s3_class(result1, "report_table")
  expect_true("Parameter" %in% names(result1) || "Coefficient" %in% names(result1))

  # Interaction model
  model2 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
  result2 <- report_table(model2)
  expect_s3_class(result2, "report_table")

  # GLM
  model3 <- glm(vs ~ disp, data = mtcars, family = "binomial")
  result3 <- report_table(model3)
  expect_s3_class(result3, "report_table")
})

test_that("as.report_table() works correctly", {
  # Create a data frame to convert
  df <- data.frame(
    Parameter = c("A", "B"),
    Value = c(1, 2),
    stringsAsFactors = FALSE
  )

  result <- as.report_table(df)
  expect_s3_class(result, "report_table")
  expect_s3_class(result, "data.frame")
  expect_identical(nrow(result), 2L)
  expect_identical(result$Parameter, c("A", "B"))
})

test_that("report_table methods work correctly", {
  # Create a simple report table
  df <- data.frame(x = 1:3, y = 4:6)
  result <- as.report_table(df)

  # Test summary
  summ <- summary(result)
  expect_s3_class(summ, "report_table")

  # Test print (should not error)
  expect_output(print(result))
})

test_that("report_table advanced methods work", {
  # Test as.report_table with summary
  df <- data.frame(Parameter = c("A", "B"), Value = c(1, 2))
  summary_df <- data.frame(Parameter = c("A"), Value = c(1.5))
  
  result_with_summary <- as.report_table(df, summary = summary_df)
  expect_s3_class(result_with_summary, "report_table")
  
  summ <- summary(result_with_summary)
  expect_s3_class(summ, "report_table")
  expect_identical(nrow(summ), 1L)
  
  # Test as.report_table with as_is parameter
  result_as_is <- as.report_table(df, as_is = TRUE)
  expect_s3_class(result_as_is, "report_table")
  
  # Test c.report_table method (concatenation)
  df1 <- as.report_table(data.frame(x = 1:2, y = 3:4))
  df2 <- as.report_table(data.frame(x = 5:6, y = 7:8))
  combined <- c(df1, df2)
  expect_s3_class(combined, "report_table")
  expect_identical(nrow(combined), 4L)
})

test_that("report_table formatting and printing work", {
  # Create table with Method and Alternative columns to test removal
  df <- data.frame(
    Parameter = "test",
    Coefficient = 1.5,
    Method = "Test Method",
    Alternative = "two.sided",
    null.value = 0
  )
  result <- as.report_table(df)
  
  # Test formatting removes unwanted columns
  formatted <- format(result)
  expect_false("Method" %in% names(formatted))
  expect_false("Alternative" %in% names(formatted))
  
  # Test print with caption and footer
  expect_output(print(result), "Test Method")
  
  # Test table footer creation
  footer_result <- report:::.report_table_footer(df)
  expect_type(footer_result, "character")
  expect_length(footer_result, 2)
  
  # Test caption creation
  caption_result <- report:::.report_table_caption(df)
  expect_identical(caption_result, "Test Method")
})

test_that("report_table edge cases for footer and caption", {
  # Test footer with different alternatives
  df_less <- data.frame(Alternative = "less", null.value = 0)
  names(df_less$null.value) <- "mean"
  footer_less <- report:::.report_table_footer(df_less)
  expect_match(footer_less[1], "less than")
  
  df_greater <- data.frame(Alternative = "greater", null.value = 0)
  names(df_greater$null.value) <- "mean"
  footer_greater <- report:::.report_table_footer(df_greater)
  expect_match(footer_greater[1], "greater than")
  
  # Test with multiple null values
  df_multi <- data.frame(Alternative = "two.sided", null.value = c(0, 1))
  footer_multi <- report:::.report_table_footer(df_multi)
  expect_match(footer_multi[1], "two.sided")
  
  # Test without Method
  df_no_method <- data.frame(Parameter = "test", Value = 1)
  caption_none <- report:::.report_table_caption(df_no_method)
  expect_null(caption_none)
})

test_that("as.report_table.report works correctly", {
  # Create a mock report object
  mock_table <- data.frame(Parameter = "test", Value = 1)
  class(mock_table) <- c("report_table", "data.frame")
  
  mock_summary <- data.frame(Parameter = "test", Summary_Value = 0.5)
  class(mock_summary) <- c("report_table", "data.frame")
  attr(mock_table, "summary") <- mock_summary
  
  mock_report <- structure(
    "Mock report text",
    table = mock_table,
    class = "report"
  )
  
  # Test extracting table
  result_table <- as.report_table(mock_report, summary = FALSE)
  expect_s3_class(result_table, "report_table")
  
  # Test extracting summary
  result_summary <- as.report_table(mock_report, summary = TRUE)
  expect_s3_class(result_summary, "report_table")
  expect_identical(nrow(result_summary), 1L)
})
