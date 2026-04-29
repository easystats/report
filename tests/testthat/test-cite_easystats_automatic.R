test_that("automatic citation generation works", {
  # Skip if required packages not installed
  skip_if_not_installed("insight")
  skip_if_not_installed("bayestestR")
  
  # Test automatic citation generation
  result <- cite_easystats(packages = c("insight", "bayestestR"), format = "text")
  
  # Check that result has correct structure
  expect_s3_class(result, "cite_easystats")
  expect_true("intext" %in% names(result))
  expect_true("refs" %in% names(result))
  
  # Check that intext contains automatically generated citations
  expect_true(grepl("Lüdecke et al\\.", result$intext))
  expect_true(grepl("Makowski et al\\.", result$intext))
  expect_true(grepl("2019", result$intext))
  
  # Check that references contain automatically generated citations
  expect_true(grepl("Journal of Open Source Software", result$refs))
  expect_true(grepl("\\[R package\\]", result$refs))
  expect_true(grepl("https://doi.org/", result$refs))
})

test_that("automatic citation generation handles missing packages gracefully", {
  # Test with a non-existent package
  result <- cite_easystats(packages = c("nonexistent_package"), format = "text")
  
  # Should still return a valid object
  expect_s3_class(result, "cite_easystats")
  expect_true("intext" %in% names(result))
  expect_true("refs" %in% names(result))
})

test_that("automatic citation helper functions work", {
  skip_if_not_installed("insight")
  
  # Test the helper functions indirectly through the main function
  result <- cite_easystats(packages = "insight", format = "text")
  
  # Verify that automatic generation worked by checking for current year
  current_year <- format(Sys.Date(), "%Y")
  expect_true(grepl(current_year, result$intext))
  expect_true(grepl("\\[R package\\]", result$refs))
})