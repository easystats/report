# Reporting Bayesian Models

Create reports for Bayesian models. The description of the parameters
follows the Sequential Effect eXistence and sIgnificance Testing
framework (see [SEXIT
documentation](https://easystats.github.io/bayestestR/reference/sexit.html)).

## Usage

``` r
# S3 method for class 'stanreg'
report(x, ...)
```

## Arguments

- x:

  Object of class `lm` or `glm`.

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

- [`report.default()`](https://easystats.github.io/report/reference/report.default.md)

## Examples

``` r
# \donttest{
# Bayesian models
library(rstanarm)
#> This is rstanarm version 2.32.2
#> - See https://mc-stan.org/rstanarm/articles/priors for changes to default priors!
#> - Default priors may change, so it's safest to specify priors, even if equivalent to the defaults.
#> - For execution on a local, multicore CPU with excess RAM we recommend calling
#>   options(mc.cores = parallel::detectCores())
#> 
#> Attaching package: ‘rstanarm’
#> The following objects are masked from ‘package:brms’:
#> 
#>     dirichlet, exponential, get_y, lasso, ngrps
model <- suppressWarnings(stan_glm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 500))
r <- report(model)
r
#> We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
#> of 500 iterations and a warmup of 250) to predict mpg with qsec and wt
#> (formula: mpg ~ qsec + wt). Priors over parameters were all set as normal (mean
#> = 0.00, SD = 8.43; mean = 0.00, SD = 15.40) distributions. The model's
#> explanatory power is substantial (R2 = 0.81, 95% CI [0.71, 0.89], adj. R2 =
#> 0.79). The model's intercept, corresponding to qsec = 0 and wt = 0, is at 19.74
#> (95% CI [8.59, 29.70]). Within this model:
#> 
#>   - The effect of qsec (Median = 0.93, 95% CI [0.42, 1.48]) has a 100.00%
#> probability of being positive (> 0), 99.50% of being significant (> 0.30), and
#> 0.40% of being large (> 1.81). The estimation successfully converged (Rhat =
#> 1.001) but the indices are unreliable (ESS = 739)
#>   - The effect of wt (Median = -5.04, 95% CI [-5.96, -4.10]) has a 100.00%
#> probability of being negative (< 0), 100.00% of being significant (< -0.30),
#> and 100.00% of being large (< -1.81). The estimation successfully converged
#> (Rhat = 1.000) and the indices are reliable (ESS = 1033)
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
#> We fitted a Bayesian linear model to predict mpg with qsec and wt. Priors over
#> parameters were all set as normal (mean = 0.00, SD = 8.43; mean = 0.00, SD =
#> 15.40) distributions. The model's explanatory power is substantial (R2 = 0.81,
#> adj. R2 = 0.79). The model's intercept is at 19.74 (95% CI [8.59, 29.70]).
#> Within this model:
#> 
#>   - The effect of qsec (Median = 0.93, 95% CI [0.42, 1.48]) has 100.00%, 99.50%
#> and 0.40% probability of being positive (> 0), significant (> 0.30) and large
#> (> 1.81). The estimation successfully converged (Rhat = 1.001) but the indices
#> are unreliable (ESS = 739)
#>   - The effect of wt (Median = -5.04, 95% CI [-5.96, -4.10]) has 100.00%, 100.00%
#> and 100.00% probability of being negative (< 0), significant (< -0.30) and
#> large (< -1.81)
as.data.frame(r)
#> Parameter   | Median |         95% CI |     pd |  Rhat |  ESS
#> -------------------------------------------------------------
#> (Intercept) |  19.74 | [ 8.59, 29.70] | 99.70% | 1.002 |  668
#> qsec        |   0.93 | [ 0.42,  1.48] |   100% | 1.001 |  739
#> wt          |  -5.04 | [-5.96, -4.10] |   100% | 1.000 | 1033
#>             |        |                |        |       |     
#> ELPD        |        |                |        |       |     
#> LOOIC       |        |                |        |       |     
#> WAIC        |        |                |        |       |     
#> R2          |        |                |        |       |     
#> R2 (adj.)   |        |                |        |       |     
#> Sigma       |        |                |        |       |     
#> 
#> Parameter   |                   Prior |    Fit
#> ----------------------------------------------
#> (Intercept) | Normal (20.09 +- 15.07) |       
#> qsec        |   Normal (0.00 +- 8.43) |       
#> wt          |  Normal (0.00 +- 15.40) |       
#>             |                         |       
#> ELPD        |                         | -78.90
#> LOOIC       |                         | 157.80
#> WAIC        |                         | 157.55
#> R2          |                         |   0.81
#> R2 (adj.)   |                         |   0.79
#> Sigma       |                         |   2.64
# }
```
