
# report <img src='man/figures/logo.png' align="right" height="139" />

[![CRAN](http://www.r-pkg.org/badges/version/report)](https://cran.r-project.org/package=report)
[![downloads](http://cranlogs.r-pkg.org/badges/report)](https://cran.r-project.org/package=report)

***“From R to Manuscript”***

`report`’s primary goal is to bridge the gap between R’s output and the
formatted results contained in your manuscript. It automatically
produces reports of models and dataframes according to **best practice**
guidelines (*e.g.,* [APA](https://apastyle.apa.org/)’s style guide),
ensuring **standardization** and **quality** in results reporting.

``` r
library(report)

model <- lm(Sepal.Length ~ Species, data = iris)
report(model)
```

    ## We fitted a linear model (estimated using OLS) to predict Sepal.Length with Species (formula =
    ## Sepal.Length ~ Species). Standardized parameters were obtained by fitting the model on a
    ## standardized version of the dataset. Effect sizes were labelled following Funder's (2019)
    ## recommendations.
    ## 
    ## The model explains a significant and substantial proportion of variance (R2 = 0.62, F(2, 147) =
    ## 119.26, p < .001, adj. R2 = 0.61). The model's intercept, corresponding to Sepal.Length = 0 and
    ## Species = setosa, is at 5.01 (SE = 0.07, 95% CI [4.86, 5.15], p < .001). Within this model:
    ## 
    ##   - The effect of (Intercept) is positive and can be considered as very large and significant (b =
    ## 5.01, SE = 0.07, 95% CI [4.86, 5.15], std. beta = -1.01, p < .001).
    ##   - The effect of Species [versicolor] is positive and can be considered as very large and
    ## significant (b = 0.93, SE = 0.10, 95% CI [0.73, 1.13], std. beta = 1.12, p < .001).
    ##   - The effect of Species [virginica] is positive and can be considered as very large and significant
    ## (b = 1.58, SE = 0.10, 95% CI [1.38, 1.79], std. beta = 1.91, p < .001).

## Documentation

[![Documentation](https://img.shields.io/badge/documentation-report-orange.svg?colorB=E91E63)](https://easystats.github.io/report/)
[![Blog](https://img.shields.io/badge/blog-easystats-orange.svg?colorB=FF9800)](https://easystats.github.io/blog/posts/)
[![Features](https://img.shields.io/badge/features-report-orange.svg?colorB=2196F3)](https://easystats.github.io/report/reference/index.html)

The package documentation can be found
[**here**](https://easystats.github.io/report/). Check-out these
tutorials:

  - [Get
    Started](https://easystats.github.io/report/articles/report.html)
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
devtools::install_github("easystats/report")
```

``` r
library("report")
```

## Report all the things <a href=https://easystats.github.io/report/><img src="man/figures/allthethings.jpg" height="100"></a>

### General Workflow

The `report` package works in a two step fashion. First, you create a
`report` object with the `report()` function (which takes different
arguments depending on the type of object you are reporting). Then, this
report object can be displayed either textually, using `text_short()`,
or as a table, using `table_short()`. Moreover, you can access a more
detailed (but less digested) version of the report using `text_long()`
and `table_short()`.

[![workflow](man/figures/workflow.png)](https://easystats.github.io/report/)

The `report()` function works on a variety of models, as well as other
objects such as dataframes:

``` r
report(iris)
```

    ## The data contains 150 observations of the following variables:
    ## 
    ##   - Sepal.Length: Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04, range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.57, 0 missing
    ##   - Sepal.Width: Mean = 3.06, SD = 0.44, Median = 3.00, MAD = 0.44, range: [2, 4.40], Skewness = 0.32, Kurtosis = 0.18, 0 missing
    ##   - Petal.Length: Mean = 3.76, SD = 1.77, Median = 4.35, MAD = 1.85, range: [1, 6.90], Skewness = -0.27, Kurtosis = -1.40, 0 missing
    ##   - Petal.Width: Mean = 1.20, SD = 0.76, Median = 1.30, MAD = 1.04, range: [0.10, 2.50], Skewness = -0.10, Kurtosis = -1.34, 0 missing
    ##   - Species: 3 levels: setosa (n = 50, 33.33%); versicolor (n = 50, 33.33%) and virginica (n = 50, 33.33%)

These reports nicely work within the
[*tidyverse*](https://github.com/tidyverse) workflow:

``` r
cor.test(iris$Sepal.Length, iris$Petal.Length) %>% report()
```

    ## The Pearson's product-moment correlation between iris$Sepal.Length and iris$Petal.Length is positive, significant and very large (r = 0.87, 95% CI [0.83, 0.91], t(148) = 21.65, p < .001).

You can also create tables with the `table_short()` and `table_long()`
functions:

``` r
lm(Sepal.Length ~ Petal.Length + Species, data = iris) %>% report() %>% 
    table_short()
## Parameter            | Coefficient |             CI |      p | Coefficient (std.) |  Fit
## ----------------------------------------------------------------------------------------
## (Intercept)          |        3.68 | [ 3.47,  3.89] | < .001 |               1.50 |     
## Petal.Length         |        0.90 | [ 0.78,  1.03] | < .001 |               1.93 |     
## Species [versicolor] |       -1.60 | [-1.98, -1.22] | < .001 |              -1.93 |     
## Species [virginica]  |       -2.12 | [-2.66, -1.58] | < .001 |              -2.56 |     
##                      |             |                |        |                    |     
## R2                   |             |                |        |                    | 0.84
## R2 (adj.)            |             |                |        |                    | 0.83
```

### *t*-tests and correlations

``` r
t.test(mtcars$mpg ~ mtcars$am) %>% report()
```

    ## The Welch Two Sample t-test suggests that the difference of mtcars$mpg by mtcars$am (mean in group
    ## 0 = 17.15, mean in group 1 = 24.39) is significant (difference = -7.24, 95% CI [-11.28, -3.21],
    ## t(18.33) = -3.77, p < .01) and can be considered as very large (Cohen's d = -1.76).

### Report participants details

This can be useful to complete the **Participants** paragraph of your
manuscript.

``` r
data <- data.frame(Age = c(22, 23, 54, 21), Sex = c("F", "F", 
    "M", "M"))

paste(report_participants(data, spell_n = TRUE), "were recruited in the study by means of torture and coercion.")
## [1] "Four participants (Mean age = 30.0, SD = 16.0, range = [21, 54]; 50.0% females) were recruited in the study by means of torture and coercion."
```

## Credits

If you like it, you can put a *star* on this repo, and cite the package
as follows:

  - Makowski, D., Ben-Shachar, M. S., & Lüdecke, D. (2020). *The report
    package for R: Ensuring the use of best practices for results
    reporting*. CRAN.
