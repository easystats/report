# Tests for report_effectsize helper functions and edge cases

test_that("as.report_effectsize works correctly", {
  # Create a basic character vector to convert
  effect_text <- c("small effect", "medium effect")
  
  # Test basic conversion
  result <- as.report_effectsize(effect_text)
  expect_s3_class(result, "report_effectsize")
  expect_identical(length(result), 2L)
  
  # Test with summary
  summary_text <- c("Overall: medium effect")
  result_with_summary <- as.report_effectsize(effect_text, summary = summary_text)
  expect_s3_class(result_with_summary, "report_effectsize")
  
  summ <- summary(result_with_summary)
  expect_s3_class(summ, "report_effectsize")
  expect_identical(as.character(summ), as.character(summary_text))
  
  # Test with custom prefix
  result_custom <- as.report_effectsize(effect_text, prefix = ">> ")
  expect_identical(attr(result_custom, "prefix"), ">> ")
})

test_that("report_effectsize print method works", {
  effect_text <- c("small effect", "medium effect")
  result <- as.report_effectsize(effect_text)
  
  # Test printing without rules
  expect_output(print(result), "small effect")
  expect_output(print(result), "medium effect")
  
  # Test printing with rules
  attr(result, "rules") <- "Effect sizes were calculated using custom rules."
  expect_output(print(result), "custom rules")
})

test_that(".text_effectsize helper function works", {
  # Test with different interpretation methods
  
  # Test cohen1988
  result_cohen <- report:::.text_effectsize("cohen1988")
  expect_match(result_cohen, "Cohen's \\(1988\\)")
  expect_match(result_cohen, "recommendations")
  
  # Test sawilowsky2009
  result_saw <- report:::.text_effectsize("sawilowsky2009")
  expect_match(result_saw, "Savilowsky's \\(2009\\)")
  
  # Test gignac2016
  result_gignac <- report:::.text_effectsize("gignac2016")
  expect_match(result_gignac, "Gignac's \\(2016\\)")
  
  # Test funder2019
  result_funder <- report:::.text_effectsize("funder2019")
  expect_match(result_funder, "Funder's \\(2019\\)")
  
  # Test lovakov2021
  result_lovakov <- report:::.text_effectsize("lovakov2021")
  expect_match(result_lovakov, "Lovakov's \\(2021\\)")
  
  # Test evans1996
  result_evans <- report:::.text_effectsize("evans1996")
  expect_match(result_evans, "Evans's \\(1996\\)")
  
  # Test chen2010
  result_chen <- report:::.text_effectsize("chen2010")
  expect_match(result_chen, "Chen's \\(2010\\)")
  
  # Test field2013
  result_field <- report:::.text_effectsize("field2013")
  expect_match(result_field, "Field's \\(2013\\)")
  
  # Test landis1977
  result_landis <- report:::.text_effectsize("landis1977")
  expect_match(result_landis, "Landis' \\(1977\\)")
  
  # Test with NULL (no interpretation)
  result_null <- report:::.text_effectsize(NULL)
  expect_identical(result_null, "")
  
  # Test with custom interpretation (not character)
  result_custom <- report:::.text_effectsize(list(custom = TRUE))
  expect_match(result_custom, "custom set of rules")
})

test_that(".text_standardize helper function works", {
  # Create mock standardized object for testing
  mock_std_obj <- c("standardized result")
  
  # Test refit method
  attr(mock_std_obj, "std_method") <- "refit"
  attr(mock_std_obj, "robust") <- FALSE
  attr(mock_std_obj, "two_sd") <- FALSE
  
  result_refit <- report:::.text_standardize(mock_std_obj)
  expect_match(result_refit, "standardized version.*dataset")
  
  # Test refit method with robust
  attr(mock_std_obj, "robust") <- TRUE
  result_refit_robust <- report:::.text_standardize(mock_std_obj)
  expect_match(result_refit_robust, "median and the MAD")
  
  # Test 2sd method
  attr(mock_std_obj, "std_method") <- "2sd"
  attr(mock_std_obj, "robust") <- FALSE
  result_2sd <- report:::.text_standardize(mock_std_obj)
  expect_match(result_2sd, "2 times the.*SD")
  
  # Test 2sd method with robust
  attr(mock_std_obj, "robust") <- TRUE
  result_2sd_robust <- report:::.text_standardize(mock_std_obj)
  expect_match(result_2sd_robust, "MAD.*median-based")
  
  # Test smart method
  attr(mock_std_obj, "std_method") <- "smart"
  attr(mock_std_obj, "robust") <- FALSE
  result_smart <- report:::.text_standardize(mock_std_obj)
  expect_match(result_smart, "mean and the SD.*response variable")
  
  # Test smart method with robust
  attr(mock_std_obj, "robust") <- TRUE
  result_smart_robust <- report:::.text_standardize(mock_std_obj)
  expect_match(result_smart_robust, "median and the MAD.*response variable")
  
  # Test basic method
  attr(mock_std_obj, "std_method") <- "basic"
  attr(mock_std_obj, "robust") <- FALSE
  result_basic <- report:::.text_standardize(mock_std_obj)
  expect_match(result_basic, "scaled by the.*mean and the SD")
  
  # Test posthoc method
  attr(mock_std_obj, "std_method") <- "posthoc"
  attr(mock_std_obj, "robust") <- FALSE
  result_posthoc <- report:::.text_standardize(mock_std_obj)
  expect_match(result_posthoc, "scaled by the.*mean and the SD")
  
  # Test unknown method
  attr(mock_std_obj, "std_method") <- "unknown_method"
  result_unknown <- report:::.text_standardize(mock_std_obj)
  expect_match(result_unknown, "standardized using the unknown_method method")
})

test_that("report_effectsize generic method dispatch works", {
  # Test that report_effectsize is a function (may not be S3 generic in base form)
  expect_true(exists("report_effectsize"))
  expect_true(is.function(report_effectsize))
  
  # Test with unsupported object
  unsupported_obj <- structure(list(), class = "unsupported_class")
  expect_error(report_effectsize(unsupported_obj), "objects of class.*not supported")
})