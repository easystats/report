test_that("format_model", {
  expect_identical(
    format_model(lm(Sepal.Length ~ Petal.Length * Species, data = iris)),
    "linear model"
  )
  expect_identical(
    format_model(glm(vs ~ disp, data = mtcars, family = "binomial")),
    "logistic model"
  )
  expect_identical(
    format_model(glm(
      vs ~ disp,
      data = mtcars,
      family = binomial(link = "probit")
    )),
    "probit model"
  )
  expect_identical(
    format_model(glm(vs ~ mpg, data = mtcars, family = "poisson")),
    "poisson model"
  )
})


test_that("format_model names multinomial and ordinal models", {
  info <- list(
    is_logit = FALSE,
    is_probit = FALSE,
    is_linear = FALSE,
    is_poisson = FALSE,
    is_negbin = FALSE,
    is_ordinal = FALSE,
    is_multinomial = FALSE,
    is_survival = FALSE
  )
  multinomial_logit <- modifyList(
    info,
    list(is_logit = TRUE, is_multinomial = TRUE)
  )
  ordinal_logit <- modifyList(info, list(is_logit = TRUE, is_ordinal = TRUE))
  ordinal_probit <- modifyList(info, list(is_probit = TRUE, is_ordinal = TRUE))
  ordinal_other <- modifyList(info, list(is_ordinal = TRUE))

  expect_identical(
    get_model_type_prefix(multinomial_logit),
    "multinomial logistic "
  )
  expect_identical(get_model_type_prefix(ordinal_logit), "ordinal logistic ")
  expect_identical(get_model_type_prefix(ordinal_probit), "ordinal probit ")
  expect_identical(get_model_type_prefix(ordinal_other), "ordinal ")
})


test_that("format_model", {
  skip_if_not_installed("lme4")
  expect_identical(
    format_model(lme4::lmer(wt ~ cyl + (1 | gear), data = mtcars)),
    "linear mixed model"
  )
  expect_identical(
    format_model(lme4::glmer(
      vs ~ cyl + (1 | gear),
      data = mtcars,
      family = "binomial"
    )),
    "logistic mixed model"
  )
  expect_identical(
    format_model(lme4::glmer(
      vs ~ drat + cyl + (1 | gear),
      data = mtcars,
      family = "binomial"
    )),
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
        rstanarm::stan_glm(
          vs ~ wt,
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
