test_that("report_info() works for linear models", {
  model <- lm(Sepal.Length ~ Species, data = iris)

  result <- report_info(model)

  expect_s3_class(result, "report_info")
  expect_type(result, "character")

  # Test print method
  expect_output(print(result))
})

test_that("report_info() works for t-test", {
  test_result <- t.test(iris$Sepal.Width, iris$Sepal.Length)

  result <- report_info(test_result)

  expect_s3_class(result, "report_info")
  expect_type(result, "character")
})

test_that("report_info() works for ANOVA", {
  aov_result <- aov(Sepal.Length ~ Species, data = iris)

  result <- report_info(aov_result)

  expect_s3_class(result, "report_info")
  expect_type(result, "character")
})

test_that("as.report_info() creates proper objects", {
  text_info <- "Some information about the model"
  summary_text <- "Short info"

  result <- as.report_info(text_info, summary = summary_text)

  expect_s3_class(result, "report_info")
  expect_identical(as.character(result), text_info)
  expect_identical(as.character(summary(result)), summary_text)
})

test_that("as.report_info() handles NULL summary", {
  text_info <- "Some information"

  result <- as.report_info(text_info)

  expect_s3_class(result, "report_info")
  expect_identical(summary(result), result) # Should return itself if no summary
})

test_that(".info_df() helper function works", {
  # Test basic CI info
  result1 <- report:::.info_df(ci = 0.95, ci_method = "normal")
  expect_type(result1, "character")
  expect_match(result1, "95%")
  expect_match(result1, "Confidence Intervals")
  expect_match(result1, "Wald normal")

  # Test with NULL ci_method
  result2 <- report:::.info_df(ci = 0.95, ci_method = NULL)
  expect_identical(result2, "")

  # Test with bootstrap
  result3 <- report:::.info_df(ci = 0.90, ci_method = "boot", bootstrap = TRUE)
  expect_match(result3, "90%")
  expect_match(result3, "parametric bootstrap")
  expect_match(result3, "intervals")

  # Test with different methods
  result4 <- report:::.info_df(ci = 0.95, ci_method = "bci")
  expect_match(result4, "bias-corrected accelerated bootstrap")
})

test_that(".info_effectsize() helper function works", {
  # Mock effectsize object
  mock_effectsize <- list()
  attr(mock_effectsize, "method") <- "Cohen's d"
  attr(mock_effectsize, "rules") <- "Effect sizes interpreted following Cohen (1988)."

  # Test basic usage
  result1 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = FALSE)
  expect_identical(result1, "Cohen's d")

  # Test with include_effectsize = TRUE
  result2 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expect_match(result2, "Cohen's d")
  expect_match(result2, "interpreted following")

  # Test with NULL effectsize
  result3 <- report:::.info_effectsize(NULL, effectsize = NULL, include_effectsize = FALSE)
  expect_identical(result3, "")
})

test_that("report_date() works correctly", {
  result <- report_date()

  expect_s3_class(result, "report_text")
  expect_type(result, "character")
  expect_match(as.character(result), "It's")
  expect_match(as.character(result), "year")

  # Test summary
  summary_result <- summary(result)
  expect_match(as.character(summary_result), "\\d+/\\d+/\\d+") # Date format
  expect_match(as.character(summary_result), "\\d+:\\d+:\\d+") # Time format
})

test_that("report_story() works correctly", {
  result <- report_story()

  expect_s3_class(result, "report_text")
  expect_type(result, "character")
  expect_match(as.character(result), "Darth Plagueis")
  expect_match(as.character(result), "Sith legend")
  expect_match(as.character(result), "Ironic")

  # Test summary
  summary_result <- summary(result)
  expect_match(as.character(summary_result), "thunderous applause")
})

test_that("report_text() works with sessionInfo", {
  si <- sessionInfo()

  result <- report_text(si)

  expect_s3_class(result, "report_text")
  expect_type(result, "character")
})

test_that("as.report_text() works correctly", {
  # Test basic usage
  text_content <- "This is some report text"
  summary_text <- "Short summary"

  result <- as.report_text(text_content, summary = summary_text)

  expect_s3_class(result, "report_text")
  expect_identical(as.character(result), text_content)
  expect_identical(as.character(summary(result)), summary_text)

  # Test with NULL summary
  result2 <- as.report_text(text_content)
  expect_identical(summary(result2), result2) # Should return itself
})

test_that("as.report_text.report() works correctly", {
  # Create a mock report object
  mock_report <- structure(
    list(text = "Full report text", summary = "Short summary"),
    class = c("report", "list")
  )

  # Test with summary = FALSE
  result1 <- as.report_text(mock_report, summary = FALSE)
  expect_false(inherits(result1, "report"))

  # Test with summary = TRUE would require a proper report object with summary method
})

test_that("print.report_text() works correctly", {
  text_content <- "This is a test report text that should be printed nicely."
  report_obj <- as.report_text(text_content)

  # Test that it prints without error
  expect_output(print(report_obj), "test report text")
})
