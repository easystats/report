
report <img src='man/figures/logo.png' align="right" height="139" />
====================================================================

[![Build Status](https://travis-ci.org/neuropsychology/report.svg?branch=master)](https://travis-ci.org/neuropsychology/report) [![codecov](https://codecov.io/gh/neuropsychology/report/branch/master/graph/badge.svg)](https://codecov.io/gh/neuropsychology/report) [![HitCount](http://hits.dwyl.io/DominiqueMakowski/bayestestR.svg)](http://hits.dwyl.io/neuropsychology/report) [![Documentation](https://img.shields.io/badge/documentation-report-orange.svg?colorB=E91E63)](https://neuropsychology.github.io/report/) 

***"From R to Manuscript"***

`report`'s primary goal is to fill the gap between R's output and the formatted result description of your manuscript, with the automated use of **best practices** guidelines, ensuring **standardization** and **quality** of results reporting.

Contribute
----------

**`report` is a young package in need of affection**. You can easily hop aboard the [developpment](.github/CONTRIBUTING.md) of this open-source software and improve psychological science by doing the following:

-   Create or check existing <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_bug.png" height="25"></a> issues to report, replicate, understand or solve some bugs.
-   Create or check existing <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_featureidea.png" height="25"></a> issues to suggest or discuss a new feature.
-   Check existing <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_help.png" height="25"></a> issues to see things that we'd like to implement, but where help is needed to do it.
-   Check existing <a href=https://github.com/neuropsychology/report/issues><img src="man/figures/issue_opinion.png" height="25"></a> issues to give your opinion and participate in package's design discussions.

Don't be shy, try to code and submit a pull request (See the [contributing guide](.github/CONTRIBUTING.md)). Even if unperfect, we will help you make it great! All contributors will be very graciously rewarded someday :smirk:.

Installation
------------

Run the following:

``` r
install.packages("devtools")
devtools::install_github("neuropsychology/report")
```

``` r
library("report")
```

Report all the things <a href=https://neuropsychology.github.io/Psycho.jl/latest/><img src="https://www.memecreator.org/static/images/templates/2776.jpg" height="100"></a> -->
---------------------

<!-- Add this to the README manually! -->
<!-- <a href=https://neuropsychology.github.io/Psycho.jl/latest/><img src="https://www.memecreator.org/static/images/templates/2776.jpg" height="100"></a> -->
### General Workflow

The `report` package works in a two steps fashion. First, creating a `report` object with the `report()` function (which takes different arguments depending on the type of object you are reporting). Then, this report can be displayed either textually, using `to_text()`, or as a table, using `to_table()`. Moreover, you can also access a more detailed (but less digest) version of the report using `to_fulltext()` and `to_fulltable()`.

### Dataframes

``` r
report(iris)
## The data contains 150 observations of the following variables:
##   - Sepal.Length: Mean = 5.84 +- 0.83 [4.30, 7.90]
##   - Sepal.Width: Mean = 3.06 +- 0.44 [2.00, 4.40]
##   - Petal.Length: Mean = 3.76 +- 1.77 [1.00, 6.90]
##   - Petal.Width: Mean = 1.20 +- 0.76 [0.10, 2.50]
##   - Species: 3 levels: setosa (33.33%); versicolor (33.33%); virginica (33.33%)
```

``` r
to_table(report(iris, median = TRUE))
```

| Variable     | Level      |  n\_Obs|  perc\_Obs|  n\_Missing|  Median|     MAD|  Min|  Max|
|:-------------|:-----------|-------:|----------:|-----------:|-------:|-------:|----:|----:|
| Species      | setosa     |      50|      33.33|           0|        |        |     |     |
| Species      | versicolor |      50|      33.33|           0|        |        |     |     |
| Species      | virginica  |      50|      33.33|           0|        |        |     |     |
| Petal.Length |            |     150|           |           0|    4.35|  1.8532|  1.0|  6.9|
| Petal.Width  |            |     150|           |           0|    1.30|  1.0378|  0.1|  2.5|
| Sepal.Width  |            |     150|           |           0|    3.00|  0.4448|  2.0|  4.4|

Credits
-------

You can cite the package as following:

-   Makowski, (2019). *Automated reporting of statistical models in R*. CRAN. doi: .

Please remember that parts of the code in this package was inspired / shamelessly copied from other great packages that you must check out and cite, such as [sjstats](https://github.com/strengejacke/sjstats). All credits go to their authors.
