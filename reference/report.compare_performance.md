# Reporting models comparison

Create reports for model comparison as obtained by the
[`performance::compare_performance()`](https://easystats.github.io/performance/reference/compare_performance.html)
function in the `performance` package.

## Usage

``` r
# S3 method for class 'compare_performance'
report(x, ...)

# S3 method for class 'compare_performance'
report_table(x, ...)

# S3 method for class 'compare_performance'
report_statistics(x, table = NULL, ...)

# S3 method for class 'compare_performance'
report_parameters(x, table = NULL, ...)

# S3 method for class 'compare_performance'
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

x <- performance::compare_performance(m1, m2, m3)
r <- report(x)
r
#> We compared three models; lm (R2 = 0.84, adj. R2 = 0.83, AIC = 106.77, BIC =
#> 127.84, RMSE = 0.33, Sigma = 0.34), lm (R2 = 0.84, adj. R2 = 0.83, AIC =
#> 106.23, BIC = 121.29, RMSE = 0.33, Sigma = 0.34) and lm (R2 = 0.76, adj. R2 =
#> 0.76, AIC = 160.04, BIC = 169.07, RMSE = 0.40, Sigma = 0.41).
summary(r)
#> We compared three models; lm (adj. R2 = 0.83, BIC = 127.84), lm (adj. R2 =
#> 0.83, BIC = 121.29) and lm (adj. R2 = 0.76, BIC = 169.07).
as.data.frame(r)
#> Name | Model | AIC (weights) | AICc (weights) | BIC (weights) |   R2
#> --------------------------------------------------------------------
#> m1   |    lm |  106.8 (0.43) |   107.6 (0.39) |  127.8 (0.04) | 0.84
#> m2   |    lm |  106.2 (0.57) |   106.6 (0.61) |  121.3 (0.96) | 0.84
#> m3   |    lm | 160.0 (<.001) |  160.2 (<.001) | 169.1 (<.001) | 0.76
#> 
#> Name | R2 (adj.) | RMSE | Sigma
#> -------------------------------
#> m1   |      0.83 | 0.33 |  0.34
#> m2   |      0.83 | 0.33 |  0.34
#> m3   |      0.76 | 0.40 |  0.41
summary(as.data.frame(r))
#> Name | Model | AIC (weights) | AICc (weights) | BIC (weights) |   R2
#> --------------------------------------------------------------------
#> m1   |    lm |  106.8 (0.43) |   107.6 (0.39) |  127.8 (0.04) | 0.84
#> m2   |    lm |  106.2 (0.57) |   106.6 (0.61) |  121.3 (0.96) | 0.84
#> m3   |    lm | 160.0 (<.001) |  160.2 (<.001) | 169.1 (<.001) | 0.76
#> 
#> Name | R2 (adj.) | RMSE
#> -----------------------
#> m1   |      0.83 | 0.33
#> m2   |      0.83 | 0.33
#> m3   |      0.76 | 0.40

# Specific reports
report_table(x)
#> Name | Model | AIC (weights) | AICc (weights) | BIC (weights) |   R2
#> --------------------------------------------------------------------
#> m1   |    lm |  106.8 (0.43) |   107.6 (0.39) |  127.8 (0.04) | 0.84
#> m2   |    lm |  106.2 (0.57) |   106.6 (0.61) |  121.3 (0.96) | 0.84
#> m3   |    lm | 160.0 (<.001) |  160.2 (<.001) | 169.1 (<.001) | 0.76
#> 
#> Name | R2 (adj.) | RMSE | Sigma
#> -------------------------------
#> m1   |      0.83 | 0.33 |  0.34
#> m2   |      0.83 | 0.33 |  0.34
#> m3   |      0.76 | 0.40 |  0.41
report_statistics(x)
#> R2 = 0.84, adj. R2 = 0.83, AIC = 106.77, BIC = 127.84, RMSE = 0.33, Sigma = 0.34
#> R2 = 0.84, adj. R2 = 0.83, AIC = 106.23, BIC = 121.29, RMSE = 0.33, Sigma = 0.34
#> R2 = 0.76, adj. R2 = 0.76, AIC = 160.04, BIC = 169.07, RMSE = 0.40, Sigma = 0.41
report_parameters(x)
#>   - lm (R2 = 0.84, adj. R2 = 0.83, AIC = 106.77, BIC = 127.84, RMSE = 0.33, Sigma = 0.34)
#>   - lm (R2 = 0.84, adj. R2 = 0.83, AIC = 106.23, BIC = 121.29, RMSE = 0.33, Sigma = 0.34)
#>   - lm (R2 = 0.76, adj. R2 = 0.76, AIC = 160.04, BIC = 169.07, RMSE = 0.40, Sigma = 0.41)
# }
```
