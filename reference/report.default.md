# Template to add report support for new objects

Template file to add report support for new objects. Check-out the
vignette on [Supporting New
Models](https://easystats.github.io/report/articles/new_models.html).

## Usage

``` r
# Default S3 method
report(x, ...)

# Default S3 method
report_effectsize(x, ...)

# Default S3 method
report_table(x, ...)

# Default S3 method
report_statistics(x, ...)

# Default S3 method
report_parameters(x, ...)

# Default S3 method
report_intercept(x, ...)

# Default S3 method
report_model(x, ...)

# Default S3 method
report_random(x, ...)

# Default S3 method
report_priors(x, ...)

# Default S3 method
report_performance(x, ...)

# Default S3 method
report_info(x, ...)

# Default S3 method
report_text(x, ...)
```

## Arguments

- x:

  Object of class `NEW OBJECT`.

- ...:

  Arguments passed to or from other methods.

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

- `report.default()`

## Examples

``` r
library(report)

# Add a reproducible example instead of the following
model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
r <- report(model)
r
#> We fitted a linear model (estimated using OLS) to predict Sepal.Length with
#> Petal.Length and Species (formula: Sepal.Length ~ Petal.Length * Species). The
#> model explains a statistically significant and substantial proportion of
#> variance (R2 = 0.84, F(5, 144) = 151.71, p < .001, adj. R2 = 0.83). The model's
#> intercept, corresponding to Petal.Length = 0 and Species = setosa, is at 4.21
#> (95% CI [3.41, 5.02], t(144) = 10.34, p < .001). Within this model:
#> 
#>   - The effect of Petal Length is statistically non-significant and positive
#> (beta = 0.54, 95% CI [-4.76e-03, 1.09], t(144) = 1.96, p = 0.052; Std. beta =
#> 1.16, 95% CI [-0.01, 2.32])
#>   - The effect of Species [versicolor] is statistically significant and negative
#> (beta = -1.81, 95% CI [-2.99, -0.62], t(144) = -3.02, p = 0.003; Std. beta =
#> -0.88, 95% CI [-2.41, 0.65])
#>   - The effect of Species [virginica] is statistically significant and negative
#> (beta = -3.15, 95% CI [-4.41, -1.90], t(144) = -4.97, p < .001; Std. beta =
#> -1.75, 95% CI [-3.32, -0.18])
#>   - The effect of Petal Length × Species [versicolor] is statistically
#> non-significant and positive (beta = 0.29, 95% CI [-0.30, 0.87], t(144) = 0.97,
#> p = 0.334; Std. beta = 0.61, 95% CI [-0.63, 1.85])
#>   - The effect of Petal Length × Species [virginica] is statistically
#> non-significant and positive (beta = 0.45, 95% CI [-0.12, 1.03], t(144) = 1.56,
#> p = 0.120; Std. beta = 0.97, 95% CI [-0.26, 2.19])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(r)
#> We fitted a linear model to predict Sepal.Length with Petal.Length and Species.
#> The model's explanatory power is substantial (R2 = 0.84, adj. R2 = 0.83). The
#> model's intercept is at 4.21 (95% CI [3.41, 5.02]). Within this model:
#> 
#>   - The effect of Petal Length is statistically non-significant and positive
#> (beta = 0.54, 95% CI [-4.76e-03, 1.09], t(144) = 1.96, p = 0.052, Std. beta =
#> 1.16)
#>   - The effect of Species [versicolor] is statistically significant and negative
#> (beta = -1.81, 95% CI [-2.99, -0.62], t(144) = -3.02, p = 0.003, Std. beta =
#> -0.88)
#>   - The effect of Species [virginica] is statistically significant and negative
#> (beta = -3.15, 95% CI [-4.41, -1.90], t(144) = -4.97, p < .001, Std. beta =
#> -1.75)
#>   - The effect of Petal Length × Species [versicolor] is statistically
#> non-significant and positive (beta = 0.29, 95% CI [-0.30, 0.87], t(144) = 0.97,
#> p = 0.334, Std. beta = 0.61)
#>   - The effect of Petal Length × Species [virginica] is statistically
#> non-significant and positive (beta = 0.45, 95% CI [-0.12, 1.03], t(144) = 1.56,
#> p = 0.120, Std. beta = 0.97)
as.data.frame(r)
#> Parameter                           | Coefficient |         95% CI | t(144)
#> ---------------------------------------------------------------------------
#> (Intercept)                         |        4.21 | [ 3.41,  5.02] |  10.34
#> Petal Length                        |        0.54 | [ 0.00,  1.09] |   1.96
#> Species [versicolor]                |       -1.81 | [-2.99, -0.62] |  -3.02
#> Species [virginica]                 |       -3.15 | [-4.41, -1.90] |  -4.97
#> Petal Length × Species [versicolor] |        0.29 | [-0.30,  0.87] |   0.97
#> Petal Length × Species [virginica]  |        0.45 | [-0.12,  1.03] |   1.56
#>                                     |             |                |       
#> AIC                                 |             |                |       
#> AICc                                |             |                |       
#> BIC                                 |             |                |       
#> R2                                  |             |                |       
#> R2 (adj.)                           |             |                |       
#> Sigma                               |             |                |       
#> 
#> Parameter                           |      p | Std. Coef. | Std. Coef. 95% CI |    Fit
#> --------------------------------------------------------------------------------------
#> (Intercept)                         | < .001 |       0.49 |    [-1.03,  2.01] |       
#> Petal Length                        | 0.052  |       1.16 |    [-0.01,  2.32] |       
#> Species [versicolor]                | 0.003  |      -0.88 |    [-2.41,  0.65] |       
#> Species [virginica]                 | < .001 |      -1.75 |    [-3.32, -0.18] |       
#> Petal Length × Species [versicolor] | 0.334  |       0.61 |    [-0.63,  1.85] |       
#> Petal Length × Species [virginica]  | 0.120  |       0.97 |    [-0.26,  2.19] |       
#>                                     |        |            |                   |       
#> AIC                                 |        |            |                   | 106.77
#> AICc                                |        |            |                   | 107.56
#> BIC                                 |        |            |                   | 127.84
#> R2                                  |        |            |                   |   0.84
#> R2 (adj.)                           |        |            |                   |   0.83
#> Sigma                               |        |            |                   |   0.34
summary(as.data.frame(r))
#> Parameter                           | Coefficient |         95% CI | t(144)
#> ---------------------------------------------------------------------------
#> (Intercept)                         |        4.21 | [ 3.41,  5.02] |  10.34
#> Petal Length                        |        0.54 | [ 0.00,  1.09] |   1.96
#> Species [versicolor]                |       -1.81 | [-2.99, -0.62] |  -3.02
#> Species [virginica]                 |       -3.15 | [-4.41, -1.90] |  -4.97
#> Petal Length × Species [versicolor] |        0.29 | [-0.30,  0.87] |   0.97
#> Petal Length × Species [virginica]  |        0.45 | [-0.12,  1.03] |   1.56
#>                                     |             |                |       
#> AICc                                |             |                |       
#> R2                                  |             |                |       
#> R2 (adj.)                           |             |                |       
#> Sigma                               |             |                |       
#> 
#> Parameter                           |      p | Std. Coef. |    Fit
#> ------------------------------------------------------------------
#> (Intercept)                         | < .001 |       0.49 |       
#> Petal Length                        | 0.052  |       1.16 |       
#> Species [versicolor]                | 0.003  |      -0.88 |       
#> Species [virginica]                 | < .001 |      -1.75 |       
#> Petal Length × Species [versicolor] | 0.334  |       0.61 |       
#> Petal Length × Species [virginica]  | 0.120  |       0.97 |       
#>                                     |        |            |       
#> AICc                                |        |            | 107.56
#> R2                                  |        |            |   0.84
#> R2 (adj.)                           |        |            |   0.83
#> Sigma                               |        |            |   0.34
```
