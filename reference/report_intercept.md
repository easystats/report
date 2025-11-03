# Report intercept

Reports intercept of regression models (see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_intercept(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_intercept()`.

## Examples

``` r
# \donttest{
library(report)

# GLMs
report_intercept(lm(Sepal.Length ~ Species, data = iris))
#> The model's intercept, corresponding to Species = setosa, is at 5.01 (95% CI [4.86, 5.15], t(147) = 68.76, p < .001).
report_intercept(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> The model's intercept, corresponding to disp = 0, is at 4.14 (95% CI [1.81, 7.44], p = 0.003).
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_intercept(model)
#> The model's intercept, corresponding to Petal.Length = 0, is at 2.50 (95% CI [1.19, 3.82], t(146) = 3.75, p < .001).
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_intercept(model)
#> The model's intercept, corresponding to Species = setosa, is at 5.01 (95% CI [4.86, 5.15]).
# }
```
