test_that("brmsfit report_text method prevents duplication", {
  skip_if_not_installed("brms")
  
  # Test that the report_text.brmsfit method exists and is properly registered
  expect_true("report_text.brmsfit" %in% methods("report_text"))
  
  # If brms is available, test the actual functionality
  if (requireNamespace("brms", quietly = TRUE)) {
    skip_if_not_installed("rstan", "2.26.0")
    
    # Create a simple brms model for testing
    set.seed(333)
    model <- suppressMessages(suppressWarnings(brms::brm(
      mpg ~ wt,
      data = mtcars, 
      refresh = 0, 
      iter = 200, 
      chains = 1,
      seed = 333
    )))
    
    # Test that report_text works without errors
    text_result <- report_text(model)
    expect_s3_class(text_result, "report_text")
    
    # Test that the text content is reasonable (not empty, not duplicated)
    text_content <- as.character(text_result)
    expect_true(length(text_content) == 1)
    expect_true(nchar(text_content) > 100)  # Should have substantial content
    
    # Test that full report works without duplication
    full_report <- report(model)
    expect_s3_class(full_report, "report")
    
    # Verify the text doesn't contain obvious duplication patterns
    full_text <- as.character(full_report)
    text_lines <- strsplit(full_text, "\n")[[1]]
    
    # Check that we don't have identical consecutive lines (which would indicate duplication)
    consecutive_identical <- FALSE
    for (i in 1:(length(text_lines) - 1)) {
      if (text_lines[i] == text_lines[i + 1] && nchar(text_lines[i]) > 10) {
        consecutive_identical <- TRUE
        break
      }
    }
    expect_false(consecutive_identical, "Report text contains consecutive identical lines")
  }
})

test_that("brmsfit report_text method maintains backward compatibility", {
  # Test that the new method doesn't break when called on non-brms objects
  # (in case of method dispatch issues)
  
  model_lm <- lm(mpg ~ wt + hp, data = mtcars)
  
  # This should still work with regular lm models
  text_result <- report_text(model_lm)
  expect_s3_class(text_result, "report_text")
  
  # Verify that lm functionality is unchanged
  text_content <- as.character(text_result)
  expect_true(grepl("linear model", text_content))
  expect_true(grepl("Within this model:", text_content))
})