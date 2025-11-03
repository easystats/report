# Reporting Datasets and Dataframes

Create reports for data frames.

## Usage

``` r
# S3 method for class 'character'
report(
  x,
  n_entries = 3,
  levels_percentage = "auto",
  missing_percentage = "auto",
  ...
)

# S3 method for class 'data.frame'
report(
  x,
  n = FALSE,
  centrality = "mean",
  dispersion = TRUE,
  range = TRUE,
  distribution = FALSE,
  levels_percentage = "auto",
  digits = 2,
  n_entries = 3,
  missing_percentage = "auto",
  ...
)

# S3 method for class 'factor'
report(x, levels_percentage = "auto", ...)

# S3 method for class 'numeric'
report(
  x,
  n = FALSE,
  centrality = "mean",
  dispersion = TRUE,
  range = TRUE,
  distribution = FALSE,
  missing_percentage = "auto",
  digits = 2,
  ...
)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- n_entries:

  Number of different character entries to show. Can be "all".

- levels_percentage:

  Show characters entries and factor levels by number or percentage. If
  "auto", then will be set to number and percentage if the length if n
  observations larger than 100.

- missing_percentage:

  Show missing by number (default) or percentage. If "auto", then will
  be set to number and percentage if the length if n observations larger
  than 100.

- ...:

  Arguments passed to or from other methods.

- n:

  Include number of observations for each individual variable.

- centrality:

  Character vector, indicating the index of centrality (either `"mean"`
  or `"median"`).

- dispersion:

  Show index of dispersion ([sd](https://rdrr.io/r/stats/sd.html) if
  `centrality = "mean"`, or [mad](https://rdrr.io/r/stats/mad.html) if
  `centrality = "median"`).

- range:

  Show range.

- distribution:

  Show kurtosis and skewness.

- digits:

  Number of significant digits.

## Value

An object of class
[`report()`](https://easystats.github.io/report/reference/report.md).

## Examples

``` r
r <- report(iris,
  centrality = "median", dispersion = FALSE,
  distribution = TRUE, missing_percentage = TRUE
)
r
#> The data contains 150 observations of the following 5 variables:
#> 
#>   - Sepal.Length: n = 150, Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04,
#> range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.55, 0% missing
#>   - Sepal.Width: n = 150, Mean = 3.06, SD = 0.44, Median = 3.00, MAD = 0.44,
#> range: [2, 4.40], Skewness = 0.32, Kurtosis = 0.23, 0% missing
#>   - Petal.Length: n = 150, Mean = 3.76, SD = 1.77, Median = 4.35, MAD = 1.85,
#> range: [1, 6.90], Skewness = -0.27, Kurtosis = -1.40, 0% missing
#>   - Petal.Width: n = 150, Mean = 1.20, SD = 0.76, Median = 1.30, MAD = 1.04,
#> range: [0.10, 2.50], Skewness = -0.10, Kurtosis = -1.34, 0% missing
#>   - Species: 3 levels, namely setosa (n = 50, 33.33%), versicolor (n = 50,
#> 33.33%) and virginica (n = 50, 33.33%)
summary(r)
#> The data contains 150 observations of the following 5 variables:
#> 
#>   - Sepal.Length: Median = 5.80, range: [4.30, 7.90], Skewness = 0.31, Kurtosis =
#> -0.55
#>   - Sepal.Width: Median = 3.00, range: [2, 4.40], Skewness = 0.32, Kurtosis =
#> 0.23
#>   - Petal.Length: Median = 4.35, range: [1, 6.90], Skewness = -0.27, Kurtosis =
#> -1.40
#>   - Petal.Width: Median = 1.30, range: [0.10, 2.50], Skewness = -0.10, Kurtosis =
#> -1.34
#>   - Species: 3 levels, namely setosa (n = 50), versicolor (n = 50) and virginica
#> (n = 50)
as.data.frame(r)
#> Variable     |      Level | n_Obs | percentage_Obs | Mean |   SD | Median
#> -------------------------------------------------------------------------
#> Sepal.Length |            |   150 |                | 5.84 | 0.83 |   5.80
#> Sepal.Width  |            |   150 |                | 3.06 | 0.44 |   3.00
#> Petal.Length |            |   150 |                | 3.76 | 1.77 |   4.35
#> Petal.Width  |            |   150 |                | 1.20 | 0.76 |   1.30
#> Species      |     setosa |    50 |          33.33 |      |      |       
#> Species      | versicolor |    50 |          33.33 |      |      |       
#> Species      |  virginica |    50 |          33.33 |      |      |       
#> 
#> Variable     |  MAD |  Min |  Max | Skewness | Kurtosis | percentage_Missing
#> ----------------------------------------------------------------------------
#> Sepal.Length | 1.04 | 4.30 | 7.90 |     0.31 |    -0.55 |                  0
#> Sepal.Width  | 0.44 | 2.00 | 4.40 |     0.32 |     0.23 |                  0
#> Petal.Length | 1.85 | 1.00 | 6.90 |    -0.27 |    -1.40 |                  0
#> Petal.Width  | 1.04 | 0.10 | 2.50 |    -0.10 |    -1.34 |                  0
#> Species      |      |      |      |          |          |                   
#> Species      |      |      |      |          |          |                   
#> Species      |      |      |      |          |          |                   
summary(as.data.frame(r))
#> Variable     |      Level | n_Obs | percentage_Obs | Median |  Min |  Max
#> -------------------------------------------------------------------------
#> Sepal.Length |            |       |                |   5.80 | 4.30 | 7.90
#> Sepal.Width  |            |       |                |   3.00 | 2.00 | 4.40
#> Petal.Length |            |       |                |   4.35 | 1.00 | 6.90
#> Petal.Width  |            |       |                |   1.30 | 0.10 | 2.50
#> Species      |     setosa |    50 |          33.33 |        |      |     
#> Species      | versicolor |    50 |          33.33 |        |      |     
#> Species      |  virginica |    50 |          33.33 |        |      |     
#> 
#> Variable     | Skewness | Kurtosis | percentage_Missing
#> -------------------------------------------------------
#> Sepal.Length |     0.31 |    -0.55 |                  0
#> Sepal.Width  |     0.32 |     0.23 |                  0
#> Petal.Length |    -0.27 |    -1.40 |                  0
#> Petal.Width  |    -0.10 |    -1.34 |                  0
#> Species      |          |          |                   
#> Species      |          |          |                   
#> Species      |          |          |                   

# grouped analysis using `{dplyr}` package
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
r <- iris %>%
  group_by(Species) %>%
  report()
r
#> The data contains 150 observations, grouped by Species, of the following 5
#> variables:
#> 
#> - setosa (n = 50):
#>   - Sepal.Length: n = 50, Mean = 5.01, SD = 0.35, Median = 5.00, MAD = 0.30,
#> range: [4.30, 5.80], Skewness = 0.12, Kurtosis = -0.25, 0 missing
#>   - Sepal.Width: n = 50, Mean = 3.43, SD = 0.38, Median = 3.40, MAD = 0.37,
#> range: [2.30, 4.40], Skewness = 0.04, Kurtosis = 0.95, 0 missing
#>   - Petal.Length: n = 50, Mean = 1.46, SD = 0.17, Median = 1.50, MAD = 0.15,
#> range: [1, 1.90], Skewness = 0.11, Kurtosis = 1.02, 0 missing
#>   - Petal.Width: n = 50, Mean = 0.25, SD = 0.11, Median = 0.20, MAD = 0.00,
#> range: [0.10, 0.60], Skewness = 1.25, Kurtosis = 1.72, 0 missing
#> 
#> - versicolor (n = 50):
#>   - Sepal.Length: n = 50, Mean = 5.94, SD = 0.52, Median = 5.90, MAD = 0.52,
#> range: [4.90, 7], Skewness = 0.11, Kurtosis = -0.53, 0 missing
#>   - Sepal.Width: n = 50, Mean = 2.77, SD = 0.31, Median = 2.80, MAD = 0.30,
#> range: [2, 3.40], Skewness = -0.36, Kurtosis = -0.37, 0 missing
#>   - Petal.Length: n = 50, Mean = 4.26, SD = 0.47, Median = 4.35, MAD = 0.52,
#> range: [3, 5.10], Skewness = -0.61, Kurtosis = 0.05, 0 missing
#>   - Petal.Width: n = 50, Mean = 1.33, SD = 0.20, Median = 1.30, MAD = 0.22,
#> range: [1, 1.80], Skewness = -0.03, Kurtosis = -0.41, 0 missing
#> 
#> - virginica (n = 50):
#>   - Sepal.Length: n = 50, Mean = 6.59, SD = 0.64, Median = 6.50, MAD = 0.59,
#> range: [4.90, 7.90], Skewness = 0.12, Kurtosis = 0.03, 0 missing
#>   - Sepal.Width: n = 50, Mean = 2.97, SD = 0.32, Median = 3.00, MAD = 0.30,
#> range: [2.20, 3.80], Skewness = 0.37, Kurtosis = 0.71, 0 missing
#>   - Petal.Length: n = 50, Mean = 5.55, SD = 0.55, Median = 5.55, MAD = 0.67,
#> range: [4.50, 6.90], Skewness = 0.55, Kurtosis = -0.15, 0 missing
#>   - Petal.Width: n = 50, Mean = 2.03, SD = 0.27, Median = 2.00, MAD = 0.30,
#> range: [1.40, 2.50], Skewness = -0.13, Kurtosis = -0.60, 0 missing
summary(r)
#> The data contains 150 observations, grouped by Species, of the following 5
#> variables:
#> 
#> - setosa (n = 50):
#>   - Sepal.Length: Mean = 5.01, SD = 0.35, range: [4.30, 5.80]
#>   - Sepal.Width: Mean = 3.43, SD = 0.38, range: [2.30, 4.40]
#>   - Petal.Length: Mean = 1.46, SD = 0.17, range: [1, 1.90]
#>   - Petal.Width: Mean = 0.25, SD = 0.11, range: [0.10, 0.60]
#> 
#> - versicolor (n = 50):
#>   - Sepal.Length: Mean = 5.94, SD = 0.52, range: [4.90, 7]
#>   - Sepal.Width: Mean = 2.77, SD = 0.31, range: [2, 3.40]
#>   - Petal.Length: Mean = 4.26, SD = 0.47, range: [3, 5.10]
#>   - Petal.Width: Mean = 1.33, SD = 0.20, range: [1, 1.80]
#> 
#> - virginica (n = 50):
#>   - Sepal.Length: Mean = 6.59, SD = 0.64, range: [4.90, 7.90]
#>   - Sepal.Width: Mean = 2.97, SD = 0.32, range: [2.20, 3.80]
#>   - Petal.Length: Mean = 5.55, SD = 0.55, range: [4.50, 6.90]
#>   - Petal.Width: Mean = 2.03, SD = 0.27, range: [1.40, 2.50]
as.data.frame(r)
#> Group      |     Variable | n_Obs | Mean |   SD | Median |  MAD |  Min |  Max
#> -----------------------------------------------------------------------------
#> setosa     | Sepal.Length |    50 | 5.01 | 0.35 |   5.00 | 0.30 | 4.30 | 5.80
#> setosa     |  Sepal.Width |    50 | 3.43 | 0.38 |   3.40 | 0.37 | 2.30 | 4.40
#> setosa     | Petal.Length |    50 | 1.46 | 0.17 |   1.50 | 0.15 | 1.00 | 1.90
#> setosa     |  Petal.Width |    50 | 0.25 | 0.11 |   0.20 | 0.00 | 0.10 | 0.60
#> versicolor | Sepal.Length |    50 | 5.94 | 0.52 |   5.90 | 0.52 | 4.90 | 7.00
#> versicolor |  Sepal.Width |    50 | 2.77 | 0.31 |   2.80 | 0.30 | 2.00 | 3.40
#> versicolor | Petal.Length |    50 | 4.26 | 0.47 |   4.35 | 0.52 | 3.00 | 5.10
#> versicolor |  Petal.Width |    50 | 1.33 | 0.20 |   1.30 | 0.22 | 1.00 | 1.80
#> virginica  | Sepal.Length |    50 | 6.59 | 0.64 |   6.50 | 0.59 | 4.90 | 7.90
#> virginica  |  Sepal.Width |    50 | 2.97 | 0.32 |   3.00 | 0.30 | 2.20 | 3.80
#> virginica  | Petal.Length |    50 | 5.55 | 0.55 |   5.55 | 0.67 | 4.50 | 6.90
#> virginica  |  Petal.Width |    50 | 2.03 | 0.27 |   2.00 | 0.30 | 1.40 | 2.50
#> 
#> Group      | Skewness | Kurtosis | n_Missing
#> --------------------------------------------
#> setosa     |     0.12 |    -0.25 |         0
#> setosa     |     0.04 |     0.95 |         0
#> setosa     |     0.11 |     1.02 |         0
#> setosa     |     1.25 |     1.72 |         0
#> versicolor |     0.11 |    -0.53 |         0
#> versicolor |    -0.36 |    -0.37 |         0
#> versicolor |    -0.61 |     0.05 |         0
#> versicolor |    -0.03 |    -0.41 |         0
#> virginica  |     0.12 |     0.03 |         0
#> virginica  |     0.37 |     0.71 |         0
#> virginica  |     0.55 |    -0.15 |         0
#> virginica  |    -0.13 |    -0.60 |         0
summary(as.data.frame(r))
#> Group      |     Variable | Mean |   SD |  Min |  Max | n_Missing
#> -----------------------------------------------------------------
#> setosa     | Sepal.Length | 5.01 | 0.35 | 4.30 | 5.80 |         0
#> setosa     |  Sepal.Width | 3.43 | 0.38 | 2.30 | 4.40 |         0
#> setosa     | Petal.Length | 1.46 | 0.17 | 1.00 | 1.90 |         0
#> setosa     |  Petal.Width | 0.25 | 0.11 | 0.10 | 0.60 |         0
#> versicolor | Sepal.Length | 5.94 | 0.52 | 4.90 | 7.00 |         0
#> versicolor |  Sepal.Width | 2.77 | 0.31 | 2.00 | 3.40 |         0
#> versicolor | Petal.Length | 4.26 | 0.47 | 3.00 | 5.10 |         0
#> versicolor |  Petal.Width | 1.33 | 0.20 | 1.00 | 1.80 |         0
#> virginica  | Sepal.Length | 6.59 | 0.64 | 4.90 | 7.90 |         0
#> virginica  |  Sepal.Width | 2.97 | 0.32 | 2.20 | 3.80 |         0
#> virginica  | Petal.Length | 5.55 | 0.55 | 4.50 | 6.90 |         0
#> virginica  |  Petal.Width | 2.03 | 0.27 | 1.40 | 2.50 |         0
```
