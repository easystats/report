# Reports of Structural Equation Models (SEM)

Create a report for `lavaan` objects.

## Usage

``` r
# S3 method for class 'lavaan'
report(x, ...)

# S3 method for class 'lavaan'
report_performance(x, table = NULL, ...)
```

## Arguments

- x:

  Object of class `lavaan`.

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
# Structural Equation Models (SEM)
library(lavaan)
#> This is lavaan 0.6-21
#> lavaan is FREE software! Please report any bugs.
structure <- "ind60 =~ x1 + x2 + x3
              dem60 =~ y1 + y2 + y3
              dem60 ~ ind60"
model <- lavaan::sem(structure, data = PoliticalDemocracy)
r <- report(model)
#> Support for lavaan not fully implemented yet :(
r
#> NULL
summary(r)
#> Length  Class   Mode 
#>      0   NULL   NULL 
as.data.frame(r)
#> data frame with 0 columns and 0 rows
summary(as.data.frame(r))
#> < table of extent 0 x 0 >

# Specific reports
suppressWarnings(report_table(model))
#> Parameter     | Coefficient |       95% CI |     z |      p |  Component |     Fit
#> ----------------------------------------------------------------------------------
#> ind60 =~ x1   |        1.00 | [1.00, 1.00] |       | < .001 |    Loading |        
#> ind60 =~ x2   |        2.18 | [1.91, 2.45] | 15.59 | < .001 |    Loading |        
#> ind60 =~ x3   |        1.82 | [1.52, 2.12] | 11.96 | < .001 |    Loading |        
#> dem60 =~ y1   |        1.00 | [1.00, 1.00] |       | < .001 |    Loading |        
#> dem60 =~ y2   |        1.04 | [0.66, 1.43] |  5.33 | < .001 |    Loading |        
#> dem60 =~ y3   |        0.98 | [0.65, 1.30] |  5.89 | < .001 |    Loading |        
#> dem60 ~ ind60 |        1.37 | [0.53, 2.21] |  3.20 | 0.001  | Regression |        
#>               |             |              |       |        |            |        
#> Chi2          |             |              |       |        |            |    7.98
#> Chi2_df       |             |              |       |        |            |    8.00
#> p_Chi2        |             |              |       |        |            |    0.44
#> p_Baseline    |             |              |       |        |            |    0.00
#> GFI           |             |              |       |        |            |    0.97
#> AGFI          |             |              |       |        |            |    0.91
#> NFI           |             |              |       |        |            |    0.97
#> NNFI          |             |              |       |        |            |    1.00
#> CFI           |             |              |       |        |            |    1.00
#> RMSEA         |             |              |       |        |            |    0.00
#> RMSEA_CI_low  |             |              |       |        |            |    0.00
#> RMSEA_CI_high |             |              |       |        |            |    0.14
#> p_RMSEA       |             |              |       |        |            |    0.57
#> RMR           |             |              |       |        |            |    0.10
#> SRMR          |             |              |       |        |            |    0.03
#> RFI           |             |              |       |        |            |    0.95
#> PNFI          |             |              |       |        |            |    0.52
#> IFI           |             |              |       |        |            |    1.00
#> RNI           |             |              |       |        |            |    1.00
#> Loglikelihood |             |              |       |        |            | -778.27
#> AIC           |             |              |       |        |            | 1582.54
#> BIC           |             |              |       |        |            | 1612.67
#> BIC (adj.)    |             |              |       |        |            | 1571.69
suppressWarnings(report_performance(model))
#> The model is not significantly different from a baseline model (Chi2(8) = 7.98,
#> p = 0.435). The GFI (.97 > .95) suggest a satisfactory fit., The model is not
#> significantly different from a baseline model (Chi2(8) = 7.98, p = 0.435). The
#> AGFI (.91 > .90) suggest a satisfactory fit., The model is not significantly
#> different from a baseline model (Chi2(8) = 7.98, p = 0.435). The NFI (.97 >
#> .90) suggest a satisfactory fit., The model is not significantly different from
#> a baseline model (Chi2(8) = 7.98, p = 0.435). The NNFI (.00 > .90) suggest a
#> satisfactory fit., The model is not significantly different from a baseline
#> model (Chi2(8) = 7.98, p = 0.435). The CFI (.00 > .90) suggest a satisfactory
#> fit., The model is not significantly different from a baseline model (Chi2(8) =
#> 7.98, p = 0.435). The RMSEA (.00 < .05) suggest a satisfactory fit., The model
#> is not significantly different from a baseline model (Chi2(8) = 7.98, p =
#> 0.435). The SRMR (.03 < .08) suggest a satisfactory fit., The model is not
#> significantly different from a baseline model (Chi2(8) = 7.98, p = 0.435). The
#> RFI (.95 > .90) suggest a satisfactory fit., The model is not significantly
#> different from a baseline model (Chi2(8) = 7.98, p = 0.435). The PNFI (.52 >
#> .50) suggest a satisfactory fit. and The model is not significantly different
#> from a baseline model (Chi2(8) = 7.98, p = 0.435). The IFI (.00 > .90) suggest
#> a satisfactory fit.
# }
```
