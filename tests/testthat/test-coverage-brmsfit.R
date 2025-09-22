# Coverage tests for report.brmsfit functions
# These are minimal tests to ensure coverage of functions that might be skipped in CI

skip_if_not_installed("brms")

test_that("report.brmsfit coverage test", {
  # Create a very simple brms model for testing
  # Use minimal iterations and very simple data to make it fast
  skip_if_not_installed("rstanarm") # often needed for brms
  
  set.seed(42)
  # Use a tiny dataset to make model fitting very fast
  tiny_data <- data.frame(
    y = rnorm(10, mean = 2),
    x = rnorm(10)
  )
  
  # Create minimal brms model with very few iterations
  suppressMessages(suppressWarnings({
    model <- brms::brm(
      y ~ x,
      data = tiny_data,
      refresh = 0,
      iter = 100,  # Very small number for speed
      chains = 1,  # Single chain for speed
      seed = 42,
      silent = 2   # Suppress output
    )
  }))
  
  # Test the main report function (coverage for report.brmsfit)
  r <- suppressWarnings(report(model, verbose = FALSE))
  expect_s3_class(r, "report")
  expect_type(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")
  
  # Test report_effectsize.brmsfit coverage
  r_eff <- suppressWarnings(report_effectsize(model))
  expect_s3_class(r_eff, "report_effectsize")
  
  # Test report_priors.brmsfit coverage - this might return empty for default priors
  r_priors <- suppressWarnings(report_priors(model))
  expect_type(r_priors, "character")
})

test_that("report_priors.brmsfit with explicit priors coverage", {
  skip_if_not_installed("brms")
  skip_if_not_installed("rstanarm")
  
  set.seed(123)
  tiny_data <- data.frame(
    y = rnorm(8, mean = 1),
    x = rnorm(8)
  )
  
  # Create model with explicit priors to test prior reporting
  suppressMessages(suppressWarnings({
    model_with_priors <- brms::brm(
      y ~ x,
      data = tiny_data,
      prior = c(
        brms::prior(normal(0, 1), class = Intercept),
        brms::prior(normal(0, 0.5), class = b)
      ),
      refresh = 0,
      iter = 50,  # Even fewer iterations
      chains = 1,
      seed = 123,
      silent = 2
    )
  }))
  
  # Test report_priors with actual priors
  r_priors <- suppressWarnings(report_priors(model_with_priors))
  expect_type(r_priors, "character")
})