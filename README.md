
# report <img src='man/figures/logo.png' align="right" height="139" />

[![Build
Status](https://travis-ci.org/easystats/report.svg?branch=master)](https://travis-ci.org/easystats/report)
[![codecov](https://codecov.io/gh/easystats/report/branch/master/graph/badge.svg)](https://codecov.io/gh/easystats/report)
[![HitCount](http://hits.dwyl.io/easystats/report.svg)](http://hits.dwyl.io/easystats/report)
[![Documentation](https://img.shields.io/badge/documentation-report-orange.svg?colorB=E91E63)](https://easystats.github.io/report/)

***“From R to Manuscript”***

`report`’s primary goal is to fill the gap between R’s output and the
formatted result description of your manuscript, with the automated use
of **best practices** guidelines (*e.g.,*
[APA](https://www.apastyle.org/)’s style guide), ensuring
**standardization** and **quality** of results reporting.

``` r
# Example
model <- lm(Sepal.Length ~ Species, data=iris)
report(model)
```

    ##  We fitted a linear model to predict Sepal.Length with Species. The model's explanatory power is
    ## substantial (R2 = 0.62, adj. R2 = 0.61). The model's intercept is at 5.01.
    ## 
    ## Within this model: 
    ##   - Speciesversicolor is significant (beta = 0.93, 95% CI [0.73, 1.13], p < .001) and large (std.
    ## beta = 1.12).
    ##   - Speciesvirginica is significant (beta = 1.58, 95% CI [1.38, 1.79], p < .001) and large (std. beta
    ## = 1.91).

## Documentation

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
a part of the [developping](.github/CONTRIBUTING.md) community of this
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
[contributing guide](.github/CONTRIBUTING.md)). Even if unperfect, we
will help you make it great\!

## Installation

Run the following:

``` r
install.packages("devtools")
devtools::install_github("easystats/report")
```

``` r
library("report")
```

## Report all the things <a href=https://easystats.github.io/Psycho.jl/latest/><img src="https://www.memecreator.org/static/images/templates/2776.jpg" height="100"></a>

### General Workflow

The `report` package works in a two steps fashion. First, creating a
`report` object with the `report()` function (which takes different
arguments depending on the type of object you are reporting). Then, this
report can be displayed either textually, using `to_text()`, or as a
table, using `to_table()`. Moreover, you can also access a more detailed
(but less digest) version of the report using `to_fulltext()` and
`to_fulltable()`. Finally, `to_values()` makes it easy to access all the
internals of a model.

### Supported Packages

Currently supported objects by **report** include
[`cor.test`](https://stat.ethz.ch/R-manual/R-patched/library/stats/html/cor.test.html),
[`t.test`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/t.test.html)
[`correlation`](https://github.com/easystats/correlation),
[`glm`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html),
[`lme4::merMod`](https://github.com/lme4/lme4/),
[`rstanarm::stanreg`](https://github.com/stan-dev/rstanarm).

### Examples

The `report()` function works on a variety of models, as well as
dataframes:

``` r
# Dataframe report
report(iris)
```

    ## The data contains 150 observations of the following variables:
    ##   - Sepal.Length: Mean = 5.84, SD = 0.83 [4.30, 7.90].
    ##   - Sepal.Width: Mean = 3.06, SD = 0.44 [2.00, 4.40].
    ##   - Petal.Length: Mean = 3.76, SD = 1.77 [1.00, 6.90].
    ##   - Petal.Width: Mean = 1.20, SD = 0.76 [0.10, 2.50].
    ##   - Species: 3 levels: setosa (n = 50); versicolor (n = 50) and virginica (n = 50).

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
```

|   | Parameter         |     beta |  CI\_low | CI\_high | p | Std\_beta |    Fit |
| - | :---------------- | -------: | -------: | -------: | -: | --------: | -----: |
| 1 | (Intercept)       |   3.6835 |   3.4738 |    3.893 | 0 |     1.497 |        |
| 2 | Petal.Length      |   0.9046 |   0.7765 |    1.033 | 0 |     1.928 |        |
| 3 | Speciesversicolor | \-1.6010 | \-1.9833 |  \-1.219 | 0 |   \-1.933 |        |
| 4 | Speciesvirginica  | \-2.1177 | \-2.6581 |  \-1.577 | 0 |   \-2.557 |        |
| 6 | R2                |          |          |          |   |           | 0.8367 |
| 7 | R2\_adjusted      |          |          |          |   |           | 0.8334 |

Finally, you can also find more details using `to_fulltext()`:

``` r
# Full report for a Bayesian logistic mixed model with effect sizes
library(rstanarm)

stan_glmer(vs ~ mpg + (1|cyl), data=mtcars, family="binomial") %>% 
  report(standardize=TRUE, effsize="cohen1988") %>% 
  to_fulltext()
```

    ##  We fitted a Bayesian logistic mixed model to predict vs with mpg (formula = vs ~ mpg). The model
    ## included cyl as random effects (formula = ~1 | cyl). The Region of Practical Equivalence (ROPE)
    ## percentage was defined as the proportion of the posterior distribution within the [-0.18, 0.18]
    ## range. Effect sizes were labelled following Cohen's (1988) recommendations. Prior distributions
    ## over parameters were all set as normal (mean = 0.00, SD = 0.41) distributions.
    ## 
    ##   The model's total explanatory power is substantial (R2's median = 0.57, MAD = 0.09, 90% CI [0.42,
    ## 0.69]). Within this model, the explanatory power related to the fixed effects alone (marginal R2's
    ## median) is of 0.23 (MAD = 0.27, 90% CI [0.48, 0.48]). The model's intercept, corresponding to mpg =
    ## 0, has a median of -4.86 (MAD = 4.30, 90% CI [-12.15, 2.06], pd = 86.62%, 1.80% in ROPE).
    ## 
    ## Within this model: 
    ##   - mpg has a probability of 84.50% of being positive (median = 0.21, MAD = 0.21, 90% CI [-0.14,
    ## 0.53]) and can be considered as not significant (41.50% in ROPE) and medium (std. Median = 1.37,
    ## std. MAD = 1.26, std. 90% CI [-0.68, 3.45]).

## Credits

If you like it, you can put a *star* on this repo, and cite the package
as following:

  - Makowski, D. & Lüdecke, D. (2019). *The report package for R:
    Ensuring the use of best practices for results reporting*. CRAN.
    doi: .
