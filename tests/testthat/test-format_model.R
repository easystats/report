test_that("format_model", {
  expect_identical(format_model(lm(Sepal.Length ~ Petal.Length * Species, data = iris)), "linear model")
  expect_identical(format_model(glm(vs ~ disp, data = mtcars, family = "binomial")), "logistic model")
  expect_identical(format_model(glm(vs ~ disp, data = mtcars, family = binomial(link = "probit"))), "probit model")
  expect_identical(format_model(glm(vs ~ mpg, data = mtcars, family = "poisson")), "poisson model")
})


test_that("format_model", {
  skip_if_not_installed("lme4")
  expect_identical(format_model(lme4::lmer(wt ~ cyl + (1 | gear), data = mtcars)), "linear mixed model")
  expect_identical(
    format_model(lme4::glmer(vs ~ cyl + (1 | gear), data = mtcars, family = "binomial")),
    "logistic mixed model"
  )
  expect_identical(
    format_model(lme4::glmer(vs ~ drat + cyl + (1 | gear), data = mtcars, family = "binomial")),
    "logistic mixed model"
  )
})


test_that("format_model", {
  skip_if_not_installed("rstanarm")
  expect_identical(
    format_model(
      suppressWarnings(
        rstanarm::stan_glm(mpg ~ wt, data = mtcars, refresh = 0, iter = 50)
      )
    ),
    "Bayesian linear model"
  )
  expect_identical(
    format_model(
      suppressWarnings(
        rstanarm::stan_glm(vs ~ wt,
          data = mtcars,
          family = "binomial",
          refresh = 0,
          iter = 50
        )
      )
    ),
    "Bayesian logistic model"
  )
})

test_that("format_model character method works", {
  # Test character method for different model types
  expect_identical(format_model("lm"), "linear model")
  expect_identical(format_model("glm"), "general linear model")
  expect_identical(format_model("lmer"), "linear mixed model")
  expect_identical(format_model("glmer"), "general linear mixed model")
  expect_identical(format_model("gam"), "general additive model")
  expect_identical(format_model("gamm"), "general additive mixed model")
  expect_identical(format_model("unknown"), "model")
})

test_that("format_model handles edge cases", {
  # Test with different family types for GLM
  # Note: GLM with gaussian family is treated as linear model
  glm_gaussian <- glm(mpg ~ wt, data = mtcars, family = gaussian())
  expect_identical(format_model(glm_gaussian), "linear model")
  
  # Test probit link
  glm_probit <- glm(vs ~ wt, data = mtcars, family = binomial(link = "probit"))
  expect_identical(format_model(glm_probit), "probit model")
  
  # Test different model families - use a model that will show general linear format
  # GLM with quasibinomial
  glm_quasi <- glm(vs ~ wt, data = mtcars, family = quasibinomial())
  expect_match(format_model(glm_quasi), "model")
})

test_that("get_model_type_prefix helper function works", {
  # Create mock model info to test the helper function
  # Since it's not exported, we test through format_model
  
  # Test different GLM families
  poisson_model <- glm(round(mpg) ~ wt, data = mtcars, family = poisson())
  expect_identical(format_model(poisson_model), "poisson model")
  
  # Test logistic
  logit_model <- glm(vs ~ wt, data = mtcars, family = binomial())
  expect_identical(format_model(logit_model), "logistic model")
})
