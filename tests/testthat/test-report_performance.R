test_that("report_performance", {
  set.seed(123)

  # Linear
  x <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
  expect_identical(
    as.character(report_performance(x)),
    paste(
      "The model explains a statistically significant and substantial proportion of",
      "variance (R2 = 0.84, F(5, 144) = 151.71, p < .001, adj. R2 = 0.83)"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x))),
    "The model's explanatory power is substantial (R2 = 0.84, adj. R2 = 0.83)"
  )

  # GLM
  x <- glm(vs ~ disp, data = mtcars, family = "binomial")
  expect_identical(
    as.character(report_performance(x)),
    "The model's explanatory power is substantial (Tjur's R2 = 0.53)"
  )
  expect_identical(
    as.character(summary(report_performance(x))),
    "The model's explanatory power is substantial (Tjur's R2 = 0.53)"
  )

  # Mixed models
  skip_if_not_or_load_if_installed("lme4")

  x <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
  expect_identical(
    as.character(report_performance(x)),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.97) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.66"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x))),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.97) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.66"
    )
  )

  x <- lme4::glmer(vs ~ mpg + (1 | cyl), data = mtcars, family = "binomial")
  expect_identical(
    as.character(report_performance(x)),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.59) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.13"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x))),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.59) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.13"
    )
  )


  # Mixed models
  skip_if_not_or_load_if_installed("lme4")

  x <- lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
  expect_identical(
    as.character(report_performance(x)),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.97) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.66"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x))),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.97) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.66"
    )
  )

  x <- lme4::glmer(vs ~ mpg + (1 | cyl), data = mtcars, family = "binomial")
  expect_identical(
    as.character(report_performance(x)),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.59) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.13"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x))),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.59) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.13"
    )
  )

  # Bayesian
  skip_if_not_or_load_if_installed("rstanarm")

  x <- stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 1000, seed = 333)
  expect_snapshot(
    variant = "windows",
    report_performance(x)
  )
  expect_snapshot(
    variant = "windows",
    summary(report_performance(x))
  )

  x <- stan_glm(vs ~ disp, data = mtcars, family = "binomial", refresh = 0, iter = 1000, seed = 333)
  expect_snapshot(
    variant = "windows",
    report_performance(x)
  )
  expect_snapshot(
    variant = "windows",
    summary(report_performance(x))
  )

  x <- stan_lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris, refresh = 0, iter = 1000, seed = 333)
  expect_snapshot(
    variant = "windows",
    report_performance(x)
  )
  expect_snapshot(
    variant = "windows",
    summary(report_performance(x))
  )
})
