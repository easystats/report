# Report priors of Bayesian models

Reports priors of Bayesian models (see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_priors(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_priors()`.

## Examples

``` r
# \donttest{
# Bayesian models
library(rstanarm)
model <- stan_glm(mpg ~ disp, data = mtcars, refresh = 0, iter = 1000)
r <- report_priors(model)
r
#> Priors over parameters were set as normal (mean = 0.00, SD = 0.12) distributions
summary(r)
#> Priors over parameters were set as normal (mean = 0.00, SD = 0.12) distributions
# }
```
