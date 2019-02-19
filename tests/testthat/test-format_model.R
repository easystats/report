context("format_model")

test_that("format_model", {
  library(circus)

  testthat::expect_equal(format_model(circus::lm_1), "linear model")
  testthat::expect_equal(format_model(circus::glm_1), "logistic model")
  testthat::expect_equal(format_model(circus::glm_2), "probit model")

  testthat::expect_equal(format_model(circus::lmerMod_1), "linear mixed model")
  testthat::expect_equal(format_model(circus::merMod_1), "logistic mixed model")
  testthat::expect_equal(format_model(circus::merMod_2), "probit mixed model")

  testthat::expect_equal(format_model(circus::stanreg_lm_1), "Bayesian linear model")
  testthat::expect_equal(format_model(circus::stanreg_glm_1), "Bayesian logistic model")
})
