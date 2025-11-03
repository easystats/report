# Reporting models comparison

Create reports for model comparison as obtained by the
[`performance::compare_performance()`](https://easystats.github.io/performance/reference/compare_performance.html)
function in the `performance` package.

## Usage

``` r
# S3 method for class 'test_performance'
report(x, ...)

# S3 method for class 'test_performance'
report_table(x, ...)

# S3 method for class 'test_performance'
report_statistics(x, table = NULL, ...)

# S3 method for class 'test_performance'
report_parameters(x, table = NULL, ...)

# S3 method for class 'test_performance'
report_text(x, table = NULL, ...)
```

## Arguments

- x:

  Object of class `NEW OBJECT`.

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
# \donttest{
library(report)
library(performance)

m1 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
m2 <- lm(Sepal.Length ~ Petal.Length + Species, data = iris)
m3 <- lm(Sepal.Length ~ Petal.Length, data = iris)

x <- performance::test_performance(m1, m2, m3)
r <- report(x)
r
#> We compared three models; lm (BF = 26.52), lm (BF = 4.20e-11) and lm (BF =
#> 26.52).
summary(r)
#> We compared three models; lm (), lm () and lm ().
as.data.frame(r)
#> Name | Model |      BF | df | df_diff |  Chi2 |      p
#> ------------------------------------------------------
#> m1   |    lm |         |  7 |         |       |       
#> m2   |    lm |   26.52 |  5 |      -2 |  3.47 | 0.177 
#> m3   |    lm | < 0.001 |  3 |      -2 | 57.81 | < .001
#> Models were detected as nested (in terms of fixed parameters) and are compared in sequential order.
summary(as.data.frame(r))
#> Name | Model |      BF | df | df_diff |  Chi2 |      p
#> ------------------------------------------------------
#> m1   |    lm |         |  7 |         |       |       
#> m2   |    lm |   26.52 |  5 |      -2 |  3.47 | 0.177 
#> m3   |    lm | < 0.001 |  3 |      -2 | 57.81 | < .001
#> Models were detected as nested (in terms of fixed parameters) and are compared in sequential order.

# Specific reports
report_table(x)
#> Name | Model |      BF | df | df_diff |  Chi2 |      p
#> ------------------------------------------------------
#> m1   |    lm |         |  7 |         |       |       
#> m2   |    lm |   26.52 |  5 |      -2 |  3.47 | 0.177 
#> m3   |    lm | < 0.001 |  3 |      -2 | 57.81 | < .001
#> Models were detected as nested (in terms of fixed parameters) and are compared in sequential order.
report_statistics(x)
#> BF = 26.52
#> BF = 4.20e-11
report_parameters(x)
#>   - lm (BF = 26.52)
#>   - lm (BF = 4.20e-11)
#>   - lm (BF = 26.52)
# }
```
