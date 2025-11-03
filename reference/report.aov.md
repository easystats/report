# Reporting ANOVAs

Create reports for ANOVA models.

## Usage

``` r
# S3 method for class 'aov'
report(x, ...)

# S3 method for class 'aov'
report_effectsize(x, include_intercept = FALSE, ...)

# S3 method for class 'aov'
report_table(x, include_intercept = FALSE, ...)

# S3 method for class 'aov'
report_statistics(x, table = NULL, ...)

# S3 method for class 'aov'
report_parameters(x, ...)

# S3 method for class 'aov'
report_model(x, table = NULL, ...)

# S3 method for class 'aov'
report_info(x, effectsize = NULL, ...)

# S3 method for class 'aov'
report_text(x, table = NULL, ...)
```

## Arguments

- x:

  Object of class `aov`, `anova` or `aovlist`.

- ...:

  Arguments passed to or from other methods.

- include_intercept:

  Set to `TRUE` to include the intercept (relevant for type-3 ANOVA
  tables).

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
data <- iris
data$Cat1 <- rep(c("A", "B"), length.out = nrow(data))

model <- aov(Sepal.Length ~ Species * Cat1, data = data)
r <- report(model)
r
#> The ANOVA (formula: Sepal.Length ~ Species * Cat1) suggests that:
#> 
#>   - The main effect of Species is statistically significant and large (F(2, 144)
#> = 118.43, p < .001; Eta2 (partial) = 0.62, 95% CI [0.54, 1.00])
#>   - The main effect of Cat1 is statistically not significant and very small (F(1,
#> 144) = 6.25e-03, p = 0.937; Eta2 (partial) = 4.34e-05, 95% CI [0.00, 1.00])
#>   - The interaction between Species and Cat1 is statistically not significant and
#> small (F(2, 144) = 0.98, p = 0.377; Eta2 (partial) = 0.01, 95% CI [0.00, 1.00])
#> 
#> Effect sizes were labelled following Field's (2013) recommendations.
summary(r)
#> The ANOVA suggests that:
#> 
#>   - The main effect of Species is statistically significant and large (F(2, 144)
#> = 118.43, p < .001, Eta2 (partial) = 0.62)
#>   - The main effect of Cat1 is statistically not significant and very small (F(1,
#> 144) = 6.25e-03, p = 0.937, Eta2 (partial) = 4.34e-05)
#>   - The interaction between Species and Cat1 is statistically not significant and
#> small (F(2, 144) = 0.98, p = 0.377, Eta2 (partial) = 0.01)
as.data.frame(r)
#> Parameter    | Sum_Squares |  df | Mean_Square |        F |      p
#> ------------------------------------------------------------------
#> Species      |       63.21 |   2 |       31.61 |   118.43 | < .001
#> Cat1         |    1.67e-03 |   1 |    1.67e-03 | 6.25e-03 | 0.937 
#> Species:Cat1 |        0.52 |   2 |        0.26 |     0.98 | 0.377 
#> Residuals    |       38.43 | 144 |        0.27 |          |       
#> 
#> Parameter    | Eta2 (partial) | Eta2_partial 95% CI
#> ---------------------------------------------------
#> Species      |           0.62 |        [0.54, 1.00]
#> Cat1         |       4.34e-05 |        [0.00, 1.00]
#> Species:Cat1 |           0.01 |        [0.00, 1.00]
#> Residuals    |                |                    
summary(as.data.frame(r))
#> Parameter    | Sum_Squares |  df | Mean_Square |        F |      p | Eta2 (partial)
#> -----------------------------------------------------------------------------------
#> Species      |       63.21 |   2 |       31.61 |   118.43 | < .001 |           0.62
#> Cat1         |    1.67e-03 |   1 |    1.67e-03 | 6.25e-03 | 0.937  |       4.34e-05
#> Species:Cat1 |        0.52 |   2 |        0.26 |     0.98 | 0.377  |           0.01
#> Residuals    |       38.43 | 144 |        0.27 |          |        |               
```
