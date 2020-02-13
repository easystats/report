context("report.bayesfactor*")

library(bayestestR)

mod0 <- lm(Sepal.Length ~ 1, data = iris)
mod1 <- lm(Sepal.Length ~ Species, data = iris)
mod2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
mod3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)

BFmodels <- bayesfactor_models(mod1, mod2, mod3, denominator = mod0)

testthat::test_that("models", {
  testthat::expect_equal(nchar(text_short(report(BFmodels))), 186)
})

inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)

testthat::test_that("inclusion", {
  testthat::expect_equal(nchar(text_short(report(inc_bf))), 308)
})
