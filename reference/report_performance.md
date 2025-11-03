# Report the model's quality and fit indices

Investigating the fit of statistical models to data often involves
selecting the best fitting model amongst many competing models. This
function helps report indices of model fit for various models. Reports
the type of different R objects . For a list of supported objects, see
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_performance(x, table = NULL, ...)
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

An object of class `report_performance()`.

## Examples

``` r
# \donttest{
# GLMs
report_performance(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#> The model explains a statistically significant and substantial proportion of
#> variance (R2 = 0.84, F(5, 144) = 151.71, p < .001, adj. R2 = 0.83)
report_performance(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> The model's explanatory power is substantial (Tjur's R2 = 0.53)
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_performance(model)
#> The model's total explanatory power is substantial (conditional R2 = 0.97) and
#> the part related to the fixed effects alone (marginal R2) is of 0.66
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_performance(model)
#> The model's explanatory power is substantial (R2 = 0.61, 95% CI [0.53, 0.69],
#> adj. R2 = 0.61)
# }
# \donttest{
# Structural Equation Models (SEM)
library(lavaan)
structure <- "ind60 =~ x1 + x2 + x3
              dem60 =~ y1 + y2 + y3
              dem60 ~ ind60 "
model <- lavaan::sem(structure, data = PoliticalDemocracy)
suppressWarnings(report_performance(model))
#> The model is not significantly different from a baseline model (Chi2(8) = 7.98,
#> p = 0.435). The GFI (.97 > .95) suggest a satisfactory fit., The model is not
#> significantly different from a baseline model (Chi2(8) = 7.98, p = 0.435). The
#> AGFI (.91 > .90) suggest a satisfactory fit., The model is not significantly
#> different from a baseline model (Chi2(8) = 7.98, p = 0.435). The NFI (.97 >
#> .90) suggest a satisfactory fit., The model is not significantly different from
#> a baseline model (Chi2(8) = 7.98, p = 0.435). The NNFI (.00 > .90) suggest a
#> satisfactory fit., The model is not significantly different from a baseline
#> model (Chi2(8) = 7.98, p = 0.435). The CFI (.00 > .90) suggest a satisfactory
#> fit., The model is not significantly different from a baseline model (Chi2(8) =
#> 7.98, p = 0.435). The RMSEA (.00 < .05) suggest a satisfactory fit., The model
#> is not significantly different from a baseline model (Chi2(8) = 7.98, p =
#> 0.435). The SRMR (.03 < .08) suggest a satisfactory fit., The model is not
#> significantly different from a baseline model (Chi2(8) = 7.98, p = 0.435). The
#> RFI (.95 > .90) suggest a satisfactory fit., The model is not significantly
#> different from a baseline model (Chi2(8) = 7.98, p = 0.435). The PNFI (.52 >
#> .50) suggest a satisfactory fit. and The model is not significantly different
#> from a baseline model (Chi2(8) = 7.98, p = 0.435). The IFI (.00 > .90) suggest
#> a satisfactory fit.
# }
```
