# Automatic reporting of R objects

Create reports of different objects. See the documentation for your
object's class:

## Usage

``` r
report(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

A list-object of class `report`, which contains further list-objects
with a short and long description of the model summary, as well as a
short and long table of parameters and fit indices.

## Details

- [System and
  packages](https://easystats.github.io/report/reference/report.sessionInfo.md)
  (`sessionInfo`)

- [Dataframes and
  vectors](https://easystats.github.io/report/reference/report.data.frame.md)

- [Correlations and
  t-tests](https://easystats.github.io/report/reference/report.htest.md)
  (`htest`)

- [ANOVAs](https://easystats.github.io/report/reference/report.aov.md)
  (`aov, anova, aovlist, ...`)

- [Regression
  models](https://easystats.github.io/report/reference/report.lm.md)
  (`glm, lm, ...`)

- [Mixed
  models](https://easystats.github.io/report/reference/report.lm.md)
  (`glmer, lmer, glmmTMB, ...`)

- [Bayesian
  models](https://easystats.github.io/report/reference/report.stanreg.md)
  (`stanreg, brms...`)

- [Bayes
  factors](https://easystats.github.io/report/reference/report.bayesfactor_models.md)
  (from `bayestestR`)

- [Structural Equation Models
  (SEM)](https://easystats.github.io/report/reference/report.lavaan.md)
  (from `lavaan`)

- [Model
  comparison](https://easystats.github.io/report/reference/report.compare_performance.md)
  (from
  [`performance()`](https://easystats.github.io/performance/reference/compare_performance.html))

Most of the time, the object created by the `report()` function can be
further transformed, for instance summarized (using
[`summary()`](https://rdrr.io/r/base/summary.html)), or converted to a
table (using
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html)).

### Organization

`report_table` and `report_text` are the two distal representations of a
report, and are the two provided in `report()`. However, intermediate
steps are accessible (depending on the object) via specific functions
(e.g., `report_parameters`).

### Output

The `report()` function generates a report-object that contain in itself
different representations (e.g., text, tables, plots). These different
representations can be accessed via several functions, such as:

- **`as.report_text(r)`**: Detailed text.

- **`as.report_text(r, summary=TRUE)`**: Minimal text giving the minimal
  information.

- **`as.report_table(r)`**: Comprehensive table including most available
  indices.

- **`as.report_table(r, summary=TRUE)`**: Minimal table.

Note that for some report objects, some of these representations might
be identical.

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

library(report)

model <- t.test(mtcars$mpg ~ mtcars$am)
r <- report(model)

# Text
r
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The Welch Two Sample t-test testing the difference of mtcars$mpg by mtcars$am
#> (mean in group 0 = 17.15, mean in group 1 = 24.39) suggests that the effect is
#> negative, statistically significant, and large (difference = -7.24, 95% CI
#> [-11.28, -3.21], t(18.33) = -3.77, p = 0.001; Cohen's d = -1.41, 95% CI [-2.26,
#> -0.53])
summary(r)
#> The Welch Two Sample t-test testing the difference of mtcars$mpg by mtcars$am
#> (mean in group 0 = 17.15, mean in group 1 = 24.39) suggests that the effect is
#> negative, statistically significant, and large (difference = -7.24, 95% CI
#> [-11.28, -3.21], t(18.33) = -3.77, p = 0.001, Cohen's d = -1.41)

# Tables
as.data.frame(r)
#> Welch Two Sample t-test
#> 
#> Parameter  |     Group | Mean_Group1 | Mean_Group2 | Difference
#> ---------------------------------------------------------------
#> mtcars$mpg | mtcars$am |       17.15 |       24.39 |      -7.24
#> 
#> Parameter  |          95% CI | t(18.33) |     p | Cohen's d |  Cohen's d  CI
#> ----------------------------------------------------------------------------
#> mtcars$mpg | [-11.28, -3.21] |    -3.77 | 0.001 |     -1.41 | [-2.26, -0.53]
#> 
#> Alternative hypothesis: two.sided
summary(as.data.frame(r))
#> Difference |          95% CI | t(18.33) |     p | Cohen's d |  Cohen's d  CI
#> ----------------------------------------------------------------------------
#> -7.24      | [-11.28, -3.21] |    -3.77 | 0.001 |     -1.41 | [-2.26, -0.53]
#> 
#> Alternative hypothesis: two.sided
```
