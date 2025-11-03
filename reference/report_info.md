# Report additional information

Reports additional information relevant to the report (see list of
supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_info(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_info()`.

## Examples

``` r
library(report)

# h-tests
report_info(t.test(iris$Sepal.Width, iris$Sepal.Length))
#> Effect sizes were labelled following Cohen's (1988) recommendations.

# ANOVAs
report_info(aov(Sepal.Length ~ Species, data = iris))
#> Effect sizes were labelled following Field's (2013) recommendations.
# \donttest{
# GLMs
report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#> Standardized parameters were obtained by fitting the model on a standardized version of the dataset. 95% Confidence Intervals (CIs) and p-values were computed using a Wald t-distribution approximation.
report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris), include_effectsize = TRUE)
#> Standardized parameters were obtained by fitting the model on a standardized version of the dataset and were labelled following Cohen's (1988) recommendations. 95% Confidence Intervals (CIs) and p-values were computed using a Wald t-distribution approximation.
report_info(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> Standardized parameters were obtained by fitting the model on a standardized version of the dataset. 95% Confidence Intervals (CIs) and p-values were computed using a Wald z-distribution approximation.
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_info(model)
#> Standardized parameters were obtained by fitting the model on a standardized version of the dataset. 95% Confidence Intervals (CIs) and p-values were computed using a Wald t-distribution approximation.
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 300))
report_info(model)
#> Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT) framework, we report the median of the posterior distribution and its 95% CI (Highest Density Interval), along the probability of direction (pd), the probability of significance and the probability of being large. The thresholds beyond which the effect is considered as significant (i.e., non-negligible) and large are |0.04| and |0.25| (corresponding respectively to 0.05 and 0.30 of the outcome's SD). Convergence and stability of the Bayesian sampling has been assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).
# }
```
