# Changelog

## report 0.6.3

CRAN release: 2026-01-08

Bug fixes

- Hotfix patch for change in
  [`attr()`](https://rdrr.io/r/base/attr.html) in R-devel
  ([\#590](https://github.com/easystats/report/issues/590)) to prevent
  CRAN removal.

## report 0.6.2

CRAN release: 2025-11-03

Bug fixes

- Fixed issue where
  [`report_effectsize.htest()`](https://easystats.github.io/report/reference/report.htest.md)
  called internal effectsize functions with undefined `table` parameter
  ([\#459](https://github.com/easystats/report/issues/459))
- [`report.brmsfit()`](https://easystats.github.io/report/reference/report.brmsfit.md):
  significantly improved performance by using faster `method = "basic"`
  instead of `method = "refit"` for effect size calculation, reducing
  execution time from hours to minutes for large Bayesian models
  ([\#568](https://github.com/easystats/report/issues/568))
- [`report.brmsfit()`](https://easystats.github.io/report/reference/report.brmsfit.md):
  fix issue where report text was printed multiple times when different
  parameters had different priors
  ([\#543](https://github.com/easystats/report/issues/543))
- Fixed duplicated text output in
  [`report()`](https://easystats.github.io/report/reference/report.md)
  for glmmTMB objects by addressing both regex pattern and redundant CI
  information concatenation in
  [`report_info.lm()`](https://easystats.github.io/report/reference/report.lm.md)
  ([\#481](https://github.com/easystats/report/issues/481))
- Fixed issue with missing effect size for the Intercept term in type 3
  anova tables ([\#451](https://github.com/easystats/report/issues/451))

Minor changes \* Fixed a lot of linting issues across the package. \*
Increased test coverage across the package.

## report 0.6.1

CRAN release: 2025-02-07

Bug fixes

- Fixed CRAN check failures.

## report 0.6.0

CRAN release: 2025-01-26

Minor changes \* `report_htest_chi2` stops supporting rule “chen2010”
(following change in `effectsize`).

## report 0.5.9

CRAN release: 2024-07-10

Breaking

- Arguments named `group`, `at` and `group_by` will be deprecated in
  future releases. of *easystats* packages. Please use `by` instead.
  This affects following functions in *report*:

  - [`report_participants()`](https://easystats.github.io/report/reference/report_participants.md)
  - [`report_sample()`](https://easystats.github.io/report/reference/report_sample.md)

Minor changes

- `report` now supports reporting of Bayesian model comparison with
  variables of class
  [`brms::loo_compare`](https://mc-stan.org/loo/reference/loo_compare.html).
- `report` now supports reporting of BayesFactor objects with variables
  of class `BFBayesFactor`.
- [`report_sample()`](https://easystats.github.io/report/reference/report_sample.md)
  now suggests valid column names for misspelled columns in the
  `select`, `by`, `weights` and `exclude` arguments.

Bug fixes

- Fixed issues with incorrectly passing additional arguments to
  downstream functions in
  [`report()`](https://easystats.github.io/report/reference/report.md)
  for `htest` objects.

## report 0.5.8

CRAN release: 2023-12-07

New features

- [`report_s()`](https://easystats.github.io/report/reference/report_s.md)
  to report the interpretation of S- and p-values in an
  easy-to-understand language.

Major Changes

- This release changes the licensing model of
  [report](https://easystats.github.io/report/) to an MIT license.

Minor changes

- `report` now supports variables of class `htest` for the Chi2,
  Friedman test, Fisher’s exact test, and Kruskal-Wallis.

- `report` now supports variables of class `Date`, treating them like
  factors.

- `report` now supports objects of class `estimate_contrasts`, from
  easystats’
  [`modelbased::estimate_contrasts`](https://easystats.github.io/modelbased/reference/estimate_contrasts.html),
  outputting either the results in text form, or as a table.

- `report_sample`

  - now reports the weighted number of observations when data is both
    grouped an weighted.
  - gains `ci`, `ci_method` and `ci_adjust` arguments, to compute
    confidence intervals for proportions of factor levels. Currently,
    two different methods (*Wald* and *Wilson*) are available.
  - now works on grouped data frame, using the defined groups as values
    for the `group_by` argument.
  - can now summarize data based on more than one grouping variable
    (i.e. `group_by` is allowed to be longer than 1).

- The `print` method for `report_sample` gains a `layout` argument, to
  print tables either in `"horizontal"` or `"vertical"` layout.

Bug fixes

- Fixed issue in `report_participants`, which did not print the
  `"gender"` category for grouped output when that argument was written
  in lower-case. Gender now also supports more alternate spellings, and
  age converts the respective column to numeric.

- Fixed printing issue for intercept-only models.

## report 0.5.7

CRAN release: 2023-03-22

Hotfix for CRAN reverse dependency compatibility.

## report 0.5.6

CRAN release: 2023-02-05

Breaking Changes

- The minimum needed R version has been bumped to `3.6`.

Minor changes

- `report_sample` improvement
  - Gains an `n` argument to also optionally include sample size.
  - Fixes bug whereas the `total` parameter was not respected.
- `report_effectsize` improvement
  - For `t.test` (htest) objects, now support the `type` (one of
    `c("d", "g")`) and `rules` (one of
    `c"cohen1988", "sawilowsky2009", "gignac2016")`) arguments.

## report 0.5.5

CRAN release: 2022-08-22

BREAKING CHANGES

- The minimum needed R version is now bumped to 3.5.

Minor changes

- `report_participants` improvement
  ([@rempsyc](https://github.com/rempsyc),
  [\#260](https://github.com/easystats/report/issues/260))

  - Now correctly reports NA values as % missing

  - Adds support for country and race demographic information

BUG FIXES

- Fixed bug with truncated output about confidence interval distribution
  in
  [`report()`](https://easystats.github.io/report/reference/report.md).

## report 0.5.1

CRAN release: 2022-02-22

- Hotfix release to fix failing tests and to unarchive package on CRAN.

## report 0.5.0

CRAN release: 2022-01-30

BREAKING CHANGES

- The following functions have been removed from
  [report](https://easystats.github.io/report/) and now live in
  [`{datawizard}`](https://easystats.github.io/datawizard/reference/index.html)
  package:

Data wrangling helpers:

- `data_addprefix()`

- `data_addsuffix()`

- `data_findcols()`

- `data_remove()`

- `data_rename()`

- `data_reorder()`

Text formatting helpers:

- `format_text()`

- `text_fullstop()`

- `text_lastchar()`

- `text_concatenate()`

- `text_paste()`

- `text_remove()`

- `text_wrap()`

MAJOR CHANGES

- Reporting participant’s sex/gender information has improved (thanks to
  [@drfeinberg](https://github.com/drfeinberg),
  [\#212](https://github.com/easystats/report/issues/212))

  - Separated sex and gender into different searches/columns

  - Sex is reported % female, % male, % other, % missing if any cases
    are missing

  - Gender is reported % Women, % Men, % Non-Binary, % missing if any
    cases are missing

  - Age reports % missing if any cases are missing.

## report 0.4.0

CRAN release: 2021-09-30

- Maintenance release.

## report 0.3.5

CRAN release: 2021-06-10

- Fixed issue with possibly wrong numbers in the `total` column from
  [`report_sample()`](https://easystats.github.io/report/reference/report_sample.md),
  when grouping variable contained missing values.

## report 0.3.1

- Added support for models of class `ivreg` (*ivreg*).

## report 0.3.0

CRAN release: 2021-04-15

- Initial release of the package.
