# Reporting `htest` objects (Correlation, t-test...)

Create reports for `htest` objects
([`t.test()`](https://rdrr.io/r/stats/t.test.html),
[`cor.test()`](https://rdrr.io/r/stats/cor.test.html), etc.).

## Usage

``` r
# S3 method for class 'htest'
report(x, ...)

# S3 method for class 'htest'
report_effectsize(x, table = NULL, ...)

# S3 method for class 'htest'
report_table(x, ...)

# S3 method for class 'htest'
report_statistics(x, table = NULL, ...)

# S3 method for class 'htest'
report_parameters(x, table = NULL, ...)

# S3 method for class 'htest'
report_model(x, table = NULL, ...)

# S3 method for class 'htest'
report_info(x, effectsize = NULL, ...)

# S3 method for class 'htest'
report_text(x, table = NULL, ...)
```

## Arguments

- x:

  Object of class `htest`.

- ...:

  Arguments passed to or from other methods.

- table:

  Provide the output of
  [`report_table()`](https://easystats.github.io/report/reference/report_table.md)
  to avoid its re-computation.

- effectsize:

  Provide the output of
  [`report_effectsize()`](https://easystats.github.io/report/reference/report_effectsize.md)
  to avoid its re-computation.

## Value

An object of class
[`report()`](https://easystats.github.io/report/reference/report.md).

## See also

Specific components of reports (especially for stats models):

- [`report_table()`](https://easystats.github.io/report/reference/report_table.md)

- [`report_parameters()`](https://easystats.github.io/report/reference/report_parameters.md)

- [`report_statistics()`](https://easystats.github.io/report/reference/report_statistics.md)

- [`report_effectsize()`](https://easystats.github.io/report/reference/report_effectsize.md)

- [`report_model()`](https://easystats.github.io/report/reference/report_model.md)

- [`report_priors()`](https://easystats.github.io/report/reference/report_priors.md)

- [`report_random()`](https://easystats.github.io/report/reference/report_random.md)

- [`report_performance()`](https://easystats.github.io/report/reference/report_performance.md)

- [`report_info()`](https://easystats.github.io/report/reference/report_info.md)

- [`report_text()`](https://easystats.github.io/report/reference/report_text.md)

Other types of reports:

- [`report_system()`](https://easystats.github.io/report/reference/report.sessionInfo.md)

- [`report_packages()`](https://easystats.github.io/report/reference/report.sessionInfo.md)

- [`report_participants()`](https://easystats.github.io/report/reference/report_participants.md)

- [`report_sample()`](https://easystats.github.io/report/reference/report_sample.md)

- [`report_date()`](https://easystats.github.io/report/reference/report_date.md)

Methods:

- [`as.report()`](https://easystats.github.io/report/reference/as.report.md)

Template file for supporting new models:

- [`report.default()`](https://easystats.github.io/report/reference/report.default.md)

## Examples

``` r
# t-tests
report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The Welch Two Sample t-test testing the difference between iris$Sepal.Width and
#> iris$Sepal.Length (mean of x = 3.06, mean of y = 5.84) suggests that the effect
#> is negative, statistically significant, and large (difference = -2.79, 95% CI
#> [-2.94, -2.64], t(225.68) = -36.46, p < .001; Cohen's d = -4.21, 95% CI [-4.66,
#> -3.76])
report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The Two Sample t-test testing the difference between iris$Sepal.Width and
#> iris$Sepal.Length (mean of x = 3.06, mean of y = 5.84) suggests that the effect
#> is negative, statistically significant, and large (difference = -2.79, 95% CI
#> [-2.94, -2.64], t(298) = -36.46, p < .001; Cohen's d = -4.21, 95% CI [-4.61,
#> -3.80])
report(t.test(mtcars$mpg ~ mtcars$vs))
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The Welch Two Sample t-test testing the difference of mtcars$mpg by mtcars$vs
#> (mean in group 0 = 16.62, mean in group 1 = 24.56) suggests that the effect is
#> negative, statistically significant, and large (difference = -7.94, 95% CI
#> [-11.46, -4.42], t(22.72) = -4.67, p < .001; Cohen's d = -1.70, 95% CI [-2.55,
#> -0.82])
report(t.test(mtcars$mpg, mtcars$vs, paired = TRUE), verbose = FALSE)
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The Paired t-test testing the difference between mtcars$mpg and mtcars$vs (mean
#> difference = 19.65) suggests that the effect is positive, statistically
#> significant, and large (difference = 19.65, 95% CI [17.60, 21.71], t(31) =
#> 19.49, p < .001; Cohen's d = 3.45, 95% CI [2.52, 4.36])
report(t.test(iris$Sepal.Width, mu = 1))
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The One Sample t-test testing the difference between iris$Sepal.Width (mean =
#> 3.06) and mu = 1 suggests that the effect is positive, statistically
#> significant, and large (difference = 2.06, 95% CI [2.99, 3.13], t(149) = 57.81,
#> p < .001; Cohen's d = 4.72, 95% CI [4.15, 5.27])

# Correlations
report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#> Effect sizes were labelled following Funder's (2019) recommendations.
#> 
#> The Pearson's product-moment correlation between iris$Sepal.Width and
#> iris$Sepal.Length is negative, statistically not significant, and small (r =
#> -0.12, 95% CI [-0.27, 0.04], t(148) = -1.44, p = 0.152)
```
