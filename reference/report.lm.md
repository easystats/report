# Reporting (General) Linear Models

Create reports for (general) linear models.

## Usage

``` r
# S3 method for class 'lm'
report(x, include_effectsize = TRUE, effectsize_method = "refit", ...)

# S3 method for class 'lm'
report_effectsize(x, effectsize_method = "refit", ...)

# S3 method for class 'lm'
report_table(x, include_effectsize = TRUE, ...)

# S3 method for class 'lm'
report_statistics(
  x,
  table = NULL,
  include_effectsize = TRUE,
  include_diagnostic = TRUE,
  ...
)

# S3 method for class 'lm'
report_parameters(
  x,
  table = NULL,
  include_effectsize = TRUE,
  include_intercept = TRUE,
  ...
)

# S3 method for class 'lm'
report_intercept(x, table = NULL, ...)

# S3 method for class 'lm'
report_model(x, table = NULL, ...)

# S3 method for class 'lm'
report_performance(x, table = NULL, ...)

# S3 method for class 'lm'
report_info(
  x,
  effectsize = NULL,
  include_effectsize = FALSE,
  parameters = NULL,
  ...
)

# S3 method for class 'lm'
report_text(x, table = NULL, ...)

# S3 method for class 'merMod'
report_random(x, ...)
```

## Arguments

- x:

  Object of class `lm` or `glm`.

- include_effectsize:

  If `FALSE`, won't include effect-size related indices (standardized
  coefficients, etc.).

- effectsize_method:

  See documentation for
  [`effectsize::effectsize()`](https://easystats.github.io/effectsize/reference/effectsize.html).

- ...:

  Arguments passed to or from other methods.

- table:

  Provide the output of
  [`report_table()`](https://easystats.github.io/report/reference/report_table.md)
  to avoid its re-computation.

- include_diagnostic:

  If `FALSE`, won't include diagnostic related indices for Bayesian
  models (ESS, Rhat).

- include_intercept:

  If `FALSE`, won't include the intercept.

- effectsize:

  Provide the output of
  [`report_effectsize()`](https://easystats.github.io/report/reference/report_effectsize.md)
  to avoid its re-computation.

- parameters:

  Provide the output of
  [`report_parameters()`](https://easystats.github.io/report/reference/report_parameters.md)
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

# Linear models
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

# Logistic models
model <- glm(vs ~ disp, data = mtcars, family = "binomial")
r <- report(model)
r
#> We fitted a logistic model (estimated using ML) to predict vs with disp
#> (formula: vs ~ disp). The model's explanatory power is substantial (Tjur's R2 =
#> 0.53). The model's intercept, corresponding to disp = 0, is at 4.14 (95% CI
#> [1.81, 7.44], p = 0.003). Within this model:
#> 
#>   - The effect of disp is statistically significant and negative (beta = -0.02,
#> 95% CI [-0.04, -0.01], p = 0.002; Std. beta = -2.68, 95% CI [-4.90, -1.27])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald z-distribution approximation.
summary(r)
#> We fitted a logistic model to predict vs with disp. The model's explanatory
#> power is substantial (Tjur's R2 = 0.53). The model's intercept is at 4.14 (95%
#> CI [1.81, 7.44]). Within this model:
#> 
#>   - The effect of disp is statistically significant and negative (beta = -0.02,
#> 95% CI [-0.04, -0.01], p = 0.002, Std. beta = -2.68)
as.data.frame(r)
#> Parameter   | Coefficient |         95% CI |     z |     p | Std. Coef.
#> -----------------------------------------------------------------------
#> (Intercept) |        4.14 | [ 1.81,  7.44] |  2.98 | 0.003 |      -0.85
#> disp        |       -0.02 | [-0.04, -0.01] | -3.03 | 0.002 |      -2.68
#>             |             |                |       |       |           
#> AIC         |             |                |       |       |           
#> AICc        |             |                |       |       |           
#> BIC         |             |                |       |       |           
#> Tjur's R2   |             |                |       |       |           
#> Sigma       |             |                |       |       |           
#> Log_loss    |             |                |       |       |           
#> 
#> Parameter   | Std. Coef. 95% CI |   Fit
#> ---------------------------------------
#> (Intercept) |    [-2.42,  0.27] |      
#> disp        |    [-4.90, -1.27] |      
#>             |                   |      
#> AIC         |                   | 26.70
#> AICc        |                   | 27.11
#> BIC         |                   | 29.63
#> Tjur's R2   |                   |  0.53
#> Sigma       |                   |  1.00
#> Log_loss    |                   |  0.35
summary(as.data.frame(r))
#> Parameter   | Coefficient |         95% CI |     z |     p | Std. Coef. |   Fit
#> -------------------------------------------------------------------------------
#> (Intercept) |        4.14 | [ 1.81,  7.44] |  2.98 | 0.003 |      -0.85 |      
#> disp        |       -0.02 | [-0.04, -0.01] | -3.03 | 0.002 |      -2.68 |      
#>             |             |                |       |       |            |      
#> AICc        |             |                |       |       |            | 27.11
#> Tjur's R2   |             |                |       |       |            |  0.53
#> Sigma       |             |                |       |       |            |  1.00
#> Log_loss    |             |                |       |       |            |  0.35
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
r <- report(model)
r
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict Sepal.Length with Petal.Length (formula: Sepal.Length ~
#> Petal.Length). The model included Species as random effect (formula: ~1 |
#> Species). The model's total explanatory power is substantial (conditional R2 =
#> 0.97) and the part related to the fixed effects alone (marginal R2) is of 0.66.
#> The model's intercept, corresponding to Petal.Length = 0, is at 2.50 (95% CI
#> [1.19, 3.82], t(146) = 3.75, p < .001). Within this model:
#> 
#>   - The effect of Petal Length is statistically significant and positive (beta =
#> 0.89, 95% CI [0.76, 1.01], t(146) = 13.93, p < .001; Std. beta = 1.89, 95% CI
#> [1.63, 2.16])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(r)
#> We fitted a linear mixed model to predict Sepal.Length with Petal.Length. The
#> model included Species as random effect. The model's total explanatory power is
#> substantial (conditional R2 = 0.97) and the part related to the fixed effects
#> alone (marginal R2) is of 0.66. The model's intercept is at 2.50 (95% CI [1.19,
#> 3.82]). Within this model:
#> 
#>   - The effect of Petal Length is statistically significant and positive (beta =
#> 0.89, 95% CI [0.76, 1.01], t(146) = 13.93, p < .001, Std. beta = 1.89)
as.data.frame(r)
#> Parameter        | Coefficient |       95% CI | t(146) |      p | Effects
#> -------------------------------------------------------------------------
#> (Intercept)      |        2.50 | [1.19, 3.82] |   3.75 | < .001 |   fixed
#> Petal Length     |        0.89 | [0.76, 1.01] |  13.93 | < .001 |   fixed
#>                  |        1.08 |              |        |        |  random
#>                  |        0.34 |              |        |        |  random
#>                  |             |              |        |        |        
#> AIC              |             |              |        |        |        
#> AICc             |             |              |        |        |        
#> BIC              |             |              |        |        |        
#> R2 (conditional) |             |              |        |        |        
#> R2 (marginal)    |             |              |        |        |        
#> Sigma            |             |              |        |        |        
#> 
#> Parameter        |    Group | Std. Coef. | Std. Coef. 95% CI |    Fit
#> ---------------------------------------------------------------------
#> (Intercept)      |          |  -1.46e-13 |     [-1.49, 1.49] |       
#> Petal Length     |          |       1.89 |     [ 1.63, 2.16] |       
#>                  |  Species |            |                   |       
#>                  | Residual |            |                   |       
#>                  |          |            |                   |       
#> AIC              |          |            |                   | 127.79
#> AICc             |          |            |                   | 128.07
#> BIC              |          |            |                   | 139.84
#> R2 (conditional) |          |            |                   |   0.97
#> R2 (marginal)    |          |            |                   |   0.66
#> Sigma            |          |            |                   |   0.34
summary(as.data.frame(r))
#> Parameter        | Coefficient |       95% CI | t(146) |      p | Effects
#> -------------------------------------------------------------------------
#> (Intercept)      |        2.50 | [1.19, 3.82] |   3.75 | < .001 |   fixed
#> Petal Length     |        0.89 | [0.76, 1.01] |  13.93 | < .001 |   fixed
#>                  |        1.08 |              |        |        |  random
#>                  |        0.34 |              |        |        |  random
#>                  |             |              |        |        |        
#> AICc             |             |              |        |        |        
#> R2 (conditional) |             |              |        |        |        
#> R2 (marginal)    |             |              |        |        |        
#> Sigma            |             |              |        |        |        
#> 
#> Parameter        |    Group | Std. Coef. |    Fit
#> -------------------------------------------------
#> (Intercept)      |          |  -1.46e-13 |       
#> Petal Length     |          |       1.89 |       
#>                  |  Species |            |       
#>                  | Residual |            |       
#>                  |          |            |       
#> AICc             |          |            | 128.07
#> R2 (conditional) |          |            |   0.97
#> R2 (marginal)    |          |            |   0.66
#> Sigma            |          |            |   0.34
# }
```
