context("format_model")

test_that("format_model", {
  testthat::expect_equal(format_model(insight::download_model("lm_1")), "linear model")
  testthat::expect_equal(format_model(insight::download_model("glm_1")), "logistic model")
  testthat::expect_equal(format_model(insight::download_model("glm_2")), "logistic model")
  testthat::expect_equal(format_model(insight::download_model("glm_3")), "logistic model")
  testthat::expect_equal(format_model(insight::download_model("glm_4")), "probit model")

  testthat::expect_equal(format_model(insight::download_model("lmerMod_1")), "linear mixed model")
  testthat::expect_equal(format_model(insight::download_model("merMod_1")), "logistic mixed model")
  testthat::expect_equal(format_model(insight::download_model("merMod_2")), "logistic mixed model")

  testthat::expect_equal(format_model(insight::download_model("stanreg_lm_1")), "Bayesian linear model")
  testthat::expect_equal(format_model(insight::download_model("stanreg_glm_1")), "Bayesian logistic model")

  model <- glm(vs ~ mpg, data = mtcars, family = "poisson")
  testthat::expect_equal(format_model(model), "general linear model (poisson family with a log link)")
})
