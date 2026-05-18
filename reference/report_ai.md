# Generate AI-optimized reports

This function is designed to produce AI-optimized output for statistical
models. It strikes a careful balance between comprehensiveness,
specificity, and compactness. The primary goal is to provide a Large
Language Model (LLM) or AI agent with the clearest and most relevant
analytical information at the lowest possible token cost.

## Usage

``` r
report_ai(x, ...)

# S3 method for class 'merMod'
report_ai(x, ...)

# S3 method for class 'glmmTMB'
report_ai(x, ...)
```

## Arguments

- x:

  A statistical model.

- ...:

  Arguments passed to other functions, like
  [`parameters::model_parameters()`](https://easystats.github.io/parameters/reference/model_parameters.html),
  [`performance::model_performance()`](https://easystats.github.io/performance/reference/model_performance.html)
  or
  [`insight::format_table()`](https://easystats.github.io/insight/reference/format_table.html).

## Value

A character vector of class `report_ai` containing the formatted text.

## Examples

``` r
m <- lm(mpg ~ wt + hp, data = mtcars)
report_ai(m)
#> ## Model
#> - Call: lm
#> - Formula: mpg ~ wt + hp
#> - Family: gaussian
#> - N: 32
#> - Inference: 95% CI [Wald]
#> 
#> ## Variables
#> 
#> - mpg: Mean = 20.09, SD = 6.03, range: [10.40, 33.90]
#> - wt: Mean = 3.22, SD = 0.98, range: [1.51, 5.42]
#> - hp: Mean = 146.69, SD = 68.56, range: [52, 335]
#> 
#> ## Parameters
#> |Parameter   | Coefficient|       SE|        95% CI |t(29) |     p |
#> |:-----------|-----------:|--------:|:--------------|:-----|:------|
#> |(Intercept) |       37.23|     1.60|[33.96, 40.50] |23.28 |< .001 |
#> |wt          |       -3.88|     0.63|[-5.17, -2.58] |-6.13 |< .001 |
#> |hp          |       -0.03| 9.03e-03|[-0.05, -0.01] |-3.52 |0.001  |
#> 
#> ## Performance
#> |AIC   | AICc |  BIC |  R2 | R2 (adj.)|RMSE | Sigma|
#> |:-----|:-----|:-----|:----|---------:|:----|-----:|
#> |156.7 |158.1 |162.5 |0.83 |      0.81|2.47 |  2.59|
#> 
#> ## Highlights
#> - Significant effects (p < 0.05): wt, hp 
# \donttest{
m <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
report_ai(m)
#> Package 'merDeriv' needs to be installed to compute confidence intervals
#>   for random effect parameters.
#> ## Model
#> - Call: lmer
#> - Formula: Reaction ~ Days
#> - Family: gaussian
#> - N: 180
#> - Inference: 95% CI [Residual df (t/F)]
#> 
#> ## Variables
#> 
#> - Reaction: Mean = 298.51, SD = 56.33, range: [194.33, 466.35]
#> - Days: Mean = 4.50, SD = 2.88, range: [0, 9]
#> 
#> ## Parameters
#> |Parameter   | Coefficient|  SE |          95% CI | t(176)|     p | Effects| Group|
#> |:-----------|-----------:|:----|:----------------|------:|:------|-------:|-----:|
#> |(Intercept) |      251.41|9.75 |[232.17, 270.64] |  25.79|< .001 |   fixed|      |
#> |Days        |       10.47|0.80 |[  8.88,  12.05] |  13.02|< .001 |   fixed|      |
#> 
#> ### Random Effects
#> - SD (Intercept) [Subject]: 37.124
#> - SD (Observations) [Residual]: 30.991
#> 
#> ## Performance
#> |AIC    |  AICc |   BIC | R2 (cond.)| R2 (marg.)| ICC | RMSE |Sigma |
#> |:------|:------|:------|----------:|----------:|:----|:-----|:-----|
#> |1794.5 |1794.7 |1807.2 |       0.70|       0.28|0.59 |29.41 |30.99 |
#> 
#> ## Highlights
#> - Significant effects (p < 0.05): Days 
# }
# \donttest{
m <- glmmTMB::glmmTMB(count ~ mined + (1 | site), family = poisson(), data = glmmTMB::Salamanders)
report_ai(m)
#> ## Model
#> - Call: glmmTMB
#> - Formula: count ~ mined
#> - Family: poisson
#> - N: 644
#> - Inference: 95% CI [Wald]
#> 
#> ## Variables
#> 
#> - count: Mean = 1.32, SD = 2.64, range: [0, 36]
#> - mined: 2 levels, namely yes (n = 308) and no (n = 336)
#> 
#> ## Parameters
#> |Parameter   | Coefficient|  SE |        95% CI |    z | df |     p | Effects| Group|  Component |
#> |:-----------|-----------:|:----|:--------------|:-----|:---|:------|-------:|-----:|:-----------|
#> |(Intercept) |       -1.51|0.22 |[-1.94, -1.07] |-6.75 |Inf |< .001 |   fixed|      |conditional |
#> |mined [no]  |        2.26|0.28 |[ 1.72,  2.81] | 8.08 |Inf |< .001 |   fixed|      |conditional |
#> 
#> ### Random Effects
#> - SD (Intercept) [site]: 0.576
#> 
#> ## Performance
#> |AIC    |  AICc |   BIC | R2 (cond.)| R2 (marg.)| ICC |RMSE | Sigma| Score_log| Score_spherical|
#> |:------|:------|:------|----------:|----------:|:----|:----|-----:|---------:|---------------:|
#> |2215.7 |2215.7 |2229.1 |       0.79|       0.63|0.43 |2.37 |     1|     -1.66|            0.03|
#> 
#> ## Highlights
#> - Significant effects (p < 0.05): minedno 
# }
```
