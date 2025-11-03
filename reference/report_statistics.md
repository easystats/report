# Report the statistics of a model

Creates a list containing a description of the parameters' values of R
objects (see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).
Useful to insert in parentheses in plots or reports.

## Usage

``` r
report_statistics(x, table = NULL, ...)
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

An object of class `report_statistics()`.

## Examples

``` r
# \donttest{
library(report)

# Data
report_statistics(iris$Sepal.Length)
#> n = 150, Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04, range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.55, 0% missing
report_statistics(as.character(round(iris$Sepal.Length, 1)))
#> 5, 6.67%%; 5.1, 6.00%%; 6.3, 6.00%%; 5.7, 5.33%%; 6.7, 5.33%%; 5.5, 4.67%%; 5.8, 4.67%%; 6.4, 4.67%%; 4.9, 4.00%%; 5.4, 4.00%%; 5.6, 4.00%%; 6, 4.00%%; 6.1, 4.00%%; 4.8, 3.33%%; 6.5, 3.33%%; 4.6, 2.67%%; 5.2, 2.67%%; 6.2, 2.67%%; 6.9, 2.67%%; 7.7, 2.67%%; 4.4, 2.00%%; 5.9, 2.00%%; 6.8, 2.00%%; 7.2, 2.00%%; 4.7, 1.33%%; 6.6, 1.33%%; 4.3, 0.67%%; 4.5, 0.67%%; 5.3, 0.67%%; 7, 0.67%%; 7.1, 0.67%%; 7.3, 0.67%%; 7.4, 0.67%%; 7.6, 0.67%%; 7.9, 0.67%%
report_statistics(iris$Species)
#> setosa, n = 50, 33.33%; versicolor, n = 50, 33.33%; virginica, n = 50, 33.33%
report_statistics(iris)
#> n = 150, Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04, range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.55, 0% missing
#> n = 150, Mean = 3.06, SD = 0.44, Median = 3.00, MAD = 0.44, range: [2, 4.40], Skewness = 0.32, Kurtosis = 0.23, 0% missing
#> n = 150, Mean = 3.76, SD = 1.77, Median = 4.35, MAD = 1.85, range: [1, 6.90], Skewness = -0.27, Kurtosis = -1.40, 0% missing
#> n = 150, Mean = 1.20, SD = 0.76, Median = 1.30, MAD = 1.04, range: [0.10, 2.50], Skewness = -0.10, Kurtosis = -1.34, 0% missing
#> setosa, n = 50, 33.33%; versicolor, n = 50, 33.33%; virginica, n = 50, 33.33%

# h-tests
report_statistics(t.test(iris$Sepal.Width, iris$Sepal.Length))
#> difference = -2.79, 95% CI [-2.94, -2.64], t(225.68) = -36.46, p < .001; Cohen's d = -4.21, 95% CI [-4.66, -3.76]

# ANOVA
report_statistics(aov(Sepal.Length ~ Species, data = iris))
#> F(2, 147) = 119.26, p < .001; Eta2 = 0.62, 95% CI [0.54, 1.00]

# GLMs
report_statistics(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#> beta = 4.21, 95% CI [3.41, 5.02], t(144) = 10.34, p < .001; Std. beta = 0.49, 95% CI [-1.03, 2.01]
#> beta = 0.54, 95% CI [-4.76e-03, 1.09], t(144) = 1.96, p = 0.052; Std. beta = 1.16, 95% CI [-0.01, 2.32]
#> beta = -1.81, 95% CI [-2.99, -0.62], t(144) = -3.02, p = 0.003; Std. beta = -0.88, 95% CI [-2.41, 0.65]
#> beta = -3.15, 95% CI [-4.41, -1.90], t(144) = -4.97, p < .001; Std. beta = -1.75, 95% CI [-3.32, -0.18]
#> beta = 0.29, 95% CI [-0.30, 0.87], t(144) = 0.97, p = 0.334; Std. beta = 0.61, 95% CI [-0.63, 1.85]
#> beta = 0.45, 95% CI [-0.12, 1.03], t(144) = 1.56, p = 0.120; Std. beta = 0.97, 95% CI [-0.26, 2.19]
report_statistics(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> beta = 4.14, 95% CI [1.81, 7.44], p = 0.003; Std. beta = -0.85, 95% CI [-2.42, 0.27]
#> beta = -0.02, 95% CI [-0.04, -0.01], p = 0.002; Std. beta = -2.68, 95% CI [-4.90, -1.27]
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_statistics(model)
#> beta = 2.50, 95% CI [1.19, 3.82], t(146) = 3.75, p < .001; Std. beta = -1.46e-13, 95% CI [-1.49, 1.49]
#> beta = 0.89, 95% CI [0.76, 1.01], t(146) = 13.93, p < .001; Std. beta = 1.89, 95% CI [1.63, 2.16]
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_statistics(model)
#> Median = 5.01, 95% CI [4.85, 5.14], pd = 100%; Std. beta = -1.02, 95% CI [-1.20, -0.84]; Rhat = 1.00, ESS = 859.76
#> Median = 0.93, 95% CI [0.72, 1.14], pd = 100%; Std. beta = 1.13, 95% CI [0.87, 1.39]; Rhat = 1.00, ESS = 798.71
#> Median = 1.58, 95% CI [1.37, 1.80], pd = 100%; Std. beta = 1.91, 95% CI [1.67, 2.17]; Rhat = 1.00, ESS = 911.74
# }
```
