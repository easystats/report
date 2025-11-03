# Convenient formatting of text components

Convenient formatting of text components

## Usage

``` r
format_algorithm(x)

format_formula(x, what = "conditional")

format_model(x)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- what:

  The name of the item returned by
  [`insight::find_formula`](https://easystats.github.io/insight/reference/find_formula.html).

## Value

A character string.

A character string.

A character string.

## Examples

``` r
model <- lm(Sepal.Length ~ Species, data = iris)
format_algorithm(model)
#> [1] "OLS"

# Mixed models
library(lme4)
#> Loading required package: Matrix
model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
format_algorithm(model)
#> [1] "REML and nloptwrap optimizer"
model <- lm(Sepal.Length ~ Species, data = iris)
format_formula(model)
#> [1] "formula: Sepal.Length ~ Species"

# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
format_formula(model)
#> [1] "formula: Sepal.Length ~ Sepal.Width"
format_formula(model, "random")
#> [1] "formula: ~1 | Species"
model <- lm(Sepal.Length ~ Species, data = iris)
format_model(model)
#> [1] "linear model"

# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
format_model(model)
#> [1] "linear mixed model"
```
