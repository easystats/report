test_that("report_s", {
  expect_snapshot(report_s(s = 4.2), variant = "windows")
  expect_snapshot(report_s(p = 0.06), variant = "windows")
})

test_that("report_s, arguments", {
  expect_error(report_s())
  expect_error(report_s(s = 1:2), "single value")
})

test_that("report_s edge cases and parameters", {
  # Test with p-value conversion to s-value - just check it doesn't error
  expect_no_error(report_s(p = 0.05))
  
  # Test with custom test_value and test_parameter
  expect_no_error(report_s(s = 2.0, test_value = 1, test_parameter = "mean"))
  
  # Test with very small p-value
  expect_no_error(report_s(p = 0.001))
  
  # Test with larger s-value
  expect_no_error(report_s(s = 10))
  
  # Test error handling for multiple values
  expect_error(report_s(p = c(0.05, 0.01)), "single value")
  expect_error(report_s(s = c(1, 2)), "single value")
  
  # Test error handling for missing values
  expect_error(report_s(s = NULL, p = NULL))
  expect_error(report_s(s = NA, p = NA))
})
