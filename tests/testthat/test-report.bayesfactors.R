context("bayesfactor_*")

library(report)
library(bayestestR)

mo0 <- lm(Sepal.Length ~ 1, data = iris)
mo1 <- lm(Sepal.Length ~ Species, data = iris)
mo2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
mo3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)

BFmodels <- bayesfactor_models(mo1, mo2, mo3, denominator = mo0)

test_that("models", {
  expect_known_value(report(BFmodels),"bf_mods",update = FALSE)
})

inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1,2,3), match_models = TRUE)

test_that("inclusion", {
  expect_known_value(report(inc_bf),"bf_inc",update = FALSE)
})
