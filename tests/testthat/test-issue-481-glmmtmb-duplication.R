test_that("issue #481 - no text duplication in gsub pattern", {
  # Test the .info_effectsize function directly to ensure the regex fix works
  # This tests the specific fix for the duplicated text issue
  
  # Mock effectsize object with attributes that could trigger the bug
  mock_effectsize <- list()
  
  # Test case 1: Correct replacement with literal period
  attr(mock_effectsize, "method") <- "Standardized parameters were obtained by fitting the model on a standardized version of the dataset."
  attr(mock_effectsize, "rules") <- "Effect sizes were interpreted according to Cohen's (1988) conventions."
  
  result1 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expected1 <- "Standardized parameters were obtained by fitting the model on a standardized version of the dataset. and were interpreted according to Cohen's (1988) conventions."
  expect_equal(result1, expected1)
  
  # Test case 2: Should NOT replace when there's no literal period before "Effect sizes"
  attr(mock_effectsize, "method") <- "Standardized parameters were obtained by fitting the model"
  attr(mock_effectsize, "rules") <- " Effect sizes were interpreted according to Cohen's (1988) conventions."
  
  result2 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expected2 <- "Standardized parameters were obtained by fitting the model Effect sizes were interpreted according to Cohen's (1988) conventions."
  expect_equal(result2, expected2)
  
  # Test case 3: Edge case - text that might have caused the original bug  
  # Before the fix, ".Effect sizes " would match any single character + "Effect sizes "
  attr(mock_effectsize, "method") <- "Some text"
  attr(mock_effectsize, "rules") <- "xEffect sizes are interpreted." # This should NOT be replaced
  
  result3 <- report:::.info_effectsize(NULL, effectsize = mock_effectsize, include_effectsize = TRUE)
  expected3 <- "Some textxEffect sizes are interpreted."
  expect_equal(result3, expected3)
})

test_that("gsub regex pattern is correctly escaped", {
  # Direct test of the regex pattern to ensure it only matches literal periods
  
  # Test strings that should be replaced (literal period)
  test_string1 <- "Some text.Effect sizes follow Cohen's recommendations."
  result1 <- gsub("\\.Effect sizes ", " and ", test_string1)
  expect_equal(result1, "Some text and follow Cohen's recommendations.")
  
  # Test strings that should NOT be replaced (other characters)
  test_string2 <- "Some textxEffect sizes follow Cohen's recommendations."
  result2 <- gsub("\\.Effect sizes ", " and ", test_string2)
  expect_equal(result2, test_string2)  # Should remain unchanged
  
  test_string3 <- "Some text Effect sizes follow Cohen's recommendations."
  result3 <- gsub("\\.Effect sizes ", " and ", test_string3)  
  expect_equal(result3, test_string3)  # Should remain unchanged (space, not period)
})