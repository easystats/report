mod0 <- lm(Sepal.Length ~ 1, data = iris)
mod1 <- lm(Sepal.Length ~ Species, data = iris)
mod2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
mod3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)

BFmodels <- bayestestR::bayesfactor_models(mod1, mod2, mod3, denominator = mod0)

test_that("models", {
  r <- report(BFmodels)
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_output(print(r), "BIC approximation")
  expect_output(print(r), "\\(Intercept only\\) model")

  BFmodels <- bayestestR::bayesfactor_models(mod1, mod2, mod3, denominator = mod1)
  r <- report(BFmodels)
  expect_output(print(r), "Compared to the Species model")
})



test_that("inclusion", {
  inc_bf <- bayestestR::bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)
  r <- report(inc_bf)
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_output(print(r), "Since each model")
  expect_output(print(r), "subjective")
  expect_output(print(r), "averaging")


  inc_bf <- bayestestR::bayesfactor_inclusion(BFmodels)
  r <- report(inc_bf)
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_false(grepl("subjective prior odds", r, fixed = TRUE))
})
