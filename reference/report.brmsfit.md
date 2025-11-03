# Reporting Bayesian Models from brms

Create reports for Bayesian models. The description of the parameters
follows the Sequential Effect eXistence and sIgnificance Testing
framework (see [SEXIT
documentation](https://easystats.github.io/bayestestR/reference/sexit.html)).

## Usage

``` r
# S3 method for class 'brmsfit'
report(x, ...)

# S3 method for class 'brmsfit'
report_effectsize(x, effectsize_method = "basic", ...)
```

## Arguments

- x:

  Object of class `lm` or `glm`.

- ...:

  Arguments passed to or from other methods.

- effectsize_method:

  Method for computing effect sizes. For `brmsfit` objects, defaults to
  `"basic"` (faster, no refitting) instead of `"refit"` to improve
  performance with large Bayesian models. See documentation for
  [`effectsize::effectsize()`](https://easystats.github.io/effectsize/reference/effectsize.html).

## Value

An object of class
[`report()`](https://easystats.github.io/report/reference/report.md).

## Details

Message from the `rstan` package: "To avoid recompilation of unchanged
Stan programs, we recommend calling `rstan_options(auto_write = TRUE)`"

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
# Bayesian models
library(brms)
model <- suppressWarnings(brm(mpg ~ qsec + wt,
  data = mtcars,
  refresh = 0, iter = 300
))
#> Compiling Stan program...
#> Start sampling
r <- report(model, verbose = FALSE)
r
#> We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
#> of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
#> (formula: mpg ~ qsec + wt). Priors were: Slopes (b_Intercept) ~ Student-t(df =
#> 3.00, μ = 19.20, σ = 5.40); σ ~ Student-t⁺(df = 3.00, μ = 0.00, σ = 5.40). The
#> model's explanatory power is substantial (R2 = 0.82, 95% CI [0.75, 0.85], adj.
#> R2 = 0.78). Within this model:
#> 
#>   - The effect of b Intercept (Median = 19.51, 95% CI [9.40, 30.15]) has a
#> 100.00% probability of being positive (> 0), 100.00% of being significant (>
#> 0.30), and 100.00% of being large (> 1.81). The estimation successfully
#> converged (Rhat = 0.998) but the indices are unreliable (ESS = 507)
#>   - The effect of b qsec (Median = 0.93, 95% CI [0.42, 1.48]) has a 100.00%
#> probability of being positive (> 0), 99.17% of being significant (> 0.30), and
#> 0.00% of being large (> 1.81). The estimation successfully converged (Rhat =
#> 0.998) but the indices are unreliable (ESS = 466)
#>   - The effect of b wt (Median = -5.02, 95% CI [-6.03, -3.93]) has a 100.00%
#> probability of being negative (< 0), 100.00% of being significant (< -0.30),
#> and 100.00% of being large (< -1.81). The estimation successfully converged
#> (Rhat = 1.000) but the indices are unreliable (ESS = 712)
#> 
#> Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
#> framework, we report the median of the posterior distribution and its 95% CI
#> (Highest Density Interval), along the probability of direction (pd), the
#> probability of significance and the probability of being large. The thresholds
#> beyond which the effect is considered as significant (i.e., non-negligible) and
#> large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
#> outcome's SD). Convergence and stability of the Bayesian sampling has been
#> assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
#> Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).
summary(r)
#> We fitted a Bayesian linear model to predict mpg with qsec and wt. Priors were:
#> Slopes (b_Intercept) ~ Student-t(df = 3.00, μ = 19.20, σ = 5.40); σ ~
#> Student-t⁺(df = 3.00, μ = 0.00, σ = 5.40). The model's explanatory power is
#> substantial (R2 = 0.82, adj. R2 = 0.78). Within this model:
#> 
#>   - The effect of b Intercept (Median = 19.51, 95% CI [9.40, 30.15]) has 100.00%,
#> 100.00% and 100.00% probability of being positive (> 0), significant (> 0.30)
#> and large (> 1.81). The estimation successfully converged (Rhat = 0.998) but
#> the indices are unreliable (ESS = 507)
#>   - The effect of b qsec (Median = 0.93, 95% CI [0.42, 1.48]) has 100.00%, 99.17%
#> and 0.00% probability of being positive (> 0), significant (> 0.30) and large
#> (> 1.81). The estimation successfully converged (Rhat = 0.998) but the indices
#> are unreliable (ESS = 466)
#>   - The effect of b wt (Median = -5.02, 95% CI [-6.03, -3.93]) has 100.00%,
#> 100.00% and 100.00% probability of being negative (< 0), significant (< -0.30)
#> and large (< -1.81). The estimation successfully converged (Rhat = 1.000) but
#> the indices are unreliable (ESS = 712)
as.data.frame(r)
#> Parameter   |   Component | Median |         95% CI |   pd |  Rhat | ESS |    Fit
#> ---------------------------------------------------------------------------------
#> (Intercept) | conditional |  19.51 | [ 9.40, 30.15] | 100% | 0.998 | 507 |       
#> qsec        | conditional |   0.93 | [ 0.42,  1.48] | 100% | 0.998 | 466 |       
#> wt          | conditional |  -5.02 | [-6.03, -3.93] | 100% | 1.000 | 712 |       
#> sigma       |       sigma |   2.66 | [ 2.10,  3.54] | 100% | 1.007 | 321 |       
#>             |             |        |                |      |       |     |       
#> ELPD        |             |        |                |      |       |     | -79.08
#> LOOIC       |             |        |                |      |       |     | 158.16
#> WAIC        |             |        |                |      |       |     | 157.98
#> R2          |             |        |                |      |       |     |   0.82
#> R2 (adj.)   |             |        |                |      |       |     |   0.78
#> Sigma       |             |        |                |      |       |     |   2.69
summary(as.data.frame(r))
#> Parameter   |   Component | Median |         95% CI |   pd |  Rhat | ESS |  Fit
#> -------------------------------------------------------------------------------
#> (Intercept) | conditional |  19.51 | [ 9.40, 30.15] | 100% | 0.998 | 507 |     
#> qsec        | conditional |   0.93 | [ 0.42,  1.48] | 100% | 0.998 | 466 |     
#> wt          | conditional |  -5.02 | [-6.03, -3.93] | 100% | 1.000 | 712 |     
#> sigma       |       sigma |   2.66 | [ 2.10,  3.54] | 100% | 1.007 | 321 |     
#>             |             |        |                |      |       |     |     
#> R2          |             |        |                |      |       |     | 0.82
#> R2 (adj.)   |             |        |                |      |       |     | 0.78
#> Sigma       |             |        |                |      |       |     | 2.69
# }
```
