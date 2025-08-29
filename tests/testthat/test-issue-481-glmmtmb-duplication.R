test_that("issue #481 - no text duplication in gsub pattern", {
  # Test the .info_effectsize function directly to ensure the regex fix works
  # This tests the specific fix for the duplicated text issue

  # Mock effectsize object with attributes that could trigger the bug
  mock_effectsize <- list()

  # Test case 1: Correct replacement with literal period
  attr(mock_effectsize, "method") <- paste0(
    "Standardized parameters were obtained by fitting the model ",
    "on a standardized version of the dataset."
  )
  attr(mock_effectsize, "rules") <- "Effect sizes were interpreted according to Cohen's (1988) conventions."

  result1 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expected1 <- paste0(
    "Standardized parameters were obtained by fitting the model ",
    "on a standardized version of the dataset and were interpreted ",
    "according to Cohen's (1988) conventions."
  )
  expect_identical(result1, expected1)

  # Test case 2: Should NOT replace when there's no literal period before "Effect sizes"
  attr(mock_effectsize, "method") <- "Standardized parameters were obtained by fitting the model"
  attr(mock_effectsize, "rules") <- " Effect sizes were interpreted according to Cohen's (1988) conventions."

  result2 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expected2 <- paste0(
    "Standardized parameters were obtained by fitting the model",
    " Effect sizes were interpreted according to Cohen's (1988) conventions."
  )
  expect_identical(result2, expected2)

  # Test case 3: Edge case - text that might have caused the original bug
  # Before the fix, ".Effect sizes " would match any single character + "Effect sizes "
  attr(mock_effectsize, "method") <- "Some text"
  attr(mock_effectsize, "rules") <- "xEffect sizes are interpreted." # This should NOT be replaced

  result3 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expected3 <- "Some textxEffect sizes are interpreted."
  expect_identical(result3, expected3)
})

test_that("gsub regex pattern is correctly escaped", {
  # Direct test of the regex pattern to ensure it only matches literal periods

  # Test strings that should be replaced (literal period followed by space)
  test_string1 <- "Some text.Effect sizes follow Cohen's recommendations."
  result1 <- gsub(pattern = "\\.Effect sizes ", replacement = " and ", x = test_string1, fixed = FALSE)
  expect_identical(result1, "Some text and follow Cohen's recommendations.")

  # Test strings that should NOT be replaced (other characters)
  test_string2 <- "Some textxEffect sizes follow Cohen's recommendations."
  result2 <- gsub(pattern = "\\.Effect sizes ", replacement = " and ", x = test_string2, fixed = FALSE)
  expect_identical(result2, test_string2) # Should remain unchanged

  test_string3 <- "Some text Effect sizes follow Cohen's recommendations."
  result3 <- gsub(pattern = "\\.Effect sizes ", replacement = " and ", x = test_string3, fixed = FALSE)
  expect_identical(result3, test_string3) # Should remain unchanged (space, not period)

  # Test the problematic case that could cause duplication
  problem_case <- "Standardized parameters were computed.Effect sizes were interpreted."
  fixed_result <- gsub(pattern = "\\.Effect sizes ", replacement = " and ", x = problem_case, fixed = FALSE)
  expect_identical(fixed_result, "Standardized parameters were computed and were interpreted.")

  # Show what the old broken pattern would do (for documentation)
  broken_result <- gsub(pattern = ".Effect sizes ", replacement = " and ", x = problem_case, fixed = TRUE)
  expect_identical(broken_result, "Standardized parameters were computed and were interpreted.")
  # Note: both should produce same result for this specific case, but old pattern
  # would incorrectly match other characters too
})

test_that("no redundant CI information concatenation in report_info.lm", {
  # Test that report_info.lm doesn't duplicate CI information when effectsize already contains it

  data(mtcars)
  model <- lm(mpg ~ hp + wt, data = mtcars)

  # Create mock effectsize object with CI information already included
  mock_effectsize <- structure(c(1, 2, 3), class = "effectsize_table")
  attr(mock_effectsize, "method") <- paste0(
    "Standardized parameters were obtained by fitting the model on a standardized version of the dataset. ",
    "95% Confidence Intervals (CIs) and p-values were computed using a Wald z-distribution approximation."
  )
  attr(mock_effectsize, "rules") <- "Effect sizes follow Cohen's conventions."

  # Get parameters to have proper attributes structure
  table <- report_table(model, include_effectsize = TRUE)
  params <- report_parameters(model, table = table)
  attributes(params)$effectsize <- mock_effectsize

  # Test report_info with the mock effectsize
  info_result <- report_info(model, effectsize = mock_effectsize, parameters = params, include_effectsize = TRUE)
  info_text <- as.character(info_result)

  # Should NOT contain duplicate CI descriptions
  ci_pattern_count <- length(gregexpr("Confidence Intervals.*computed using.*approximation", info_text)[[1]])
  expect_identical(
    ci_pattern_count, 1,
    info = paste("Expected 1 CI description, got", ci_pattern_count, "in text:", info_text)
  )

  # Should contain the z-distribution info from effectsize, not t-distribution
  expect_true(grepl("z-distribution approximation", info_text, fixed = TRUE))
  expect_false(grepl("t-distribution approximation", info_text, fixed = TRUE))

  # Should contain properly joined text with " and " from regex fix
  expect_true(grepl("approximation and follow", info_text, fixed = TRUE))
})
