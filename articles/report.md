# Automated Reporting: Getting Started

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## dplyr  lme4 
    ##  TRUE  TRUE

## Installation

First, install R and R studio. Then, copy and paste the following lines
in the console:

``` r

install.packages("remotes")
remotes::install_github("easystats/report") # You only need to do that once
```

``` r

library("report") # Load the package every time you start R
```

Great! The `report` package is now installed and loaded in your session.

## Supported Objects

The `report` package works in a two step fashion: - First, you create a
`report` object with the
[`report()`](https://easystats.github.io/report/reference/report.md)
function. - Second, this report object can be displayed either textually
(the default output) or as a table, using
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).
Moreover, you can also access a more compact version of the report using
[`summary()`](https://rdrr.io/r/base/summary.html) on the report object.

### Dataframes

If an entire dataframe is supplied, `report` will provide descriptive
statistics for all columns:

``` r

report(iris)
# The data contains 150 observations of the following 5
# variables:
# 
#   - Sepal.Length: n = 150, Mean = 5.84, SD = 0.83, Median =
# 5.80, MAD = 1.04, range: [4.30, 7.90], Skewness = 0.31,
# Kurtosis = -0.55, 0% missing
#   - Sepal.Width: n = 150, Mean = 3.06, SD = 0.44, Median =
# 3.00, MAD = 0.44, range: [2, 4.40], Skewness = 0.32,
# Kurtosis = 0.23, 0% missing
#   - Petal.Length: n = 150, Mean = 3.76, SD = 1.77, Median =
# 4.35, MAD = 1.85, range: [1, 6.90], Skewness = -0.27,
# Kurtosis = -1.40, 0% missing
#   - Petal.Width: n = 150, Mean = 1.20, SD = 0.76, Median =
# 1.30, MAD = 1.04, range: [0.10, 2.50], Skewness = -0.10,
# Kurtosis = -1.34, 0% missing
#   - Species: 3 levels, namely setosa (n = 50, 33.33%),
# versicolor (n = 50, 33.33%) and virginica (n = 50, 33.33%)
```

### Grouped Dataframes

The dataframe can also be a *grouped* dataframe (from
[dplyr](https://dplyr.tidyverse.org) package), in which case `report`
would return a separate report for each level of the grouping variable.
Additionally, instead of textual summary, `report` also allows one to
return a tabular summary using the
[`report_table()`](https://easystats.github.io/report/reference/report_table.md)
function:

``` r

iris |>
  group_by(Species) |>
  report_table()
# Group      |     Variable | n_Obs | Mean |   SD | Median
# --------------------------------------------------------
# setosa     | Sepal.Length |    50 | 5.01 | 0.35 |   5.00
# setosa     |  Sepal.Width |    50 | 3.43 | 0.38 |   3.40
# setosa     | Petal.Length |    50 | 1.46 | 0.17 |   1.50
# setosa     |  Petal.Width |    50 | 0.25 | 0.11 |   0.20
# versicolor | Sepal.Length |    50 | 5.94 | 0.52 |   5.90
# versicolor |  Sepal.Width |    50 | 2.77 | 0.31 |   2.80
# versicolor | Petal.Length |    50 | 4.26 | 0.47 |   4.35
# versicolor |  Petal.Width |    50 | 1.33 | 0.20 |   1.30
# virginica  | Sepal.Length |    50 | 6.59 | 0.64 |   6.50
# virginica  |  Sepal.Width |    50 | 2.97 | 0.32 |   3.00
# virginica  | Petal.Length |    50 | 5.55 | 0.55 |   5.55
# virginica  |  Petal.Width |    50 | 2.03 | 0.27 |   2.00
# 
# Group      |  MAD |  Min |  Max | Skewness | Kurtosis | n_Missing
# -----------------------------------------------------------------
# setosa     | 0.30 | 4.30 | 5.80 |     0.12 |    -0.25 |         0
# setosa     | 0.37 | 2.30 | 4.40 |     0.04 |     0.95 |         0
# setosa     | 0.15 | 1.00 | 1.90 |     0.11 |     1.02 |         0
# setosa     | 0.00 | 0.10 | 0.60 |     1.25 |     1.72 |         0
# versicolor | 0.52 | 4.90 | 7.00 |     0.11 |    -0.53 |         0
# versicolor | 0.30 | 2.00 | 3.40 |    -0.36 |    -0.37 |         0
# versicolor | 0.52 | 3.00 | 5.10 |    -0.61 |     0.05 |         0
# versicolor | 0.22 | 1.00 | 1.80 |    -0.03 |    -0.41 |         0
# virginica  | 0.59 | 4.90 | 7.90 |     0.12 |     0.03 |         0
# virginica  | 0.30 | 2.20 | 3.80 |     0.37 |     0.71 |         0
# virginica  | 0.67 | 4.50 | 6.90 |     0.55 |    -0.15 |         0
# virginica  | 0.30 | 1.40 | 2.50 |    -0.13 |    -0.60 |         0
```

### Correlations, t-test, and Wilcox test

`report` can also be used to provide automated summaries for statistical
model objects from correlation, *t*-tests, Wilcoxon tests, etc.

``` r

report(t.test(formula = mtcars$wt ~ mtcars$am))
# Effect sizes were labelled following Cohen's (1988)
# recommendations.
# 
# The Welch Two Sample t-test testing the difference of
# mtcars$wt by mtcars$am (mean in group 0 = 3.77, mean in
# group 1 = 2.41) suggests that the effect is positive,
# statistically significant, and large (difference = 1.36,
# 95% CI [0.85, 1.86], t(29.23) = 5.49, p < .001; Cohen's d =
# 1.93, 95% CI [1.08, 2.77])
```

``` r

report(cor.test(mtcars$mpg, mtcars$wt))
```

### Regression models

#### Linear regression (`lm`)

We will start out simple: a simple linear regression

``` r

model <- lm(wt ~ am + mpg, data = mtcars)

report(model)
# We fitted a linear model (estimated using OLS) to predict
# wt with am and mpg (formula: wt ~ am + mpg). The model
# explains a statistically significant and substantial
# proportion of variance (R2 = 0.80, F(2, 29) = 57.66, p <
# .001, adj. R2 = 0.79). The model's intercept, corresponding
# to am = 0 and mpg = 0, is at 5.74 (95% CI [5.11, 6.36],
# t(29) = 18.64, p < .001). Within this model:
# 
#   - The effect of am is statistically significant and
# negative (beta = -0.53, 95% CI [-0.94, -0.11], t(29) =
# -2.58, p = 0.015; Std. beta = -0.27, 95% CI [-0.48, -0.06])
#   - The effect of mpg is statistically significant and
# negative (beta = -0.11, 95% CI [-0.15, -0.08], t(29) =
# -6.79, p < .001; Std. beta = -0.71, 95% CI [-0.92, -0.49])
# 
# Standardized parameters were obtained by fitting the model
# on a standardized version of the dataset. 95% Confidence
# Intervals (CIs) and p-values were computed using a Wald
# t-distribution approximation.
```

#### anova (`aov`)

And its close cousin ANOVA is also covered by `report`:

``` r

model <- aov(wt ~ am + mpg, data = mtcars)

report(model)
# The ANOVA (formula: wt ~ am + mpg) suggests that:
# 
#   - The main effect of am is statistically significant and
# large (F(1, 29) = 69.21, p < .001; Eta2 (partial) = 0.70,
# 95% CI [0.54, 1.00])
#   - The main effect of mpg is statistically significant and
# large (F(1, 29) = 46.12, p < .001; Eta2 (partial) = 0.61,
# 95% CI [0.42, 1.00])
# 
# Effect sizes were labelled following Field's (2013)
# recommendations.
```

#### General Linear Models (GLMs) (`glm`)

``` r

model <- glm(vs ~ mpg + cyl, data = mtcars, family = "binomial")

report(model)
# We fitted a logistic model (estimated using ML) to predict
# vs with mpg and cyl (formula: vs ~ mpg + cyl). The model's
# explanatory power is substantial (Tjur's R2 = 0.67). The
# model's intercept, corresponding to mpg = 0 and cyl = 0, is
# at 15.97 (95% CI [-2.71, 44.69], p = 0.147). Within this
# model:
# 
#   - The effect of mpg is statistically non-significant and
# negative (beta = -0.16, 95% CI [-0.71, 0.34], p = 0.496;
# Std. beta = -0.98, 95% CI [-4.28, 2.03])
#   - The effect of cyl is statistically significant and
# negative (beta = -2.15, 95% CI [-5.19, -0.54], p = 0.047;
# Std. beta = -3.84, 95% CI [-9.26, -0.97])
# 
# Standardized parameters were obtained by fitting the model
# on a standardized version of the dataset. 95% Confidence
# Intervals (CIs) and p-values were computed using a Wald
# z-distribution approximation.
```

#### Linear Mixed-Effects Models (`merMod`)

``` r

library(lme4)

model <- lmer(Reaction ~ Days + (Days | Subject), data = sleepstudy)

report(model)
# We fitted a linear mixed model (estimated using REML and
# nloptwrap optimizer) to predict Reaction with Days
# (formula: Reaction ~ Days). The model included Days as
# random effects (formula: ~Days | Subject). The model's
# total explanatory power is substantial (conditional R2 =
# 0.80) and the part related to the fixed effects alone
# (marginal R2) is of 0.28. The model's intercept,
# corresponding to Days = 0, is at 251.41 (95% CI [237.94,
# 264.87], t(174) = 36.84, p < .001). Within this model:
# 
#   - The effect of Days is statistically significant and
# positive (beta = 10.47, 95% CI [7.42, 13.52], t(174) =
# 6.77, p < .001; Std. beta = 0.54, 95% CI [0.38, 0.69])
# 
# Standardized parameters were obtained by fitting the model
# on a standardized version of the dataset. 95% Confidence
# Intervals (CIs) and p-values were computed using a Wald
# t-distribution approximation.
```
