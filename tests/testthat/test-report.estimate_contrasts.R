skip_if_not_installed("modelbased")
library(modelbased)

test_that("report.estimate_contrasts", {
  # Create a simple model for testing contrasts
  model <- lm(Sepal.Width ~ Species, data = iris)

  # Skip if marginaleffects or other dependencies are not available
  skip_if_not_installed("marginaleffects")
  skip_if_not_installed("collapse")
  skip_if_not_installed("Formula")

  contr <- modelbased::estimate_contrasts(model)

  # Test main report function
  r <- report(contr)
  expect_s3_class(r, "report")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Test report_table
  rt <- report_table(contr)
  expect_s3_class(rt, c("report_table", "data.frame"))
  expect_gt(nrow(rt), 0)

  # Test report_text
  rtx <- report_text(contr, table = rt)
  expect_s3_class(rtx, c("report_text", "character"))
  expect_gt(nchar(rtx), 0)
  expect_true(grepl("marginal contrasts", rtx, fixed = TRUE))
})
