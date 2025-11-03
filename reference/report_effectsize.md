# Report the effect size(s) of a model or a test

Computes, interpret and formats the effect sizes of a variety of models
and statistical tests (see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_effectsize(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_effectsize()`.

## Examples

``` r
library(report)

# h-tests
report_effectsize(t.test(iris$Sepal.Width, iris$Sepal.Length))
#> Effect sizes were labelled following Cohen's (1988) recommendations. 
#> 
#> large (Cohen's d = -4.21, 95% CI [-4.66, -3.76])

# ANOVAs
report_effectsize(aov(Sepal.Length ~ Species, data = iris))
#> Effect sizes were labelled following Field's (2013) recommendations. 
#> 
#> large (Eta2 = 0.62, 95% CI [0.54, 1.00])

# GLMs
report_effectsize(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#> Effect sizes were labelled following Cohen's (1988) recommendations. 
#> 
#> small (Std. beta = 0.49, 95% CI [-1.03, 2.01])
#> large (Std. beta = 1.16, 95% CI [-0.01, 2.32])
#> large (Std. beta = -0.88, 95% CI [-2.41, 0.65])
#> large (Std. beta = -1.75, 95% CI [-3.32, -0.18])
#> medium (Std. beta = 0.61, 95% CI [-0.63, 1.85])
#> large (Std. beta = 0.97, 95% CI [-0.26, 2.19])
report_effectsize(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> Effect sizes were labelled following Cohen's (1988) recommendations. 
#> 
#> small (Std. beta = -0.85, 95% CI [-2.42, 0.27])
#> large (Std. beta = -2.68, 95% CI [-4.90, -1.27])

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_effectsize(model)
#> Effect sizes were labelled following Cohen's (1988) recommendations. 
#> 
#> very small (Std. beta = -1.46e-13, 95% CI [-1.49, 1.49])
#> large (Std. beta = 1.89, 95% CI [1.63, 2.16])
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_effectsize(model, effectsize_method = "basic")
#> Effect sizes were labelled following Cohen's (1988) recommendations. 
#> 
#> very small (Std. beta = 0.00, 95% CI [0.00, 0.00])
#> medium (Std. beta = 0.53, 95% CI [0.42, 0.65])
#> large (Std. beta = 0.90, 95% CI [0.80, 1.03])
# }
```
