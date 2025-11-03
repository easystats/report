# Sample Description

Create sample description table (also referred to as "Table 1").

## Usage

``` r
report_sample(
  data,
  by = NULL,
  centrality = "mean",
  ci = NULL,
  ci_method = "wilson",
  ci_correct = FALSE,
  select = NULL,
  exclude = NULL,
  weights = NULL,
  total = TRUE,
  digits = 2,
  n = FALSE,
  group_by = NULL,
  ...
)
```

## Arguments

- data:

  A data frame for which descriptive statistics should be created.

- by:

  Character vector, indicating the column(s) for possible grouping of
  the descriptive table. Note that weighting (see `weights`) does not
  work with more than one grouping column.

- centrality:

  Character, indicates the statistics that should be calculated for
  numeric variables. May be `"mean"` (for mean and standard deviation)
  or `"median"` (for median and median absolute deviation) as summary.

- ci:

  Level of confidence interval for relative frequencies (proportions).
  If not `NULL`, confidence intervals are shown for proportions of
  factor levels.

- ci_method:

  Character, indicating the method how to calculate confidence intervals
  for proportions. Currently implemented methods are `"wald"` and
  `"wilson"`. Note that `"wald"` can produce intervals outside the
  plausible range of \[0, 1\], and thus it is recommended to prefer the
  `"wilson"` method. The formulae for the confidence intervals are:

  - `"wald"`:

    \$\$p \pm z \sqrt{\frac{p (1 - p)}{n}}\$\$

  - `"wilson"`:

    \$\$\frac{2np + z^2 \pm z \sqrt{z^2 + 4npq}}{2(n + z^2)}\$\$

    where `p` is the proportion (of a factor level), `q` is `1-p`, `z`
    is the critical z-score based on the interval level and `n` is the
    length of the vector (cf. *Newcombe 1998*, *Wilson 1927*).

- ci_correct:

  Logical, it `TRUE`, applies continuity correction. See *Newcombe 1998*
  for different correction-methods based on the chosen `ci_method`.

- select:

  Character vector, with column names that should be included in the
  descriptive table.

- exclude:

  Character vector, with column names that should be excluded from the
  descriptive table.

- weights:

  Character vector, indicating the name of a potential weight-variable.
  Reported descriptive statistics will be weighted by `weight`.

- total:

  Add a `Total` column.

- digits:

  Number of decimals.

- n:

  Logical, actual sample size used in the calculation of the reported
  descriptive statistics (i.e., without the missing values).

- group_by:

  Deprecated. Use `by` instead.

- ...:

  Arguments passed to or from other methods.

## Value

A data frame of class `report_sample` with variable names and their
related summary statistics.

## References

- Newcombe, R. G. (1998). Two-sided confidence intervals for the single
  proportion: comparison of seven methods. Statistics in Medicine. 17
  (8): 857–872

- Wilson, E. B. (1927). Probable inference, the law of succession, and
  statistical inference. Journal of the American Statistical
  Association. 22 (158): 209–212

## Examples

``` r
library(report)

report_sample(iris[, 1:4])
#> # Descriptive Statistics
#> 
#> Variable               |     Summary
#> ------------------------------------
#> Mean Sepal.Length (SD) | 5.84 (0.83)
#> Mean Sepal.Width (SD)  | 3.06 (0.44)
#> Mean Petal.Length (SD) | 3.76 (1.77)
#> Mean Petal.Width (SD)  | 1.20 (0.76)
report_sample(iris, select = c("Sepal.Length", "Petal.Length", "Species"))
#> # Descriptive Statistics
#> 
#> Variable                |     Summary
#> -------------------------------------
#> Mean Sepal.Length (SD)  | 5.84 (0.83)
#> Mean Petal.Length (SD)  | 3.76 (1.77)
#> Species [setosa], %     |        33.3
#> Species [versicolor], % |        33.3
#> Species [virginica], %  |        33.3
report_sample(iris, by = "Species")
#> # Descriptive Statistics
#> 
#> Variable               | setosa (n=50) | versicolor (n=50) | virginica (n=50) | Total (n=150)
#> ---------------------------------------------------------------------------------------------
#> Mean Sepal.Length (SD) |   5.01 (0.35) |       5.94 (0.52) |      6.59 (0.64) |   5.84 (0.83)
#> Mean Sepal.Width (SD)  |   3.43 (0.38) |       2.77 (0.31) |      2.97 (0.32) |   3.06 (0.44)
#> Mean Petal.Length (SD) |   1.46 (0.17) |       4.26 (0.47) |      5.55 (0.55) |   3.76 (1.77)
#> Mean Petal.Width (SD)  |   0.25 (0.11) |       1.33 (0.20) |      2.03 (0.27) |   1.20 (0.76)
report_sample(airquality, by = "Month", n = TRUE, total = FALSE)
#> # Descriptive Statistics
#> 
#> Variable             |            5 (n=31) |           6 (n=30)
#> ---------------------------------------------------------------
#> Mean Ozone (SD), n   |   23.62 (22.22), 26 |   29.44 (18.21), 9
#> Mean Solar.R (SD), n | 181.30 (115.08), 27 | 190.17 (92.88), 30
#> Mean Wind (SD), n    |    11.62 (3.53), 31 |   10.27 (3.77), 30
#> Mean Temp (SD), n    |    65.55 (6.85), 31 |   79.10 (6.60), 30
#> Mean Day (SD), n     |    16.00 (9.09), 31 |   15.50 (8.80), 30
#> 
#> Variable             |           7 (n=31) |           8 (n=31) |   9 (n=30) (n=153)
#> -----------------------------------------------------------------------------------
#> Mean Ozone (SD), n   |  59.12 (31.64), 26 |  59.96 (39.68), 26 |  31.45 (24.14), 29
#> Mean Solar.R (SD), n | 216.48 (80.57), 31 | 171.86 (76.83), 28 | 167.43 (79.12), 30
#> Mean Wind (SD), n    |    8.94 (3.04), 31 |    8.79 (3.23), 31 |   10.18 (3.46), 30
#> Mean Temp (SD), n    |   83.90 (4.32), 31 |   83.97 (6.59), 31 |   76.90 (8.36), 30
#> Mean Day (SD), n     |   16.00 (9.09), 31 |   16.00 (9.09), 31 |   15.50 (8.80), 30

# confidence intervals for proportions
set.seed(123)
d <- data.frame(x = factor(sample(letters[1:3], 100, TRUE, c(0.01, 0.39, 0.6))))
report_sample(d, ci = 0.95, ci_method = "wald") # ups, negative CI
#> # Descriptive Statistics
#> 
#> Variable |           Summary
#> ----------------------------
#> x [a], % |   1.0 [-1.0, 3.0]
#> x [b], % | 39.0 [29.4, 48.6]
#> x [c], % | 60.0 [50.4, 69.6]
report_sample(d, ci = 0.95, ci_method = "wilson") # negative CI fixed
#> # Descriptive Statistics
#> 
#> Variable |           Summary
#> ----------------------------
#> x [a], % |    1.0 [0.2, 5.4]
#> x [b], % | 39.0 [30.0, 48.8]
#> x [c], % | 60.0 [50.2, 69.1]
report_sample(d, ci = 0.95, ci_correct = TRUE) # continuity correction
#> # Descriptive Statistics
#> 
#> Variable |           Summary
#> ----------------------------
#> x [a], % |    1.0 [0.1, 6.2]
#> x [b], % | 39.0 [29.6, 49.3]
#> x [c], % | 60.0 [49.7, 69.5]
```
