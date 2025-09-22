# Coverage tests for report.compare.loo function

skip_if_not_installed("brms")
skip_if_not_installed("loo")

test_that("report.compare.loo coverage test", {
  skip_if_not_installed("rstanarm")
  
  set.seed(456)
  # Create minimal dataset
  tiny_data <- data.frame(
    y = rnorm(12, mean = 3),
    x1 = rnorm(12),
    x2 = rnorm(12)
  )
  
  # Create two very simple models for comparison
  suppressMessages(suppressWarnings({
    m1 <- brms::brm(
      y ~ x1,
      data = tiny_data,
      refresh = 0,
      iter = 50,
      chains = 1,
      seed = 456,
      silent = 2
    )
    
    m2 <- brms::brm(
      y ~ x1 + x2,
      data = tiny_data,
      refresh = 0,
      iter = 50,
      chains = 1,
      seed = 456,
      silent = 2
    )
  }))
  
  # Add LOO criterion (this is what creates compare.loo objects)
  suppressWarnings({
    m1 <- brms::add_criterion(m1, "loo")
    m2 <- brms::add_criterion(m2, "loo")
  })
  
  # Create model comparison object
  comparison <- suppressWarnings(brms::loo_compare(
    m1, m2,
    model_names = c("model1", "model2")
  ))
  
  # Test report.compare.loo function
  r <- report(comparison)
  expect_s3_class(r, c("report_text", "character"))
  expect_gt(nchar(r), 0)
  expect_true(grepl("ELPD", r))
  
  # Test with different parameters
  r2 <- report(comparison, include_IC = FALSE)
  expect_s3_class(r2, c("report_text", "character"))
  
  r3 <- report(comparison, include_ENP = TRUE)  
  expect_s3_class(r3, c("report_text", "character"))
})