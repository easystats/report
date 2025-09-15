skip_if_not_installed("glmmTMB")

test_that("report.glmmTMB", {
  skip_on_cran() # glmmTMB models can be computationally intensive

  # Create a simple dataset for testing
  set.seed(123)
  data_test <- data.frame(
    y = rpois(100, lambda = 2),
    x = rnorm(100),
    group = factor(rep(1:10, 10))
  )

  # Create a simple glmmTMB model
  suppressWarnings({
    model <- glmmTMB(
      y ~ x + (1 | group),
      data = data_test,
      family = poisson()
    )
  })

  # Test main report function
  r <- report(model)
  expect_s3_class(r, "report")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Test that basic structure is correct
  expect_gt(nchar(summary(r)), 0)
  expect_gt(nrow(as.data.frame(r)), 0)

  # Test report components
  rt <- report_table(model)
  expect_s3_class(rt, c("report_table", "data.frame"))
  expect_true("Parameter" %in% names(rt))

  # Test that random effects are reported
  rr <- report_random(model)
  expect_s3_class(rr, c("report_random", "character"))
  expect_true(grepl("random effect", rr, fixed = TRUE))
  expect_true(grepl("group", rr, fixed = TRUE))
})
