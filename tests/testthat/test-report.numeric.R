test_that("Median removes NA", {
  x <- c(1, 2, NA, 4)
  result <- report_table(x)$Median
  expect_equal(result, median(x, na.rm = TRUE))
})
