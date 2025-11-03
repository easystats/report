# Citation formatting

Convenience functions to manipulate and format citations. Only works
with APA formatted citations, for now.

## Usage

``` r
format_citation(citation, authorsdate = FALSE, short = FALSE, intext = FALSE)

cite_citation(citation)

clean_citation(citation)
```

## Arguments

- citation:

  A character string of a citation.

- authorsdate:

  Only show authors and date (remove title, journal, etc.).

- short:

  If more than one authors, replace by `et al.`

- intext:

  Remove brackets around the date (so that it can be placed inside
  larger parentheses).

## Value

A character string.

## Examples

``` r
library(report)

citation <- "Makowski, D., Ben-Shachar, M. S., Patil, I., & Ludecke, D. (2020).
Methods and Algorithms for Correlation Analysis in R. Journal of Open Source
Software, 5(51), 2306."

format_citation(citation, authorsdate = TRUE)
#> [1] "Makowski, Ben-Shachar, Patil, & Ludecke (2020)"
format_citation(citation, authorsdate = TRUE, short = TRUE)
#> [1] "Makowski et al. (2020)"
format_citation(citation, authorsdate = TRUE, short = TRUE, intext = TRUE)
#> [1] "Makowski et al., 2020"

cite_citation(citation)
#> [1] "(Makowski et al., 2020)"
clean_citation(citation())
#> [1] "R Core Team (2025). _R: A Language and Environment for Statistical Computing_. R Foundation for Statistical Computing, Vienna, Austria. <https://www.R-project.org/>."
```
