
# report <img src='man/figures/logo.png' align="right" height="139" />

[![Build
Status](https://travis-ci.org/neuropsychology/report.svg?branch=master)](https://travis-ci.org/neuropsychology/report)
[![codecov](https://codecov.io/gh/neuropsychology/report/branch/master/graph/badge.svg)](https://codecov.io/gh/neuropsychology/report)
[![HitCount](http://hits.dwyl.io/DominiqueMakowski/bayestestR.svg)](http://hits.dwyl.io/neuropsychology/report)
[![Documentation](https://img.shields.io/badge/documentation-report-orange.svg?colorB=E91E63)](https://neuropsychology.github.io/report/)

***“From R to Manuscript”***

`report`’s primary goal is to fill the gap between R’s output and the
formatted result description of your manuscript, with the automated use
of **best practices** guidelines (*e.g.,* [APA’s style
guide](https://www.apastyle.org/)), ensuring **standardization** and
**quality** of results reporting.

**Note: this package is the heir and successor to the
[psycho](https://github.com/neuropsychology/psycho.R) package.**

## Contribute

**`report` is a young package in need of affection**. You can easily hop
aboard the [developpment](.github/CONTRIBUTING.md) of this open-source
software and improve psychological science by doing the following:

  - Create or check existing
    <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_bug.png" height="25"></a>
    issues to report, replicate, understand or solve some bugs.
  - Create or check existing
    <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_featureidea.png" height="25"></a>
    issues to suggest or discuss a new feature.
  - Check existing
    <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_help.png" height="25"></a>
    issues to see things that we’d like to implement, but where help is
    needed to do it.
  - Check existing
    <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_opinion.png" height="25"></a>
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
devtools::install_github("neuropsychology/report")
```

``` r
library("report")
```

## Report all the things <a href=https://neuropsychology.github.io/Psycho.jl/latest/><img src="https://www.memecreator.org/static/images/templates/2776.jpg" height="100"></a>

### General Workflow

The `report` package works in a two steps fashion. First, creating a
`report` object with the `report()` function (which takes different
arguments depending on the type of object you are reporting). Then, this
report can be displayed either textually, using `to_text()`, or as a
table, using `to_table()`. Moreover, you can also access a more detailed
(but less digest) version of the report using `to_fulltext()` and
`to_fulltable()`. Finally, the `values()` makes it easy to access all
the internals of a model.

### Dataframes

``` r
report(iris)
```

``` r
print(report(iris), width=80)
## The data contains 150 observations of the following variables:
## - Sepal.Length: Mean = 5.84 +- 0.83 [4.30, 7.90]
## - Sepal.Width: Mean = 3.06 +- 0.44 [2.00, 4.40]
## - Petal.Length: Mean = 3.76 +- 1.77 [1.00, 6.90]
## - Petal.Width: Mean = 1.20 +- 0.76 [0.10, 2.50]
## - Species: 3 levels: setosa (n = 50); versicolor (n = 50); virginica (n = 50)
```

The reports nicely work within the *tidyverse*:

``` r
library(dplyr)

iris %>% 
  group_by(Species) %>% 
  report(median = TRUE)  # Display Median and MAD instead of Mean and SD
```

``` r
library(dplyr)

iris %>% 
  group_by(Species) %>% 
  report(median = TRUE) %>% 
  print(width=80)
## The data contains 150 observations, grouped by Species, of the following
## variables:
## - setosa (n = 50):
## - Sepal.Length: Median = 5.00 +- 0.30 [4.30, 5.80]
## - Sepal.Width: Median = 3.40 +- 0.37 [2.30, 4.40]
## - Petal.Length: Median = 1.50 +- 0.15 [1.00, 1.90]
## - Petal.Width: Median = 0.20 +- 0.00 [0.10, 0.60]
## - versicolor (n = 50):
## - Sepal.Length: Median = 5.90 +- 0.52 [4.90, 7.00]
## - Sepal.Width: Median = 2.80 +- 0.30 [2.00, 3.40]
## - Petal.Length: Median = 4.35 +- 0.52 [3.00, 5.10]
## - Petal.Width: Median = 1.30 +- 0.22 [1.00, 1.80]
## - virginica (n = 50):
## - Sepal.Length: Median = 6.50 +- 0.59 [4.90, 7.90]
## - Sepal.Width: Median = 3.00 +- 0.30 [2.20, 3.80]
## - Petal.Length: Median = 5.55 +- 0.67 [4.50, 6.90]
## - Petal.Width: Median = 2.00 +- 0.30 [1.40, 2.50]
```

### Correlations and t-tests

``` r
report(cor.test(iris$Sepal.Length, iris$Petal.Length))
```

    ## The Pearson's correlation between iris$Sepal.Length and iris$Petal.Length is
    ## positive, large and significant (r(148) = 0.87, 95% CI [0.83, 0.91], p < .001).

``` r
report(t.test(iris$Sepal.Length, iris$Petal.Length))
```

    ## The Welch Two Sample t-test suggests that the difference between
    ## iris$Sepal.Length and iris$Petal.Length (mean of x = 5.84, mean of y = 3.76,
    ## difference = 2.09) is significant (t(211.54) = 13.10, 95% CI [1.77, 2.40], p <
    ## .001).

### Linear Models (LM)

The difference between regular and full reports becomes obvious for more
complicated models.

``` r
model <- lm(Sepal.Length ~ Petal.Length + Species, data=iris)
r <- report(model)

to_text(r)
```

    ## We fitted a linear model to predict Sepal.Length with Petal.Length and Species.
    ## The model's explanatory power (R2) is of 0.84 (adj. R2 = 0.83). The model's
    ## intercept is at 3.68.
    ## 
    ## Within this model:
    ## - Petal.Length is significant (beta = 0.90, 95% CI [0.78, 1.03], p < .001) and
    ## large (Std. beta = 1.93).
    ## - Speciesversicolor is significant (beta = -1.60, 95% CI [-1.98, -1.22], p <
    ## .001) and very small (Std. beta = -1.93).
    ## - Speciesvirginica is significant (beta = -2.12, 95% CI [-2.66, -1.58], p <
    ## .001) and very small (Std. beta = -2.56).

``` r
to_fulltext(r)
```

    ## We fitted a linear model to predict Sepal.Length with Petal.Length and Species
    ## (formula = Sepal.Length ~ Petal.Length + Species). Effect sizes were labelled
    ## following Cohen's (1988) recommendations. The model explains a significant
    ## proportion of variance (R2 = 0.84, F(4, 146) = 249.40, p < .001, adj. R2 =
    ## 0.83). The model's intercept is at 3.68 (t = 34.72, 95% CI [3.47, 3.89], p <
    ## .001).
    ## 
    ## Within this model:
    ## - Petal.Length is positive, significant (beta = 0.90, t(146) = 13.96, 95% CI
    ## [0.78, 1.03], p < .001) and large (Std. beta = 1.93, Std. SE = 0.14, Std. 95%
    ## CI [1.66, 2.20]).
    ## - Speciesversicolor is negative, significant (beta = -1.60, t(146) = -8.28, 95%
    ## CI [-1.98, -1.22], p < .001) and very small (Std. beta = -1.93, Std. SE = 0.23,
    ## Std. 95% CI [-2.40, -1.47]).
    ## - Speciesvirginica is negative, significant (beta = -2.12, t(146) = -7.74, 95%
    ## CI [-2.66, -1.58], p < .001) and very small (Std. beta = -2.56, Std. SE = 0.33,
    ## Std. 95% CI [-3.21, -1.90]).

``` r
to_table(r, digits=2)
```

| Parameter         | beta   | CI\_low | CI\_high | p    |
| :---------------- | :----- | :------ | :------- | :--- |
| (Intercept)       | 3.68   | 3.47    | 3.89     | 0.00 |
| Petal.Length      | 0.90   | 0.78    | 1.03     | 0.00 |
| Speciesversicolor | \-1.60 | \-1.98  | \-1.22   | 0.00 |
| Speciesvirginica  | \-2.12 | \-2.66  | \-1.58   | 0.00 |

``` r
to_fulltable(r, digits=2)
```

| Parameter         | beta   | SE   | t      | DoF\_residual | CI\_low | CI\_high | p    | Std\_beta | Std\_SE | Std\_CI\_low | Std\_CI\_high |
| :---------------- | :----- | :--- | :----- | :------------ | :------ | :------- | :--- | :-------- | :------ | :----------- | :------------ |
| (Intercept)       | 3.68   | 0.11 | 34.72  | 146.00        | 3.47    | 3.89     | 0.00 | 1.50      | 0.19    | 1.12         | 1.87          |
| Petal.Length      | 0.90   | 0.06 | 13.96  | 146.00        | 0.78    | 1.03     | 0.00 | 1.93      | 0.14    | 1.66         | 2.20          |
| Speciesversicolor | \-1.60 | 0.19 | \-8.28 | 146.00        | \-1.98  | \-1.22   | 0.00 | \-1.93    | 0.23    | \-2.40       | \-1.47        |
| Speciesvirginica  | \-2.12 | 0.27 | \-7.74 | 146.00        | \-2.66  | \-1.58   | 0.00 | \-2.56    | 0.33    | \-3.21       | \-1.90        |

## Credits

You can put a **Star** on this repo, and cite the package as following:

  - Makowski, (2019). *Automated reporting of statistical models in R*.
    CRAN. doi: .

Please remember that parts of the code in this package were inspired
(*or shamelessly copied*) from other great packages, such as
[sjstats](https://github.com/strengejacke/sjstats). Please consider
citing them\!
