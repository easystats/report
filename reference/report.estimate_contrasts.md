# Reporting `estimate_contrasts` objects

Create reports for `estimate_contrasts` objects.

## Usage

``` r
# S3 method for class 'estimate_contrasts'
report(x, ...)

# S3 method for class 'estimate_contrasts'
report_table(x, ...)

# S3 method for class 'estimate_contrasts'
report_text(x, table = NULL, ...)
```

## Arguments

- x:

  Object of class `estimate_contrasts`.

- ...:

  Arguments passed to or from other methods.

- table:

  Provide the output of
  [`report_table()`](https://easystats.github.io/report/reference/report_table.md)
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
library(modelbased)
model <- lm(Sepal.Width ~ Species, data = iris)
contr <- estimate_contrasts(model)
#> We selected `contrast=c("Species")`.
report(contr)
#> The marginal contrasts analysis suggests the following. The difference between
#> versicolor and setosa is negative and statistically significant (difference =
#> -0.66, 95% CI [-0.79, -0.52], t(147) = -9.69, p < .001). The difference between
#> virginica and setosa is negative and statistically significant (difference =
#> -0.45, 95% CI [-0.59, -0.32], t(147) = -6.68, p < .001). The difference between
#> virginica and versicolor is positive and statistically significant (difference
#> = 0.20, 95% CI [ 0.07, 0.34], t(147) = 3.00, p = 0.003)
```
