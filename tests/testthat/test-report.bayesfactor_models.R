if (require("testthat") && require("bayestestR")) {
  mod0 <- lm(Sepal.Length ~ 1, data = iris)
  mod1 <- lm(Sepal.Length ~ Species, data = iris)
  mod2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
  mod3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)

  BFmodels <- bayestestR::bayesfactor_models(mod1, mod2, mod3, denominator = mod0)

  testthat::test_that("models", {
    r <- report(BFmodels)
    testthat::expect_is(summary(r), "character")
    testthat::expect_is(as.data.frame(r), "data.frame")

    testthat::expect_output(print(r), "BIC approximation")
    testthat::expect_output(print(r), "\\(Intercept only\\) model \\(the least supported model\\)")
    testthat::expect_output(print(r), "Species \\+ Petal.Length model \\(the most supported model\\)")
    testthat::expect_output(print(r), "Compared to the \\(Intercept only\\) model")

    BFmodels <- bayestestR::bayesfactor_models(mod1, mod2, mod3, denominator = mod1)
    r <- report(BFmodels)
    testthat::expect_output(print(r), "Compared to the Species model")
  })



  testthat::test_that("inclusion", {
    inc_bf <- bayestestR::bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)
    r <- report(inc_bf)
    testthat::expect_is(summary(r), "character")
    testthat::expect_is(as.data.frame(r), "data.frame")

    testthat::expect_output(print(r), "Since each model has a prior probability")
    testthat::expect_output(print(r), "subjective prior odds")
    testthat::expect_output(print(r), "averaging was done only")


    inc_bf <- bayestestR::bayesfactor_inclusion(BFmodels)
    r <- report(inc_bf)
    testthat::expect_is(summary(r), "character")
    testthat::expect_is(as.data.frame(r), "data.frame")

    testthat::expect_false(grepl("subjective prior odds", r, fixed = TRUE))
    testthat::expect_false(grepl("averaging was done only", r, fixed = TRUE))
  })
}
