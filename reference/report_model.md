# Report the model type

Reports the type of different R objects (see list of supported objects
in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_model(x, table = NULL, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- table:

  A table obtained via
  [`report_table()`](https://easystats.github.io/report/reference/report_table.md).
  If not provided, will run it.

- ...:

  Arguments passed to or from other methods.

## Value

A `character` string.

## Examples

``` r
# \donttest{
library(report)

# h-tests
report_model(t.test(iris$Sepal.Width, iris$Sepal.Length))
#> Welch Two Sample t-test testing the difference between iris$Sepal.Width and iris$Sepal.Length (mean of x = 3.06, mean of y = 5.84)

# ANOVA
report_model(aov(Sepal.Length ~ Species, data = iris))
#> ANOVA (formula: Sepal.Length ~ Species)

# GLMs
report_model(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#> linear model (estimated using OLS) to predict Sepal.Length with Petal.Length and Species (formula: Sepal.Length ~ Petal.Length * Species)
report_model(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> logistic model (estimated using ML) to predict vs with disp (formula: vs ~ disp)
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_model(model)
#> linear mixed model (estimated using REML and nloptwrap optimizer) to predict Sepal.Length with Petal.Length (formula: Sepal.Length ~ Petal.Length). The model included Species as random effect (formula: ~1 | Species)
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_model(model)
#> Bayesian linear model (estimated using MCMC sampling with 4 chains of 600 iterations and a warmup of 300) to predict Sepal.Length with Species (formula: Sepal.Length ~ Species). Priors over parameters were all set as normal (mean = 0.00, SD = 4.38; mean = 0.00, SD = 4.38) distributions
# }
```
