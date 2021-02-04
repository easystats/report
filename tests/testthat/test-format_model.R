if (require("testthat")) {
  test_that("format_model", {
    expect_equal(format_model(lm(Sepal.Length ~ Petal.Length * Species, data = iris)), "linear model")
    expect_equal(format_model(glm(vs ~ disp, data = mtcars, family = "binomial")), "logistic model")
    expect_equal(format_model(glm(vs ~ disp, data = mtcars, family = binomial(link = "probit"))), "probit model")
    expect_equal(format_model(glm(vs ~ mpg, data = mtcars, family = "poisson")), "poisson model")
  })
}

if (require("testthat") && require("lme4")) {
  test_that("format_model", {
    expect_equal(format_model(lme4::lmer(wt ~ cyl + (1 | gear), data = mtcars)), "linear mixed model")
    expect_equal(format_model(lme4::glmer(vs ~ cyl + (1 | gear), data = mtcars, family = "binomial")), "logistic mixed model")
    expect_equal(format_model(lme4::glmer(vs ~ drat + cyl + (1 | gear), data = mtcars, family = "binomial")), "logistic mixed model")
  })
}


if (require("testthat") && require("rstanarm")) {
  test_that("format_model", {
    expect_equal(format_model(suppressWarnings(rstanarm::stan_glm(mpg ~ wt, data = mtcars, refresh = 0, iter = 50))), "Bayesian linear model")
    expect_equal(format_model(suppressWarnings(rstanarm::stan_glm(vs ~ wt, data = mtcars, family = "binomial", refresh = 0, iter = 50))), "Bayesian logistic model")
  })
}
