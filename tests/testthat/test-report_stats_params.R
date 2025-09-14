test_that("report_statistics() works with linear models", {
  model <- lm(Sepal.Length ~ Species, data = iris)

  result <- report_statistics(model)

  expect_s3_class(result, "report_statistics")
  expect_type(result, "character")
  # Just check that it's not empty, not specific length
  expect_true(length(result) > 0)
})

test_that("report_statistics() works with t-test", {
  test_result <- t.test(iris$Sepal.Width, iris$Sepal.Length)

  result <- report_statistics(test_result)

  expect_s3_class(result, "report_statistics")
  expect_type(result, "character")
})

test_that("report_statistics() works with ANOVA", {
  aov_result <- aov(Sepal.Length ~ Species, data = iris)

  result <- report_statistics(aov_result)

  expect_s3_class(result, "report_statistics")
  expect_type(result, "character")
})

test_that("report_statistics() works with basic data types", {
  # Character vector
  char_data <- c("red", "blue", "red", "green")
  result1 <- report_statistics(char_data)
  expect_s3_class(result1, "report_statistics")
  expect_match(as.character(result1), "red")

  # Factor
  factor_data <- factor(c("low", "medium", "high", "low"))
  result2 <- report_statistics(factor_data)
  expect_s3_class(result2, "report_statistics")
  expect_match(as.character(result2), "low")
})

test_that("as.report_statistics() works correctly", {
  text_stats <- "Mean = 5.0, SD = 1.2"
  summary_stats <- "Mean = 5.0"

  result <- as.report_statistics(text_stats, summary = summary_stats)

  expect_s3_class(result, "report_statistics")
  expect_equal(as.character(result), text_stats)
  expect_equal(as.character(summary(result)), summary_stats)
})

test_that("report_statistics methods work", {
  text_stats <- "Test statistics"
  result <- as.report_statistics(text_stats)

  # Test summary (should return itself if no summary attribute)
  summ <- summary(result)
  expect_equal(summ, result)

  # Test print
  expect_output(print(result), "Test statistics")
})

test_that("report_parameters() works with linear models", {
  model <- lm(Sepal.Length ~ Species, data = iris)

  result <- report_parameters(model)

  expect_s3_class(result, "report_parameters")
  expect_type(result, "character")
  expect_true(nchar(as.character(result)) > 0)
})

test_that("report_parameters() works with t-test", {
  test_result <- t.test(iris$Sepal.Width, iris$Sepal.Length)

  result <- report_parameters(test_result)

  expect_s3_class(result, "report_parameters")
  expect_type(result, "character")
})

test_that("report_parameters() works with basic data types", {
  # Character vector
  char_data <- c("red", "blue", "red", "green", "blue")
  result1 <- report_parameters(char_data)
  expect_s3_class(result1, "report_parameters")
  expect_match(as.character(result1), "red")

  # Factor
  factor_data <- factor(c("A", "B", "A", "C"))
  result2 <- report_parameters(factor_data)
  expect_s3_class(result2, "report_parameters")
  expect_match(as.character(result2), "A")
})

test_that("as.report_parameters() works correctly", {
  params_text <- c("Parameter A = 1.5", "Parameter B = 2.0")
  summary_text <- c("A = 1.5", "B = 2.0")

  result <- as.report_parameters(params_text, summary = summary_text)

  expect_s3_class(result, "report_parameters")
  expect_true(all(grepl("Parameter", as.character(result))))
  expect_true(all(grepl("A|B", as.character(summary(result)))))
})

test_that("report_parameters methods work", {
  params_text <- "Test parameters"
  result <- as.report_parameters(params_text)

  # Test summary
  summ <- summary(result)
  expect_equal(summ, result) # Should return itself if no summary

  # Test print
  expect_output(print(result), "Test parameters")
})
