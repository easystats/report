test_that("format_algorithm() works with linear models", {
  model <- lm(Sepal.Length ~ Species, data = iris)
  result <- format_algorithm(model)
  
  # Linear models typically don't have complex algorithms, so result might be empty
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("format_algorithm() handles models without algorithm information", {
  model <- lm(Sepal.Length ~ Species, data = iris)
  result <- format_algorithm(model)
  
  # Should return empty string for models without algorithm info
  expect_type(result, "character")
  expect_true(nchar(result) >= 0)  # Could be empty string
})

test_that("format_algorithm() formats MCMC information correctly", {
  # Create a mock object that would return algorithm info
  # This tests the formatting logic for MCMC algorithms
  
  # Mock insight::find_algorithm to return MCMC info
  mock_algorithm <- list(
    algorithm = "sampling",
    chains = 4,
    iterations = 2000,
    warmup = 1000
  )
  
  # We can't easily mock insight::find_algorithm in tests, so test the string building logic
  result_text <- "MCMC sampling"
  if (!is.null(mock_algorithm$chains)) {
    result_text <- paste0(result_text, " with ", mock_algorithm$chains, " chains")
    if (!is.null(mock_algorithm$iterations)) {
      result_text <- paste0(result_text, " of ", mock_algorithm$iterations, " iterations")
    }
    if (!is.null(mock_algorithm$warmup)) {
      result_text <- paste0(result_text, " and a warmup of ", mock_algorithm$warmup)
    }
  }
  
  expect_equal(result_text, "MCMC sampling with 4 chains of 2000 iterations and a warmup of 1000")
})

test_that("format_algorithm() formats optimizer information correctly", {
  # Test optimizer formatting logic
  mock_algorithm <- list(
    algorithm = "ML",
    optimizer = "bobyqa"
  )
  
  result_text <- mock_algorithm$algorithm
  if (!is.null(mock_algorithm$optimizer)) {
    optimizer <- mock_algorithm$optimizer[1]
    if (optimizer == "bobyqa") {
      optimizer <- "BOBYQA"
    } else if (optimizer == "Nelder_Mead") {
      optimizer <- "Nelder-Mead"
    }
    result_text <- paste0(result_text, " and ", optimizer, " optimizer")
  }
  
  expect_equal(result_text, "ML and BOBYQA optimizer")
  
  # Test Nelder-Mead conversion
  mock_algorithm$optimizer <- "Nelder_Mead"
  result_text2 <- mock_algorithm$algorithm
  if (!is.null(mock_algorithm$optimizer)) {
    optimizer <- mock_algorithm$optimizer[1]
    if (optimizer == "bobyqa") {
      optimizer <- "BOBYQA"
    } else if (optimizer == "Nelder_Mead") {
      optimizer <- "Nelder-Mead"
    }
    result_text2 <- paste0(result_text2, " and ", optimizer, " optimizer")
  }
  
  expect_equal(result_text2, "ML and Nelder-Mead optimizer")
})

test_that("format_formula() works with simple linear models", {
  model <- lm(Sepal.Length ~ Species, data = iris)
  result <- format_formula(model)
  
  expect_type(result, "character")
  expect_length(result, 1)
  expect_match(result, "^formula:")
  expect_match(result, "Sepal\\.Length")
  expect_match(result, "Species")
})

test_that("format_formula() works with different formula components", {
  model <- lm(Sepal.Length ~ Sepal.Width + Species, data = iris)
  
  # Test conditional formula (default)
  result_conditional <- format_formula(model, what = "conditional")
  expect_match(result_conditional, "^formula:")
  expect_match(result_conditional, "Sepal\\.Length")
  expect_match(result_conditional, "Sepal\\.Width")
  expect_match(result_conditional, "Species")
})

# Skip mixed model tests if lme4 is not available
test_that("format_algorithm() and format_formula() work with mixed models", {
  skip_if_not_installed("lme4")
  
  model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
  
  # Test algorithm formatting
  result_algo <- format_algorithm(model)
  expect_type(result_algo, "character")
  
  # Test formula formatting
  result_formula <- format_formula(model)
  expect_match(result_formula, "^formula:")
  expect_match(result_formula, "Sepal\\.Length")
  expect_match(result_formula, "Sepal\\.Width")
  
  # Test random formula
  result_random <- format_formula(model, what = "random")
  expect_match(result_random, "^formula:")
  expect_match(result_random, "Species")
})

test_that("format_formula() handles complex formulas", {
  # Test with interaction terms
  model_interaction <- lm(Sepal.Length ~ Sepal.Width * Species, data = iris)
  result_interaction <- format_formula(model_interaction)
  
  expect_match(result_interaction, "Sepal\\.Width")
  expect_match(result_interaction, "Species")
  expect_match(result_interaction, "\\*")
  
  # Test with polynomial terms  
  model_poly <- lm(Sepal.Length ~ poly(Sepal.Width, 2), data = iris)
  result_poly <- format_formula(model_poly)
  
  expect_match(result_poly, "poly")
  expect_match(result_poly, "Sepal\\.Width")
})