# Reporting Models' Bayes Factor

Create reports of Bayes factors for model comparison.

## Usage

``` r
# S3 method for class 'bayesfactor_models'
report(
  x,
  interpretation = "jeffreys1961",
  exact = TRUE,
  protect_ratio = TRUE,
  ...
)

# S3 method for class 'bayesfactor_inclusion'
report(
  x,
  interpretation = "jeffreys1961",
  exact = TRUE,
  protect_ratio = TRUE,
  ...
)
```

## Arguments

- x:

  Object of class `bayesfactor_inclusion`.

- interpretation:

  Effect size interpretation set of rules (see
  [interpret_bf](https://easystats.github.io/effectsize/reference/interpret_bf.html)).

- exact:

  Should very large or very small values be reported with a scientific
  format (e.g., 4.24e5), or as truncated values (as "\> 1000" and "\<
  1/1000").

- protect_ratio:

  Should values smaller than 1 be represented as ratios?

- ...:

  Arguments passed to or from other methods.

## Value

An object of class
[`report()`](https://easystats.github.io/report/reference/report.md).

## See also

Specific components of reports (especially for stats models):

- [`report_table()`](https://easystats.github.io/report/reference/report_table.md)

- [`report_parameters()`](https://easystats.github.io/report/reference/report_parameters.md)

- [`report_statistics()`](https://easystats.github.io/report/reference/report_statistics.md)

- [`report_effectsize()`](https://easystats.github.io/report/reference/report_effectsize.md)

- [`report_model()`](https://easystats.github.io/report/reference/report_model.md)

- [`report_priors()`](https://easystats.github.io/report/reference/report_priors.md)

- [`report_random()`](https://easystats.github.io/report/reference/report_random.md)

- [`report_performance()`](https://easystats.github.io/report/reference/report_performance.md)

- [`report_info()`](https://easystats.github.io/report/reference/report_info.md)

- [`report_text()`](https://easystats.github.io/report/reference/report_text.md)

Other types of reports:

- [`report_system()`](https://easystats.github.io/report/reference/report.sessionInfo.md)

- [`report_packages()`](https://easystats.github.io/report/reference/report.sessionInfo.md)

- [`report_participants()`](https://easystats.github.io/report/reference/report_participants.md)

- [`report_sample()`](https://easystats.github.io/report/reference/report_sample.md)

- [`report_date()`](https://easystats.github.io/report/reference/report_date.md)

Methods:

- [`as.report()`](https://easystats.github.io/report/reference/as.report.md)

Template file for supporting new models:

- [`report.default()`](https://easystats.github.io/report/reference/report.default.md)

## Examples

``` r
library(bayestestR)
# Bayes factor - models
mo0 <- lm(Sepal.Length ~ 1, data = iris)
mo1 <- lm(Sepal.Length ~ Species, data = iris)
mo2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
mo3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)
BFmodels <- bayesfactor_models(mo1, mo2, mo3, denominator = mo0)

r <- report(BFmodels)
r
#> Bayes factors were computed using the BIC approximation, by which BF10 =
#> exp((BIC0 - BIC1)/2). Compared to the (Intercept only) model (the least
#> supported model), we found extreme evidence (BF = 1.70e+29) in favour of the
#> Species model; extreme evidence (BF = 5.84e+55) in favour of the Species +
#> Petal.Length model (the most supported model); extreme evidence (BF = 2.20e+54)
#> in favour of the Species * Petal.Length model.

# Bayes factor - inclusion
inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)

r <- report(inc_bf)
r
#> Bayesian model averaging (BMA) was used to obtain the average evidence for each
#> predictor. Since each model has a prior probability (here we used subjective
#> prior odds of 1, 2, 3), it is possible to sum the prior probability of all
#> models that include a predictor of interest (the prior inclusion probability),
#> and of all models that do not include that predictor (the prior exclusion
#> probability). After the data are observed, we can similarly consider the sums
#> of the posterior models' probabilities to obtain the posterior inclusion
#> probability and the posterior exclusion probability. The change from prior to
#> posterior inclusion odds is the Inclusion Bayes factor. For each predictor,
#> averaging was done only across models that did not include any interactions
#> with that predictor; additionally, for each interaction predictor, averaging
#> was done only across models that contained the main effect from which the
#> interaction predictor was comprised. This was done to prevent Inclusion Bayes
#> factors from being contaminated with non-relevant evidence (see Mathot, 2017).
#> We found extreme evidence (BF = 3.90e+55) in favour of including Species, with
#> models including Species having an overall posterior probability of 95%;
#> extreme evidence (BF = 6.89e+26) in favour of including Petal.Length, with
#> models including Petal.Length having an overall posterior probability of 95%;
#> strong evidence (BF = 1/26.52) against including Petal.Length:Species, with
#> models including Petal.Length:Species having an overall posterior probability
#> of 5%.
as.data.frame(r)
#> Terms                | Pr(prior) | Pr(posterior) | Inclusion BF
#> ---------------------------------------------------------------
#> Species              |      0.43 |          0.95 |       128.00
#> Petal.Length         |      0.29 |          0.95 |        61.80
#> Petal.Length:Species |      0.43 |          0.05 |  1/-3.05e-01
#> 
#> Across matched models only.
#> With custom prior odds of [1, 2, 3].
```
