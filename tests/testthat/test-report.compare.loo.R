skip_if_not_installed("brms")
skip_if_not_installed("loo")

test_that("report.compare.loo", {
  # Skip if dependencies not available
  skip_on_cran()
  
  set.seed(123)
  # Create simple brms models for testing
  suppressMessages(suppressWarnings({
    m1 <- brms::brm(mpg ~ qsec, data = mtcars, refresh = 0, iter = 300, seed = 123, chains = 1)
    m2 <- brms::brm(mpg ~ qsec + drat, data = mtcars, refresh = 0, iter = 300, seed = 123, chains = 1)
    m3 <- brms::brm(mpg ~ qsec + drat + wt, data = mtcars, refresh = 0, iter = 300, seed = 123, chains = 1)
  }))
  
  # Add LOO criterion
  suppressWarnings({
    m1 <- brms::add_criterion(m1, "loo")
    m2 <- brms::add_criterion(m2, "loo")
    m3 <- brms::add_criterion(m3, "loo")
  })
  
  # Compare models
  x <- suppressWarnings(brms::loo_compare(
    m1, m2, m3,
    model_names = c("m1", "m2", "m3")
  ))
  
  r <- report(x)
  expect_s3_class(r, c("report_text", "character"))
  expect_true(nchar(r) > 0)
  expect_true(grepl("best model", r))
  expect_true(grepl("ELPD", r))
  
  # Test with different options
  r2 <- report(x, include_IC = FALSE)
  expect_s3_class(r2, c("report_text", "character"))
  
  r3 <- report(x, include_ENP = TRUE)
  expect_s3_class(r3, c("report_text", "character"))
})