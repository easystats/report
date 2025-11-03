# Report the parameters of a model

Creates a list containing a description of the parameters of R objects
(see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_parameters(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

A `vector`.

## Examples

``` r
# \donttest{
library(report)

# Miscellaneous
r <- report_parameters(sessionInfo())
r
#>   - Matrix (version 1.7.4; Bates D et al., 2025)
#>   - lme4 (version 1.1.37; Bates D et al., 2015)
#>   - brms (version 2.23.0; Bürkner P, 2017)
#>   - Rcpp (version 1.1.0; Eddelbuettel D et al., 2025)
#>   - rstanarm (version 2.32.2; Goodrich B et al., 2025)
#>   - performance (version 0.15.2; Lüdecke D et al., 2021)
#>   - bayestestR (version 0.17.0; Makowski D et al., 2019)
#>   - modelbased (version 0.13.0; Makowski D et al., 2025)
#>   - report (version 0.6.2; Makowski D et al., 2023)
#>   - BayesFactor (version 0.9.12.4.7; Morey R, Rouder J, 2024)
#>   - coda (version 0.19.4.1; Plummer M et al., 2006)
#>   - R (version 4.5.2; R Core Team, 2025)
#>   - lavaan (version 0.6.20; Rosseel Y et al., 2025)
#>   - dplyr (version 1.1.4; Wickham H et al., 2023)
summary(r)
#>   - Matrix (v1.7.4)
#>   - lme4 (v1.1.37)
#>   - brms (v2.23.0)
#>   - Rcpp (v1.1.0)
#>   - rstanarm (v2.32.2)
#>   - performance (v0.15.2)
#>   - bayestestR (v0.17.0)
#>   - modelbased (v0.13.0)
#>   - report (v0.6.2)
#>   - BayesFactor (v0.9.12.4.7)
#>   - coda (v0.19.4.1)
#>   - R (v4.5.2)
#>   - lavaan (v0.6.20)
#>   - dplyr (v1.1.4)

# Data
report_parameters(iris$Sepal.Length)
#>   - n = 150
#>   - Mean = 5.84
#>   - SD = 0.83
#>   - Median = 5.80
#>   - MAD = 1.04
#>   - range: [4.30, 7.90]
#>   - Skewness = 0.31
#>   - Kurtosis = -0.55
#>   - 0% missing
report_parameters(as.character(round(iris$Sepal.Length, 1)))
#>   - 5 (6.67%)
#>   - 5.1 (6.00%)
#>   - 6.3 (6.00%)
#>   - 5.7 (5.33%)
#>   - 6.7 (5.33%)
#>   - 5.5 (4.67%)
#>   - 5.8 (4.67%)
#>   - 6.4 (4.67%)
#>   - 4.9 (4.00%)
#>   - 5.4 (4.00%)
#>   - 5.6 (4.00%)
#>   - 6 (4.00%)
#>   - 6.1 (4.00%)
#>   - 4.8 (3.33%)
#>   - 6.5 (3.33%)
#>   - 4.6 (2.67%)
#>   - 5.2 (2.67%)
#>   - 6.2 (2.67%)
#>   - 6.9 (2.67%)
#>   - 7.7 (2.67%)
#>   - 4.4 (2.00%)
#>   - 5.9 (2.00%)
#>   - 6.8 (2.00%)
#>   - 7.2 (2.00%)
#>   - 4.7 (1.33%)
#>   - 6.6 (1.33%)
#>   - 4.3 (0.67%)
#>   - 4.5 (0.67%)
#>   - 5.3 (0.67%)
#>   - 7 (0.67%)
#>   - 7.1 (0.67%)
#>   - 7.3 (0.67%)
#>   - 7.4 (0.67%)
#>   - 7.6 (0.67%)
#>   - 7.9 (0.67%)
report_parameters(iris$Species)
#>   - setosa (n = 50, 33.33%)
#>   - versicolor (n = 50, 33.33%)
#>   - virginica (n = 50, 33.33%)
report_parameters(iris)
#>   - Sepal.Length: n = 150, Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04, range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.55, 0% missing
#>   - Sepal.Width: n = 150, Mean = 3.06, SD = 0.44, Median = 3.00, MAD = 0.44, range: [2, 4.40], Skewness = 0.32, Kurtosis = 0.23, 0% missing
#>   - Petal.Length: n = 150, Mean = 3.76, SD = 1.77, Median = 4.35, MAD = 1.85, range: [1, 6.90], Skewness = -0.27, Kurtosis = -1.40, 0% missing
#>   - Petal.Width: n = 150, Mean = 1.20, SD = 0.76, Median = 1.30, MAD = 1.04, range: [0.10, 2.50], Skewness = -0.10, Kurtosis = -1.34, 0% missing
#>   - Species: 3 levels, namely setosa (n = 50, 33.33%), versicolor (n = 50, 33.33%) and virginica (n = 50, 33.33%)

# h-tests
report_parameters(t.test(iris$Sepal.Width, iris$Sepal.Length))
#>   - negative, statistically significant, and large (difference = -2.79, 95% CI [-2.94, -2.64], t(225.68) = -36.46, p < .001; Cohen's d = -4.21, 95% CI [-4.66, -3.76])

# ANOVA
report_parameters(aov(Sepal.Length ~ Species, data = iris))
#>   - The main effect of Species is statistically significant and large (F(2, 147) = 119.26, p < .001; Eta2 = 0.62, 95% CI [0.54, 1.00])

# GLMs
report_parameters(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#>   - The intercept is statistically significant and positive (beta = 4.21, 95% CI [3.41, 5.02], t(144) = 10.34, p < .001; Std. beta = 0.49, 95% CI [-1.03, 2.01])
#>   - The effect of Petal Length is statistically non-significant and positive (beta = 0.54, 95% CI [-4.76e-03, 1.09], t(144) = 1.96, p = 0.052; Std. beta = 1.16, 95% CI [-0.01, 2.32])
#>   - The effect of Species [versicolor] is statistically significant and negative (beta = -1.81, 95% CI [-2.99, -0.62], t(144) = -3.02, p = 0.003; Std. beta = -0.88, 95% CI [-2.41, 0.65])
#>   - The effect of Species [virginica] is statistically significant and negative (beta = -3.15, 95% CI [-4.41, -1.90], t(144) = -4.97, p < .001; Std. beta = -1.75, 95% CI [-3.32, -0.18])
#>   - The effect of Petal Length × Species [versicolor] is statistically non-significant and positive (beta = 0.29, 95% CI [-0.30, 0.87], t(144) = 0.97, p = 0.334; Std. beta = 0.61, 95% CI [-0.63, 1.85])
#>   - The effect of Petal Length × Species [virginica] is statistically non-significant and positive (beta = 0.45, 95% CI [-0.12, 1.03], t(144) = 1.56, p = 0.120; Std. beta = 0.97, 95% CI [-0.26, 2.19])
report_parameters(lm(Petal.Width ~ Species, data = iris), include_intercept = FALSE)
#>   - The effect of Species [versicolor] is statistically significant and positive (beta = 1.08, 95% CI [1.00, 1.16], t(147) = 26.39, p < .001; Std. beta = 1.42, 95% CI [1.31, 1.52])
#>   - The effect of Species [virginica] is statistically significant and positive (beta = 1.78, 95% CI [1.70, 1.86], t(147) = 43.49, p < .001; Std. beta = 2.34, 95% CI [2.23, 2.44])
report_parameters(glm(vs ~ disp, data = mtcars, family = "binomial"))
#>   - The intercept is statistically significant and positive (beta = 4.14, 95% CI [1.81, 7.44], p = 0.003; Std. beta = -0.85, 95% CI [-2.42, 0.27])
#>   - The effect of disp is statistically significant and negative (beta = -0.02, 95% CI [-0.04, -0.01], p = 0.002; Std. beta = -2.68, 95% CI [-4.90, -1.27])
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_parameters(model)
#>   - The intercept is statistically significant and positive (beta = 2.50, 95% CI [1.19, 3.82], t(146) = 3.75, p < .001; Std. beta = -1.46e-13, 95% CI [-1.49, 1.49])
#>   - The effect of Petal Length is statistically significant and positive (beta = 0.89, 95% CI [0.76, 1.01], t(146) = 13.93, p < .001; Std. beta = 1.89, 95% CI [1.63, 2.16])
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_parameters(model)
#>   - The intercept (Median = 5.00, 95% CI [4.88, 5.16]) has a 100.00% probability of being positive (> 0), 100.00% of being significant (> 0.04), and 100.00% of being large (> 0.25). The estimation successfully converged (Rhat = 0.999) but the indices are unreliable (ESS = 886)
#>   - The effect of Species [versicolor] (Median = 0.93, 95% CI [0.73, 1.13]) has a 100.00% probability of being positive (> 0), 100.00% of being significant (> 0.04), and 100.00% of being large (> 0.25). The estimation successfully converged (Rhat = 0.998) but the indices are unreliable (ESS = 907)
#>   - The effect of Species [virginica] (Median = 1.58, 95% CI [1.38, 1.77]) has a 100.00% probability of being positive (> 0), 100.00% of being significant (> 0.04), and 100.00% of being large (> 0.25). The estimation successfully converged (Rhat = 0.999) and the indices are reliable (ESS = 1043)
# }
```
