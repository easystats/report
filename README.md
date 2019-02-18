
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
lm(Sepal.Length ~ Species, data=iris) %>% 
  report()
```

    ##  We fitted a linear model to predict Sepal.Length with Species. The model's explanatory power is
    ## substantial (R2 = 0.62, adj. R2 = 0.61). The model's intercept is at 5.01.
    ## 
    ## Within this model: 
    ##   - Speciesversicolor is significant (beta = 0.93, 95% CI [0.73, 1.13], p < .001) and large (Std.
    ## beta = 1.12).
    ##   - Speciesvirginica is significant (beta = 1.58, 95% CI [1.38, 1.79], p < .001) and large (Std. beta
    ## = 1.91).

## Documentation

The package documentation can be found
[**here**](https://easystats.github.io/report/). Check-out these
tutorials:

  - [Get
    Started](https://easystats.github.io/report/articles/report.html)
  - [Automated Interpretation of
    Metrics](https://easystats.github.io/report/articles/interpret_metrics.html)
  - [How to Cite
    Packages](https://easystats.github.io/report/articles/cite_packages.html)
  - [Supporting New
    Models](https://easystats.github.io/report/articles/supporting_new_models.html)

## Contribute

**`report` is a young package in need of affection**. You can easily hop
aboard the [developpment](.github/CONTRIBUTING.md) of this open-source
software and improve psychological science by doing the following:

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
will help you make it great\! All contributors will be very graciously
rewarded someday :smirk:.

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

### Dataframes

``` r
report(iris)
```

    ## The data contains 150 observations of the following variables:
    ##   - Sepal.Length: Mean = 5.84 +- 0.83 [4.30, 7.90]
    ##   - Sepal.Width: Mean = 3.06 +- 0.44 [2.00, 4.40]
    ##   - Petal.Length: Mean = 3.76 +- 1.77 [1.00, 6.90]
    ##   - Petal.Width: Mean = 1.20 +- 0.76 [0.10, 2.50]
    ##   - Species: 3 levels: setosa (n = 50); versicolor (n = 50); virginica (n = 50)

The reports nicely work within the
[*tidyverse*](https://github.com/tidyverse):

``` r
library(dplyr)

iris %>% 
  group_by(Species) %>% 
  report(median = TRUE, range = FALSE)  # Display only the Median and MAD
```

    ## The data contains 150 observations, grouped by Species, of the following variables:
    ## - setosa (n = 50):
    ##   - Sepal.Length: Median = 5.00 +- 0.30
    ##   - Sepal.Width: Median = 3.40 +- 0.37
    ##   - Petal.Length: Median = 1.50 +- 0.15
    ##   - Petal.Width: Median = 0.20 +- 0.00
    ## - versicolor (n = 50):
    ##   - Sepal.Length: Median = 5.90 +- 0.52
    ##   - Sepal.Width: Median = 2.80 +- 0.30
    ##   - Petal.Length: Median = 4.35 +- 0.52
    ##   - Petal.Width: Median = 1.30 +- 0.22
    ## - virginica (n = 50):
    ##   - Sepal.Length: Median = 6.50 +- 0.59
    ##   - Sepal.Width: Median = 3.00 +- 0.30
    ##   - Petal.Length: Median = 5.55 +- 0.67
    ##   - Petal.Width: Median = 2.00 +- 0.30

### Correlations and t-tests

``` r
report(cor.test(iris$Sepal.Length, iris$Petal.Length))
```

    ## The Pearson's correlation between iris$Sepal.Length and iris$Petal.Length is positive, large and
    ## significant (r(148) = 0.87, 95% CI [0.83, 0.91], p < .001).

``` r
report(t.test(iris$Sepal.Length, iris$Petal.Length))
```

    ## The Welch Two Sample t-test suggests that the difference between iris$Sepal.Length and
    ## iris$Petal.Length (mean of x = 5.84, mean of y = 3.76, difference = 2.09) is significant (t(211.54)
    ## = 13.10, 95% CI [1.77, 2.40], p < .001).

### Linear Models (LM)

``` r
model <- lm(Sepal.Length ~ Petal.Length + Species, data=iris)
r <- report(model)

to_text(r)
```

    ##  We fitted a linear model to predict Sepal.Length with Petal.Length and Species. The model's
    ## explanatory power is substantial (R2 = 0.84, adj. R2 = 0.83). The model's intercept is at 3.68.
    ## 
    ## Within this model: 
    ##   - Petal.Length is significant (beta = 0.90, 95% CI [0.78, 1.03], p < .001) and large (Std. beta =
    ## 1.93).
    ##   - Speciesversicolor is significant (beta = -1.60, 95% CI [-1.98, -1.22], p < .001) and large (Std.
    ## beta = -1.93).
    ##   - Speciesvirginica is significant (beta = -2.12, 95% CI [-2.66, -1.58], p < .001) and large (Std.
    ## beta = -2.56).

``` r
to_table(r)
```

|   | Parameter         | beta   | CI\_low | CI\_high | p    | Std\_beta | Fit  |
| - | :---------------- | :----- | :------ | :------- | :--- | :-------- | :--- |
| 1 | (Intercept)       | 3.68   | 3.47    | 3.89     | 0.00 | 1.50      |      |
| 2 | Petal.Length      | 0.90   | 0.78    | 1.03     | 0.00 | 1.93      |      |
| 3 | Speciesversicolor | \-1.60 | \-1.98  | \-1.22   | 0.00 | \-1.93    |      |
| 4 | Speciesvirginica  | \-2.12 | \-2.66  | \-1.58   | 0.00 | \-2.56    |      |
| 6 | R2                |        |         |          |      |           | 0.84 |
| 7 | R2\_adj           |        |         |          |      |           | 0.83 |

### General Linear Models (GLM)

The difference between regular and full reports becomes obvious for more
complicated models.

``` r
model <- glm(vs ~ wt + mpg, data=mtcars, family="binomial")
r <- report(model)

to_fulltext(r)
```

    ##  We fitted a logistic model to predict vs with wt and mpg (formula = vs ~ wt + mpg). Effect sizes
    ## were labelled following Chen's (2010) recommendations. The model's explanatory power is substantial
    ## (Tjur's R2 = 0.48). The model's intercept is at -12.54 (z = -1.48, 95% CI [-31.91, 2.92], p > .1).
    ## 
    ## Within this model: 
    ##   - wt is positive, not significant (beta = 0.58, SE = 1.18, z = 0.49, 95% CI [-1.92, 2.94], p > .1)
    ## and small (Std. beta = 0.57, Std. SE = 1.16, Std. 95% CI [-1.88, 2.87]).
    ##   - mpg is positive, significant (beta = 0.52, SE = 0.26, z = 2.01, 95% CI [0.09, 1.17], p < .05) and
    ## large (Std. beta = 3.16, Std. SE = 1.57, Std. 95% CI [0.56, 7.02]).

``` r
to_fulltable(r)
```

|   | Parameter   | beta    | SE   | CI\_low | CI\_high | z      | DoF\_residual | p    | Std\_beta | Std\_SE | Std\_CI\_low | Std\_CI\_high | Fit   |
| - | :---------- | :------ | :--- | :------ | :------- | :----- | :------------ | :--- | :-------- | :------ | :----------- | :------------ | :---- |
| 1 | (Intercept) | \-12.54 | 8.47 | \-31.91 | 2.92     | \-1.48 | 29            | 0.14 | \-0.14    | 0.51    | \-1.15       | 0.90          |       |
| 2 | wt          | 0.58    | 1.18 | \-1.92  | 2.94     | 0.49   | 29            | 0.62 | 0.57      | 1.16    | \-1.88       | 2.87          |       |
| 3 | mpg         | 0.52    | 0.26 | 0.09    | 1.17     | 2.01   | 29            | 0.04 | 3.16      | 1.57    | 0.56         | 7.02          |       |
| 5 | AIC         |         |      |         |          |        |               |      |           |         |              |               | 31.30 |
| 6 | BIC         |         |      |         |          |        |               |      |           |         |              |               | 35.70 |
| 7 | R2\_Tjur    |         |      |         |          |        |               |      |           |         |              |               | 0.48  |

## Credits

If you like it, you can put a **star** on this repo, and cite the
package as following:

  - Makowski, (2019). *Automated reporting of statistical models in R*.
    CRAN. doi: .
