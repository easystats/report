# Coverage tests for report.glmmTMB functions

skip_if_not_installed("glmmTMB")

test_that("report.glmmTMB coverage test", {
  set.seed(789)
  # Create simple test data 
  test_data <- data.frame(
    y = rpois(20, lambda = 1.5),
    x = rnorm(20),
    group = factor(rep(1:4, 5))
  )
  
  # Create minimal glmmTMB model
  suppressWarnings({
    model <- glmmTMB::glmmTMB(
      y ~ x + (1 | group),
      data = test_data,
      family = poisson()
    )
  })
  
  # Test report.glmmTMB (which is aliased to report.lm)
  r <- report(model)
  expect_s3_class(r, "report")
  expect_type(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))
  
  # Test report_random.glmmTMB specifically
  rr <- report_random(model)
  expect_s3_class(rr, c("report_random", "character"))
  expect_true(grepl("random effect", rr, fixed = TRUE))
  expect_true(grepl("group", rr, fixed = TRUE))
  
  # Test other glmmTMB-specific functions for coverage
  rt <- report_table(model)
  expect_s3_class(rt, c("report_table", "data.frame"))
  expect_true("Parameter" %in% names(rt))
  
  # Test report_performance for glmmTMB
  rp <- report_performance(model)
  expect_s3_class(rp, c("report_performance", "character"))
  
  # Test report_effectsize for glmmTMB 
  re <- suppressWarnings(report_effectsize(model))
  expect_s3_class(re, "report_effectsize")
})