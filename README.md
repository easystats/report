
# report <img src='man/figures/logo.png' align="right" height="139" />

[![CRAN](http://www.r-pkg.org/badges/version/report)](https://cran.r-project.org/package=report)
[![downloads](http://cranlogs.r-pkg.org/badges/report)](https://cran.r-project.org/package=report)
[![Build
Status](https://travis-ci.org/easystats/report.svg?branch=master)](https://travis-ci.org/easystats/report)
[![codecov](https://codecov.io/gh/easystats/report/branch/master/graph/badge.svg)](https://codecov.io/gh/easystats/report)

***“From R to Manuscript”***

`report`’s primary goal is to bridge the gap between R’s output and the
formatted results contained in your manuscript. It automatically
produces reports of models and dataframes according to **best practice**
guidelines (*e.g.,* [APA](https://www.apastyle.org/)’s style guide),
ensuring **standardization** and **quality** in results reporting.

``` r
library(report)

# Example
model <- lm(Sepal.Length ~ Species, data=iris)
report(model)
```

    ## We fitted a linear model to predict Sepal.Length with Species. The model's explanatory power is
    ## substantial (R2 = 0.62, adj. R2 = 0.61). The model's intercept is at 5.01. Within this model:
    ## 
    ##   - The effect of Species (versicolor) is positive and can be considered as very large and
    ## significant (beta = 0.93, 95% CI [0.73, 1.13], std. beta = 1.12, p < .001).
    ##   - The effect of Species (virginica) is positive and can be considered as very large and significant
    ## (beta = 1.58, 95% CI [1.38, 1.79], std. beta = 1.91, p < .001).

## Documentation

[![Documentation](https://img.shields.io/badge/documentation-report-orange.svg?colorB=E91E63)](https://easystats.github.io/report/)
[![Blog](https://img.shields.io/badge/blog-easystats-orange.svg?colorB=FF9800)](https://easystats.github.io/blog/posts/)
[![Features](https://img.shields.io/badge/features-report-orange.svg?colorB=2196F3)](https://easystats.github.io/report/reference/index.html)

The package documentation can be found
[**here**](https://easystats.github.io/report/). Check-out these
tutorials:

  - [Get
    Started](https://easystats.github.io/report/articles/report.html)
  - [Automated Interpretation of Metrics and Effect
    Sizes](https://easystats.github.io/report/articles/interpret_metrics.html)
  - [How to Cite
    Packages](https://easystats.github.io/report/articles/cite_packages.html)
  - [Supporting New
    Models](https://easystats.github.io/report/articles/supporting_new_models.html)

## Contribute

**`report` is a young package in need of affection**. You can easily be
a part of the [developing](.github/CONTRIBUTING.md) community of this
open-source software and improve science by doing the following:

  - Create or check existing
    <a href=https://github.com/easystats/report/issues><img src="man/figures/issue_bug.png" height="25"></a>
    issues to report, replicate, understand or solve some bugs.
  - Create or check existing
    <a href=https://github.com/easystats/report/issues><img src="man/figures/issue_featureidea.png" height="25"></a>
    issues to suggest or discuss a new feature.
  - Check existing
    <a href=https://github.com/easystats/report/issues><img src="man/figures/issue_help.png" height="25"></a>
    issues to see things that we’d like to implement, but where help is
    needed to do it.
  - Check existing
    <a href=https://github.com/easystats/report/issues><img src="man/figures/issue_opinion.png" height="25"></a>
    issues to give your opinion and participate in package’s design
    discussions.

Don’t be shy, try to code and submit a pull request (See the
[contributing guide](.github/CONTRIBUTING.md)). Even if it’s not
perfect, we will help you make it great\!

## Installation

Run the following:

``` r
install.packages("devtools")
devtools::install_github("easystats/performance")
devtools::install_github("easystats/parameters")
devtools::install_github("easystats/report")
```

``` r
library("report")
```

## Report all the things <a href=https://easystats.github.io/Psycho.jl/latest/><img src="https://www.memecreator.org/static/images/templates/2776.jpg" height="100"></a>

### General Workflow

The `report` package works in a two step fashion. First, you create a
`report` object with the `report()` function (which takes different
arguments depending on the type of object you are reporting). Then, this
report object can be displayed either textually, using `to_text()`, or
as a table, using `to_table()`. Moreover, you can access a more detailed
(but less digested) version of the report using `to_fulltext()` and
`to_fulltable()`. Finally, `to_values()` makes it easy to access all the
internals of a model.

### Features

The `report()` function works on a variety of models, as well as
dataframes:

``` r
# Dataframe report
report(iris)
```

    ## The data contains 150 observations of the following variables:
    ##   - Sepal.Length: Mean = 5.84, SD = 0.83, range: 4.30-7.90
    ##   - Sepal.Width: Mean = 3.06, SD = 0.44, range: 2-4.40
    ##   - Petal.Length: Mean = 3.76, SD = 1.77, range: 1-6.90
    ##   - Petal.Width: Mean = 1.20, SD = 0.76, range: 0.10-2.50
    ##   - Species: 3 levels: setosa (n = 50); versicolor (n = 50) and virginica (n = 50)

These reports nicely work within the
[*tidyverse*](https://github.com/tidyverse) workflow:

``` r
# Correlation report
cor.test(iris$Sepal.Length, iris$Petal.Length) %>% 
  report()
```

    ## The Pearson's product-moment correlation between iris$Sepal.Length and iris$Petal.Length is
    ## positive, significant and large (r = 0.87, p < .001).

You can also create tables with the `to_table()` and `to_fulltable()`
functions:

``` r
# Table report for a linear model
lm(Sepal.Length ~ Petal.Length + Species, data=iris) %>% 
  report() %>% 
  to_table()
## Parameter         | Coefficient |         95% CI |      p | Coefficient (std.) |  Fit
## -------------------------------------------------------------------------------------
## (Intercept)       |        3.68 |   [3.47, 3.89] | < .001 |               1.50 |     
## Petal.Length      |        0.90 |   [0.78, 1.03] | < .001 |               1.93 |     
## Speciesversicolor |       -1.60 | [-1.98, -1.22] | < .001 |              -1.93 |     
## Speciesvirginica  |       -2.12 | [-2.66, -1.58] | < .001 |              -2.56 |     
##                   |             |                |        |                    |     
## R2                |             |                |        |                    | 0.84
## R2 (adj.)         |             |                |        |                    | 0.83
```

Finally, you can also find more details using `to_fulltext()`:

``` r
# Full report for a Bayesian logistic mixed model with effect sizes
library(rstanarm)

stan_glmer(vs ~ mpg + (1|cyl), data=mtcars, family="binomial") %>% 
  report(standardize="smart", effsize="cohen1988") %>% 
  to_fulltext()
```

    ## We fitted a Bayesian logistic mixed model (estimated using MCMC sampling with 4 chains of 2000
    ## iterations and a warmup of 1000) to predict vs with mpg (formula = vs ~ mpg). The model included
    ## cyl as random effects (formula = ~1 | cyl). Priors over parameters were set as normal (mean = 0.00,
    ## SD = 0.41) distributions. The Region of Practical Equivalence (ROPE) percentage was defined as the
    ## proportion of the posterior distribution within the [-0.18, 0.18] range. The 89% Credible Intervals
    ## (CIs) were based on Highest Density Intervals (HDI). Parameters were scaled by the mean and the SD
    ## of the response variable. Effect sizes were labelled following Cohen's (1988) recommendations.
    ## 
    ## The model's explanatory power is substantial (R2's median = 0.57, 89% CI [0.43, 0.69] Within this
    ## model, the explanatory power related to the fixed effects alone (marginal R2's median) is of 0.24
    ## (89% CI [0.00, 0.48]). The model's intercept, corresponding to vs = 0, mpg = 0 and cyl = 0, is at
    ## -5.07 (89% CI [-11.97, 1.57], 2.33% in ROPE, std. median = 0.00). Within this model:
    ## 
    ##   - The effect of mpg has a probability of 85.75% of being positive and can be considered as medium
    ## and not significant (median = 0.23, 89% CI [-0.12, 0.53], 40.00% in ROPE, std. median = 1.37). The
    ## algorithm successfuly converged (Rhat = 1.001) and the estimates can be considered as stable (ESS =
    ## 1446).

## Examples

### Supported Packages

Currently supported objects by **report** include
[`cor.test`](https://stat.ethz.ch/R-manual/R-patched/library/stats/html/cor.test.html),
[`t.test`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/t.test.html),
[`correlation`](https://github.com/easystats/correlation),
[`glm`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html),
[`lme4::merMod`](https://github.com/lme4/lme4/),
[`rstanarm::stanreg`](https://github.com/stan-dev/rstanarm),
[`estimate`](https://github.com/easystats/estimate).

### *t*-tests and correlations

``` r
t.test(mtcars$mpg ~ mtcars$am) %>% 
  report()
```

    ## The Welch Two Sample t-test suggests that the difference of mtcars$mpg by mtcars$am (mean in group
    ## 0 = 17.15, mean in group 1 = 24.39, difference = -7.24) is significant (t(18.33) = -3.77, 95% CI
    ## [-11.28, -3.21], p < .01).

### Miscellaneous

#### Report participants details

``` r
data <- data.frame("Age" = c(22, 23, 54, 21),
                   "Sex" = c("F", "F", "M", "M"))

paste(report_participants(data, spell_n = TRUE),
      "were recruited in the study by means of torture and coercion.")
## [1] "Four participants (Mean age = 30.00, SD = 16.02, range: 21-54, 50.00% females) were recruited in the study by means of torture and coercion."
```

## Credits

If you like it, you can put a *star* on this repo, and cite the package
as follows:

  - Makowski & Lüdecke (2019). *The report package for R: Ensuring the
    use of best practices for results reporting*. CRAN. doi: .
