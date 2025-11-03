# Reporting `BFBayesFactor` objects from the `BayesFactor` package

Interpretation of the Bayes factor output from the `BayesFactor`
package.

## Usage

``` r
# S3 method for class 'BFBayesFactor'
report(x, h0 = "H0", h1 = "H1", ...)

# S3 method for class 'BFBayesFactor'
report_statistics(x, table = NULL, ...)
```

## Arguments

- x:

  An object of class `BFBayesFactor`.

- h0, h1:

  Names of the null and alternative hypotheses.

- ...:

  Other arguments to be passed to
  [effectsize::interpret_bf](https://easystats.github.io/effectsize/reference/interpret_bf.html)
  and
  [insight::format_bf](https://easystats.github.io/insight/reference/format_bf.html).

- table:

  A `parameters` table (this argument is meant for internal use).

## Examples

``` r
# \donttest{
library(BayesFactor)
#> Loading required package: coda
#> ************
#> Welcome to BayesFactor 0.9.12-4.7. If you have questions, please contact Richard Morey (richarddmorey@gmail.com).
#> 
#> Type BFManual() to open the manual.
#> ************

rez <- BayesFactor::ttestBF(iris$Sepal.Width, iris$Sepal.Length)
report_statistics(rez, exact = TRUE) # Print exact BF
#> [1] "BF10 = 6.11e+107"
report(rez, h0 = "the null hypothesis", h1 = "the alternative")
#> [1] "There is extreme evidence in favour of the alternative over the null hypothesis (BF10 > 1000)."

rez <- BayesFactor::correlationBF(iris$Sepal.Width, iris$Sepal.Length)
report(rez)
#> [1] "There is anecdotal evidence in favour of H0 over H1 (BF01 = 1.96)."
# }
```
