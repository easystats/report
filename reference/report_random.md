# Report random effects and factors

Reports random effects of mixed models (see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_random(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_random()`.

## Examples

``` r
# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
r <- report_random(model)
r
#> The model included Species as random effect (formula: ~1 | Species)
summary(r)
#> [1] "The model included Species as random effect"
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_lmer(
  mpg ~ disp + (1 | cyl),
  data = mtcars, refresh = 0, iter = 1000
))
r <- report_random(model)
r
#> The model included cyl as random effect (formula: ~1 | cyl)
summary(r)
#> [1] "The model included cyl as random effect"
# }
# \donttest{
library(brms)
model <- suppressWarnings(brm(mpg ~ disp + (1 | cyl), data = mtcars, refresh = 0, iter = 1000))
#> Compiling Stan program...
#> Start sampling
r <- report_random(model)
r
#> The model included cyl as random effect (formula: ~1 | cyl)
summary(r)
#> [1] "The model included cyl as random effect"
# }
```
