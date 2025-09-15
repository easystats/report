skip_if_not_installed("GLMMadaptive")

test_that("report.MixMod", {
  # Create a test GLMMadaptive model
  skip_on_cran() # GLMMadaptive models can be computationally intensive

  # Create a simple dataset for mixed model
  set.seed(123)
  data_test <- data.frame(
    y = c(rnorm(50, 2), rnorm(50, 3)),
    x = rep(c(0, 1), each = 50),
    id = rep(1:10, 10)
  )

  suppressWarnings({
    model <- GLMMadaptive::mixed_model(
      fixed = y ~ x,
      random = ~ 1 | id,
      data = data_test,
      family = gaussian()
    )
  })

  # Test main report function
  r <- report(model)
  expect_s3_class(r, "report")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Test that it uses lm methods (since report.MixMod <- report.lm)
  expect_gt(nchar(summary(r)), 0)
  expect_gt(nrow(as.data.frame(r)), 0)

  # Test specific MixMod methods
  rt <- report_table(model)
  expect_s3_class(rt, c("report_table", "data.frame"))

  rr <- report_random(model)
  expect_s3_class(rr, c("report_random", "character"))
  expect_true(grepl("random effect", rr, fixed = TRUE))
})
