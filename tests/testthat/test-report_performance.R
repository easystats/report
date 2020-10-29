if (require("testthat") && require("report")) {
  testthat::test_that("report_performance", {
    set.seed(123)

    # Linear
    x <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
    testthat::expect_equal(
      as.character(report_performance(x)),
      "The model explains a significant and substantial proportion of variance (R2 = 0.84, F(5, 144) = 151.71, p < .001, adj. R2 = 0.83)"
    )
    testthat::expect_equal(
      as.character(summary(report_performance(x))),
      "The model's explanatory power is substantial (R2 = 0.84, adj. R2 = 0.83)"
    )

    # GLM
    x <- glm(vs ~ disp, data = mtcars, family = "binomial")
    testthat::expect_equal(
      as.character(report_performance(x)),
      "The model's explanatory power is substantial (Tjur's R2 = 0.53)"
    )
    testthat::expect_equal(
      as.character(summary(report_performance(x))),
      "The model's explanatory power is substantial (Tjur's R2 = 0.53)"
    )

    # Mixed models
    if (require("lme4")){
      x <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
      testthat::expect_equal(
        as.character(report_performance(x)),
        "The model's total explanatory power is substantial (conditional R2 = 0.97) and the part related to the fixed effects alone (marginal R2) is of 0.66"
      )
      testthat::expect_equal(
        as.character(summary(report_performance(x))),
        "The model's total explanatory power is substantial (conditional R2 = 0.97) and the part related to the fixed effects alone (marginal R2) is of 0.66"
      )

      x <- lme4::glmer(vs ~ mpg + (1|cyl), data=mtcars, family="binomial")
      testthat::expect_equal(
        as.character(report_performance(x)),
        "The model's total explanatory power is substantial (conditional R2 = 0.59) and the part related to the fixed effects alone (marginal R2) is of 0.13"
      )
      testthat::expect_equal(
        as.character(summary(report_performance(x))),
        "The model's total explanatory power is substantial (conditional R2 = 0.59) and the part related to the fixed effects alone (marginal R2) is of 0.13"
      )
    }

    # Bayesian
    if (require("rstanarm")){
      x <- stan_glm(Sepal.Length ~ Species, data = iris, refresh=0, iter=1000, seed=333)
      testthat::expect_equal(
        as.character(report_performance(x)),
        "The model's explanatory power is substantial (R2 = 0.62, 89% CI [0.55, 0.68], adj. R2 = 0.60)"
      )
      testthat::expect_equal(
        as.character(summary(report_performance(x))),
        "The model's explanatory power is substantial (R2 = 0.62, adj. R2 = 0.60)"
      )

      x <- stan_glm(vs ~ disp, data = mtcars, family = "binomial", refresh=0, iter=1000, seed=333)
      testthat::expect_equal(
        as.character(report_performance(x)),
        "The model's explanatory power is substantial (R2 = 0.54, 89% CI [0.33, 0.75])"
      )
      testthat::expect_equal(
        as.character(summary(report_performance(x))),
        "The model's explanatory power is substantial (R2 = 0.54)"
      )

      x <- stan_lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris, refresh=0, iter=1000, seed=333)
      testthat::expect_equal(
        as.character(report_performance(x)),
        "The model's explanatory power is substantial (R2 = 0.83, 89% CI [0.80, 0.86], adj. R2 = 0.83) and the part related to the fixed effects alone (marginal R2) is of 0.95 (89% CI [0.94, 0.97])"
      )
      testthat::expect_equal(
        as.character(summary(report_performance(x))),
        "The model's explanatory power is substantial (R2 = 0.83, adj. R2 = 0.83) and the part related to the fixed effects alone (marginal R2) is of 0.95"
      )
    }
  })
}
