test_that("glmmTMB duplication fix - parameters are deduplicated", {
  # Test that the fix for glmmTMB parameter duplication works correctly
  # This test reproduces the issue described in #551 and verifies the fix
  
  # Mock glmmTMB model
  mock_model <- structure(list(), class = c("glmmTMB", "lm"))
  
  # Create table with duplicated rows (simulating the problematic scenario)
  # This represents what might come from report_table for glmmTMB with duplicated parameters
  duplicated_table <- data.frame(
    Parameter = c("(Intercept)", "treatmentcontrol", "treatmentcontrol", "treatmentcontrol", "treatmentcontrol", "treatmentcontrol"),
    Component = c("cond", "cond", "cond", "cond", "cond", "cond"),
    Coefficient = c(0.13, -0.27, -0.27, -0.27, -0.27, -0.27),
    SE = c(0.25, 0.36, 0.36, 0.36, 0.36, 0.36),
    CI_low = c(-0.37, -0.99, -0.99, -0.99, -0.99, -0.99),
    CI_high = c(0.64, 0.45, 0.45, 0.45, 0.45, 0.45),
    t = c(0.52, -0.75, -0.75, -0.75, -0.75, -0.75),
    df_error = c(18, 18, 18, 18, 18, 18),
    p = c(0.606, 0.466, 0.466, 0.466, 0.466, 0.466),
    stringsAsFactors = FALSE
  )
  
  # Test report_parameters with duplicated table (this should be deduplicated)
  params_result <- report_parameters(mock_model, table = duplicated_table, include_intercept = FALSE)
  params_text <- as.character(params_result)
  
  # Count the number of parameter lines in the output
  lines <- trimws(strsplit(params_text, "\n")[[1]])
  non_empty_lines <- lines[nchar(lines) > 0]
  
  # Should have exactly 1 parameter line (not 5) after deduplication
  expect_equal(
    length(non_empty_lines),
    1L,
    info = paste("Expected 1 parameter line after deduplication, got", length(non_empty_lines), "lines:", paste(non_empty_lines, collapse = " | "))
  )
  
  # Verify the content is correct (contains the treatment parameter information)
  expect_true(
    grepl("beta = -0\\.27", params_text),
    info = paste("Expected to find treatment parameter (beta = -0.27) in:", params_text)
  )
  
  # Verify it's marked as non-significant and negative as expected
  expect_true(
    grepl("statistically non-significant and negative", params_text),
    info = paste("Expected to find significance interpretation in:", params_text)
  )
})

test_that("glmmTMB deduplication preserves unique parameters", {
  # Test that deduplication doesn't remove legitimately different parameters
  
  mock_model <- structure(list(), class = c("glmmTMB", "lm"))
  
  # Create table with different parameters (these should NOT be deduplicated)
  mixed_table <- data.frame(
    Parameter = c("(Intercept)", "treatmentcontrol", "covariate1"),
    Component = c("cond", "cond", "cond"),
    Coefficient = c(0.13, -0.27, 0.45),
    SE = c(0.25, 0.36, 0.20),
    CI_low = c(-0.37, -0.99, 0.05),
    CI_high = c(0.64, 0.45, 0.85),
    t = c(0.52, -0.75, 2.25),
    df_error = c(18, 18, 18),
    p = c(0.606, 0.466, 0.033),
    stringsAsFactors = FALSE
  )
  
  # Test report_parameters with mixed table
  params_result <- report_parameters(mock_model, table = mixed_table, include_intercept = FALSE)
  params_text <- as.character(params_result)
  
  # Count the number of parameter lines in the output
  lines <- trimws(strsplit(params_text, "\n")[[1]])
  non_empty_lines <- lines[nchar(lines) > 0]
  
  # Should have exactly 2 parameter lines (excluding intercept)
  expect_equal(
    length(non_empty_lines),
    2L,
    info = paste("Expected 2 parameter lines for different parameters, got", length(non_empty_lines), "lines:", paste(non_empty_lines, collapse = " | "))
  )
  
  # Verify both parameters are present
  expect_true(
    grepl("beta = -0\\.27", params_text),
    info = paste("Expected to find treatment parameter in:", params_text)
  )
  
  expect_true(
    grepl("beta = 0\\.45", params_text),
    info = paste("Expected to find covariate parameter in:", params_text)
  )
})

test_that("glmmTMB deduplication works without Component column", {
  # Test that the fix works for glmmTMB tables that don't have a Component column
  
  mock_model <- structure(list(), class = c("glmmTMB", "lm"))
  
  # Create table with duplicated rows but no Component column
  duplicated_table_no_component <- data.frame(
    Parameter = c("(Intercept)", "treatmentcontrol", "treatmentcontrol", "treatmentcontrol"),
    Coefficient = c(0.13, -0.27, -0.27, -0.27),
    SE = c(0.25, 0.36, 0.36, 0.36),
    CI_low = c(-0.37, -0.99, -0.99, -0.99),
    CI_high = c(0.64, 0.45, 0.45, 0.45),
    t = c(0.52, -0.75, -0.75, -0.75),
    df_error = c(18, 18, 18, 18),
    p = c(0.606, 0.466, 0.466, 0.466),
    stringsAsFactors = FALSE
  )
  
  # Test report_parameters with duplicated table (should be deduplicated)
  params_result <- report_parameters(mock_model, table = duplicated_table_no_component, include_intercept = FALSE)
  params_text <- as.character(params_result)
  
  # Count the number of parameter lines in the output
  lines <- trimws(strsplit(params_text, "\n")[[1]])
  non_empty_lines <- lines[nchar(lines) > 0]
  
  # Should have exactly 1 parameter line after deduplication
  expect_equal(
    length(non_empty_lines),
    1L,
    info = paste("Expected 1 parameter line after deduplication (no Component), got", length(non_empty_lines), "lines:", paste(non_empty_lines, collapse = " | "))
  )
  
  # Verify the content is correct
  expect_true(
    grepl("beta = -0\\.27", params_text),
    info = paste("Expected to find treatment parameter (beta = -0.27) in:", params_text)
  )
})

test_that("glmmTMB deduplication only applies to glmmTMB models", {
  # Test that deduplication logic only applies to glmmTMB models, not other models
  
  # Mock regular lm model (not glmmTMB)
  mock_lm <- structure(list(), class = "lm")
  
  # Create table with duplicated rows
  duplicated_table <- data.frame(
    Parameter = c("(Intercept)", "treatmentcontrol", "treatmentcontrol"),
    Coefficient = c(0.13, -0.27, -0.27),
    SE = c(0.25, 0.36, 0.36),
    CI_low = c(-0.37, -0.99, -0.99),
    CI_high = c(0.64, 0.45, 0.45),
    t = c(0.52, -0.75, -0.75),
    df_error = c(18, 18, 18),
    p = c(0.606, 0.466, 0.466),
    stringsAsFactors = FALSE
  )
  
  # Test report_parameters with regular lm model (should NOT deduplicate)
  params_result <- report_parameters(mock_lm, table = duplicated_table, include_intercept = FALSE)
  params_text <- as.character(params_result)
  
  # Count the number of parameter lines in the output
  lines <- trimws(strsplit(params_text, "\n")[[1]])
  non_empty_lines <- lines[nchar(lines) > 0]
  
  # Should have 2 parameter lines (no deduplication for non-glmmTMB models)
  expect_equal(
    length(non_empty_lines),
    2L,
    info = paste("Expected 2 parameter lines for regular lm (no deduplication), got", length(non_empty_lines), "lines:", paste(non_empty_lines, collapse = " | "))
  )
})