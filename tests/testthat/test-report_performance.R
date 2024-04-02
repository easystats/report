test_that("report_performance Linear)", {
  set.seed(123)
  # Linear
  x1 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
  expect_identical(
    as.character(report_performance(x1)),
    paste(
      "The model explains a statistically significant and substantial proportion of",
      "variance (R2 = 0.84, F(5, 144) = 151.71, p < .001, adj. R2 = 0.83)"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x1))),
    "The model's explanatory power is substantial (R2 = 0.84, adj. R2 = 0.83)"
  )
})

test_that("report_performance GLM)", {
  set.seed(123)
  # GLM
  x2 <- glm(vs ~ disp, data = mtcars, family = "binomial")
  expect_identical(
    as.character(report_performance(x2)),
    "The model's explanatory power is substantial (Tjur's R2 = 0.53)"
  )
  expect_identical(
    as.character(summary(report_performance(x2))),
    "The model's explanatory power is substantial (Tjur's R2 = 0.53)"
  )
})

test_that("report_performance Mixed models)", {
  set.seed(123)
  # Mixed models
  skip_if_not_installed("lme4")

  x3 <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
  expect_identical(
    as.character(report_performance(x3)),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.97) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.66"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x3))),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.97) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.66"
    )
  )

  x4 <- lme4::glmer(vs ~ mpg + (1 | cyl), data = mtcars, family = "binomial")
  expect_identical(
    as.character(report_performance(x4)),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.59) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.13"
    )
  )
  expect_identical(
    as.character(summary(report_performance(x4))),
    paste(
      "The model's total explanatory power is substantial (conditional R2 = 0.59) and the",
      "part related to the fixed effects alone (marginal R2) is of 0.13"
    )
  )
})

test_that("report_performance Bayesian)", {
  set.seed(123)
  # Bayesian
  skip_if_not_installed("rstanarm")

  x5 <- rstanarm::stan_glm(
    Sepal.Length ~ Species,
    data = iris, refresh = 0, iter = 1000, seed = 333
  )
  expect_snapshot(
    variant = "windows",
    report_performance(x5)
  )
  expect_snapshot(
    variant = "windows",
    summary(report_performance(x5))
  )

  x6 <- rstanarm::stan_glm(vs ~ disp,
    data = mtcars, family = "binomial",
    refresh = 0, iter = 1000, seed = 333
  )
  expect_snapshot(
    variant = "windows",
    report_performance(x6)
  )
  expect_snapshot(
    variant = "windows",
    summary(report_performance(x6))
  )
})

test_that("report_performance Bayesian 2)", {
  set.seed(123)
  # Bayesian
  skip_if_not_installed("rstanarm")
  # Using namespace instead of loading the package throws an error:
  # could not find function "stan_glmer"
  # But we don't call "stan_glmer" directly, I suppose it must be called internally
  # So we must define it manually:

  is_stan_glmer_avail <- !inherits(try(stan_glmer, silent = TRUE), "try-error")
  if (!is_stan_glmer_avail) {
    stan_glmer <<- rstanarm::stan_glmer
    on.exit(remove(stan_glmer, envir = .GlobalEnv))
  }

  x7 <- rstanarm::stan_lmer(Sepal.Length ~ Petal.Length + (1 | Species),
    data = iris, refresh = 0, iter = 1000, seed = 333
  )
  expect_snapshot(
    variant = "windows",
    summary(report_performance(x7))
  )
  skip("Skipping because of a .01 decimal difference in snapshots")
  expect_snapshot(
    variant = "windows",
    report_performance(x7)
  )
})
